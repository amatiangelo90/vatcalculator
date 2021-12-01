import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/bundle_users_storage_supplier_forbranch.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';

import '../orders_screen.dart';

class OrderCompletionScreen extends StatefulWidget {
  const OrderCompletionScreen({Key key, this.orderModel, this.productList, }) : super(key: key);

  final OrderModel orderModel;
  final List<ProductOrderAmountModel> productList;

  @override
  State<OrderCompletionScreen> createState() => _OrderCompletionScreenState();
}

class _OrderCompletionScreenState extends State<OrderCompletionScreen> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.9,
      overlayWidget: LoaderOverlayWidget(),
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child){
          return Scaffold(
            bottomSheet: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 30,
                      child: CupertinoButton(
                          color: Colors.green,
                          child: Text('Ricevuto', style: const TextStyle(color: kCustomWhite),),
                          onPressed: (){
                            dataBundleNotifier.setEditOrderToFalse();
                            Widget cancelButton = TextButton(
                              child: const Text("Indietro", style: TextStyle(color: kPrimaryColor),),
                              onPressed:  () {
                                Navigator.of(context).pop();
                              },
                            );

                            Widget continueButton = TextButton(
                              child: const Text("Ricevuto", style: TextStyle(color: Colors.green)),
                              onPressed:  () async {
                                Navigator.of(context).pop();

                                context.loaderOverlay.show();
                                StorageModel storageModel = dataBundleNotifier.getStorageFromCurrentStorageListByStorageId(widget.orderModel.fk_storage_id);
                                await dataBundleNotifier.setCurrentStorage(storageModel);

                                print('Start adding order to current storage stock');

                                dataBundleNotifier.currentStorageProductListForCurrentStorage.forEach((element) {
                                  widget.productList.forEach((standardElement) {
                                    if (standardElement.pkProductId == element.fkProductId) {
                                      element.stock = element.stock + standardElement.amount;
                                    }
                                  });
                                });

                                print('Finish uploading storage stock');

                                ClientVatService getclientServiceInstance = dataBundleNotifier.getclientServiceInstance();

                                //TODO aggiungere lista merce aggiunta a fronte del carico
                                getclientServiceInstance.updateStock(
                                    currentStorageProductListForCurrentStorageUnload: dataBundleNotifier.currentStorageProductListForCurrentStorage,
                                    actionModel: ActionModel(
                                        date: DateTime.now().millisecondsSinceEpoch,
                                        description: 'Ha eseguito il carico nel magazzino ${storageModel.name} a fronte della ricezione dell\'ordine #${widget.orderModel.code} '
                                            'da parte del fornitore ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)}. ',
                                        fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                        user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                        type: ActionType.STORAGE_LOAD
                                    )
                                );
                                dataBundleNotifier.clearUnloadProductList();
                                dataBundleNotifier.refreshProductListAfterInsertProductIntoStorage();

                                await dataBundleNotifier.getclientServiceInstance().updateOrderStatus(
                                  orderModel: OrderModel(
                                      pk_order_id: widget.orderModel.pk_order_id,
                                      status: OrderState.RECEIVED_ARCHIVED,
                                      delivery_date: DateTime.now().millisecondsSinceEpoch,
                                      closedby: dataBundleNotifier.dataBundleList[0].firstName + ' ' + dataBundleNotifier.dataBundleList[0].lastName
                                  ),
                                  actionModel: ActionModel(
                                      date: DateTime.now().millisecondsSinceEpoch,
                                      description: 'Ha modificato in ${OrderState.RECEIVED_ARCHIVED} l\'ordine #${widget.orderModel.code} da parte del fornitore ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)}.',
                                      fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                      user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                      type: ActionType.RECEIVED_ORDER
                                  )
                                );
                                dataBundleNotifier.updateOrderStatusById(widget.orderModel.pk_order_id, OrderState.RECEIVED_ARCHIVED, DateTime.now().millisecondsSinceEpoch, dataBundleNotifier.dataBundleList[0].firstName + ' ' + dataBundleNotifier.dataBundleList[0].lastName);
                                dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OrdersScreen(),
                                  ),
                                );
                                context.loaderOverlay.hide();
                              },
                            );

                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog (
                                  actions: [
                                    ButtonBar(
                                      alignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        cancelButton,
                                        continueButton,
                                      ],
                                    ),
                                  ],
                                  contentPadding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(10.0))),
                                  content: Builder(
                                    builder: (context) {
                                      var height = MediaQuery.of(context).size.height;
                                      var width = MediaQuery.of(context).size.width;
                                      return SizedBox(
                                        height: getProportionateScreenHeight(300),
                                        width: width - 90,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(10.0),
                                                      topLeft: Radius.circular(10.0) ),
                                                  color: kPrimaryColor,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('  Completa Ordine ed Archivia',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: getProportionateScreenWidth(15),
                                                          fontWeight: FontWeight.bold,
                                                          color: kCustomWhite,
                                                        )),
                                                    IconButton(icon: const Icon(
                                                      Icons.clear,
                                                      color: kCustomWhite,
                                                    ), onPressed: () { Navigator.pop(context); },),

                                                  ],
                                                ),
                                              ),
                                              Text(''),
                                              Center(
                                                child: Text('Contrassegna ordine #${widget.orderModel.code.toString()} come ricevuto ed eseguire il carico per magazzino ${dataBundleNotifier.getStorageFromCurrentStorageListByStorageId(widget.orderModel.fk_storage_id).name}? ', textAlign: TextAlign.center,),
                                              ),
                                              Text(''),
                                              Text('Nota: Nel caso tu non abbia ricevuto l\'intero ordine puoi modificare le quantità cliccando sull\'icona ' , style: TextStyle(fontSize: getProportionateScreenHeight(12)), textAlign: TextAlign.center,),
                                              IconButton(
                                                icon: SvgPicture.asset('assets/icons/edit-cust.svg',
                                                  width: 20,
                                                  color: kPrimaryColor,
                                                ),
                                                onPressed: (){
                                                  dataBundleNotifier.switchEditOrder();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                            );
                          }),
                    ),
                  ),
                ),
              ],
            ),
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.deepOrangeAccent),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              automaticallyImplyLeading: true,
              title: const Text(
                'Dettaglio Ordine', style: TextStyle(color: Colors.deepOrangeAccent),
              ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Card(
                          child: Column(
                            children: [
                              Text(dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id), style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(25)),),
                              Text('#' + widget.orderModel.code, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(17)),),
                              Divider(endIndent: 40, indent: 40,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Creato da: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(getUserDetailsById(widget.orderModel.fk_user_id, widget.orderModel.fk_branch_id, dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Ordine creato il: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(buildDateFromMilliseconds(widget.orderModel.creation_date), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Magazzino: ', style: TextStyle(fontWeight: FontWeight.bold),),

                                  dataBundleNotifier.getStorageFromCurrentStorageListByStorageId(widget.orderModel.fk_storage_id) == null ? SizedBox(width: 0,) : Text(dataBundleNotifier.getStorageFromCurrentStorageListByStorageId(widget.orderModel.fk_storage_id).name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Stato: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(widget.orderModel.status, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Divider(endIndent: 40, indent: 40,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Da consegnare a: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  dataBundleNotifier.currentBranch == null ? Text('') : Text(dataBundleNotifier.currentBranch.companyName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('In via: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  dataBundleNotifier.currentBranch == null ? Text('') : Text(dataBundleNotifier.currentBranch.address, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Città: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  dataBundleNotifier.currentBranch == null ? Text('') : Text(dataBundleNotifier.currentBranch.city, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('CAP : ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  dataBundleNotifier.currentBranch == null ? Text('') : Text(dataBundleNotifier.currentBranch.cap.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Da consegnare il: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(buildDateFromMilliseconds(widget.orderModel.delivery_date), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              const Divider(endIndent: 40, indent: 40,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text('Dettagli'),
                              ),
                              Text(widget.orderModel.details,textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Carrello', style: TextStyle(color: kPinaColor, fontSize: getProportionateScreenHeight(20), fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: IconButton(
                                icon: SvgPicture.asset('assets/icons/pdf.svg', width: getProportionateScreenWidth(23),),


                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: IconButton(
                                icon: SvgPicture.asset('assets/icons/edit-cust.svg',
                                  width: getProportionateScreenWidth(dataBundleNotifier.editOrder ? 23 : 21),
                                  color: dataBundleNotifier.editOrder ? Colors.blueAccent : kPrimaryColor,
                                ),

                                onPressed: (){
                                  dataBundleNotifier.switchEditOrder();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  buildProductListWidget(context, dataBundleNotifier),
                  SizedBox(height: getProportionateScreenHeight(90),),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  buildProductListWidget(context, DataBundleNotifier dataBundleNotifier) {

    List<Widget> tableRowList = [
    ];

    widget.productList.forEach((currentProduct) {
      TextEditingController controller = TextEditingController(text: currentProduct.amount.toString());
      tableRowList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(currentProduct.nome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(16), color: kPrimaryColor),),
                Text(' (' + currentProduct.unita_misura + ')', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),),
              ],
            ),
            Row(
              children: [
                dataBundleNotifier.editOrder ? GestureDetector(
                  onTap: () {
                    setState(() {
                      if(currentProduct.amount <= 0){
                      }else{
                        currentProduct.amount --;
                      }
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.minus, color: kPinaColor,),
                  ),
                ) : SizedBox(height: 0,),
                ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(
                      getProportionateScreenWidth(70),
                      getProportionateScreenWidth(60))),
                  child: CupertinoTextField(
                    controller: controller,
                    enabled: dataBundleNotifier.editOrder,
                    onChanged: (text) {
                      if (double.tryParse(text) != null) {
                        currentProduct.amount = double.parse(text);
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text(
                              'Immettere un valore numerico corretto per ' +
                                  currentProduct.nome),
                        ));
                      }
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    clearButtonMode: OverlayVisibilityMode.never,
                    textAlign: TextAlign.center,
                    autocorrect: false,
                  ),
                ),
                dataBundleNotifier.editOrder ? GestureDetector(
                  onTap: () {
                    setState(() {
                      currentProduct.amount  =  currentProduct.amount + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.plus, color: Colors.green.shade900),
                  ),
                ) : SizedBox(height: 0,),
              ],
            ),
          ],
        ),
      );
      tableRowList.add(Divider(endIndent: 20, indent: 30,),);
    });

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: tableRowList,
      ),
    );
  }

  String getNiceNumber(String string) {
    if(string.contains('.00')){
      return string.replaceAll('.00', '');
    }else if(string.contains('.0')){
      return string.replaceAll('.0', '');
    }else {
      return string;
    }
  }

  String getUserDetailsById(
      int fkUserId,
      int fkBranchId,
      Map<int, BundleUserStorageSupplier> currentMapBranchIdBundleSupplierStorageUsers) {

    String currentUserName = '';
    currentMapBranchIdBundleSupplierStorageUsers.forEach((key, value) {
      if(key == fkBranchId){
        value.userModelList.forEach((user) {
          if(user.id == fkUserId){
            currentUserName = user.name + ' ' + user.lastName;
          }
        });
      }
    });
    return currentUserName;
  }

  String buildDateFromMilliseconds(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return dateTime.day.toString() + '/' + dateTime.month.toString() + '/' + dateTime.year.toString();
  }


}
