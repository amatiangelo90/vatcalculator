import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'order_from_storage_comunication_page.dart';

class OrderFromStorageScreen extends StatefulWidget {
  const OrderFromStorageScreen({Key key}) : super(key: key);

  static String routeName = 'order_from_storage';

  @override
  _OrderFromStorageScreenState createState() => _OrderFromStorageScreenState();
}

class _OrderFromStorageScreenState extends State<OrderFromStorageScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            backgroundColor: kPrimaryColor,
            key: _scaffoldKey,
            appBar: AppBar(
              actions: [
                IconButton(onPressed: (){
                  //dataBundleNotifier.clearUnloadProductList();
                }, icon: Icon(Icons.clear, color: kPinaColor, size: getProportionateScreenWidth(20),))
              ],
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: getProportionateScreenHeight(20),),
              ),
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              title: Column(
                children: [
                  Text(dataBundleNotifier.currentStorage.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(17)),),
                  Text('Effettua Ordine', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: getProportionateScreenHeight(11)),),
                ],
              ),
            ),
            bottomSheet: Container(
              color: kPrimaryColor,
              child: Padding(
                padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
                child: DefaultButton(
                  color: Colors.green,
                  text: 'Effettua Ordine',
                  press: () async {
                    int stockProductDiffentThan0 = 0;
                    Map<int, List<StorageProductModel>> orderedMapBySuppliers = {};
                    dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated.forEach((element) {
                      if(element.extra != 0){
                        stockProductDiffentThan0 = stockProductDiffentThan0 + 1;

                        if(orderedMapBySuppliers.keys.contains(element.supplierId)){
                          orderedMapBySuppliers[element.supplierId].add(element);
                        }else{
                          orderedMapBySuppliers[element.supplierId] = [element];
                        }
                      }
                    });
                    if(stockProductDiffentThan0 == 0){
                      _scaffoldKey.currentState.showSnackBar(const SnackBar(
                        backgroundColor: kPinaColor,
                        content: Text('Immettere quantità per almeno un prodotto'),
                      ));
                    }else{
                      Map<int, List<StorageProductModel>> recapMapForCustomer = orderedMapBySuppliers;

                      orderedMapBySuppliers.forEach((fkSupplierId, storageProductModelList) async {
                        String code = DateTime.now().microsecondsSinceEpoch.toString().substring(3,16);
                        Response performSaveOrderId = await dataBundleNotifier.getclientServiceInstance().performSaveOrder(
                            orderModel: OrderModel(
                                code: code,
                                details: 'Ordine eseguito da ' + dataBundleNotifier.userDetailsList[0].firstName + ' ' +
                                    dataBundleNotifier.userDetailsList[0].lastName + ' per ' +
                                    dataBundleNotifier.currentBranch.companyName + '. Da consegnare in ${dataBundleNotifier.currentStorage.address} a ${dataBundleNotifier.currentStorage.city} CAP: ${dataBundleNotifier.currentStorage.cap.toString()}.',
                                total: 0.0,
                                status: OrderState.DRAFT,
                                creation_date: DateTime.now().millisecondsSinceEpoch,
                                delivery_date: null,
                                fk_branch_id: dataBundleNotifier.currentBranch.pkBranchId,
                                fk_storage_id: dataBundleNotifier.currentStorage.pkStorageId,
                                fk_user_id: dataBundleNotifier.userDetailsList[0].id,
                                pk_order_id: 0,
                                fk_supplier_id: fkSupplierId,
                                paid: 'false'
                            ),
                            actionModel: ActionModel(
                                date: DateTime.now().millisecondsSinceEpoch,
                                description: 'Ha creato l\'ordine bozza #$code per il fornitore ${dataBundleNotifier.getSupplierName(fkSupplierId)} per conto di ' + dataBundleNotifier.currentBranch.companyName + ' a fronte dello scarico da magazzino ${dataBundleNotifier.currentStorage.name}.',
                                fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                type: ActionType.DRAFT_ORDER_CREATION
                            )
                        );

                        storageProductModelList.forEach((storageProductModelItem) {
                          print('Create relation between ' + performSaveOrderId.data.toString() + ' and : ' + storageProductModelItem.fkProductId.toString() + ' - Stock: ' +  storageProductModelItem.extra.toString());
                          dataBundleNotifier.getclientServiceInstance().performSaveProductIntoOrder(
                              storageProductModelItem.extra,
                              storageProductModelItem.fkProductId,
                              performSaveOrderId.data
                          );
                        });
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderFromStorageComunicationPage(orderedMapBySuppliers: recapMapForCustomer ,),),);
                    }
                  },
                ),
              ),
            ),

            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: buildCurrentListProdutctTableForStockManagmentUnload(dataBundleNotifier, context),
                  ),
                  const SizedBox(height: 80,),
                ],
              ),
            ),
          );
        }
    );
  }

  buildCurrentListProdutctTableForStockManagmentUnload(DataBundleNotifier dataBundleNotifier, context){
    List<Widget> rows = [
    ];

    dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated.forEach((element) {
      TextEditingController controller;
      if(element.extra > 0){
        controller = TextEditingController(text: element.extra.toString());
      }else{
        controller = TextEditingController();
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(200),
                  child: Text(element.productName, overflow: TextOverflow.clip, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenWidth(18)),),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        FontAwesomeIcons.dotCircle,
                        color: Colors.grey,
                        size: getProportionateScreenWidth(3),
                      ),
                    ),
                    dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? Text('',style:
                    TextStyle(fontSize: getProportionateScreenWidth(8))) : Text(
                        element.price.toString() + ' € / ',
                        style:
                        TextStyle(fontSize: getProportionateScreenWidth(10), fontWeight: FontWeight.bold, color: Colors.white)
                    ),
                    Text(
                      element.unitMeasure,
                      style: TextStyle(fontSize: getProportionateScreenWidth(10), fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        FontAwesomeIcons.dotCircle,
                        color: Colors.grey,
                        size: getProportionateScreenWidth(3),
                      ),
                    ),
                    Text(dataBundleNotifier.getSupplierName(element.supplierId), style: TextStyle(fontSize: 9)),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        FontAwesomeIcons.dotCircle,
                        color: Colors.grey,
                        size: getProportionateScreenWidth(3),
                      ),
                    ),
                    Row(
                      children: [
                        Text('Giacenza: ', style: TextStyle(fontSize: 9, )),
                        Text(element.stock.toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontSize: 9, color: element.stock > 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if(element.extra <= 0){
                      }else{
                        element.extra --;
                      }
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.minus, color: kPinaColor,),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(getProportionateScreenWidth(70), getProportionateScreenWidth(60))),
                  child: CupertinoTextField(
                    controller: controller,
                    onChanged: (text) {
                      element.extra = double.parse(text.replaceAll(',', '.'));
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    clearButtonMode: OverlayVisibilityMode.never,
                    textAlign: TextAlign.center,
                    autocorrect: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {

                    setState(() {
                      element.extra = element.extra + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.plus, color: Colors.green.shade900),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
      rows.add(Divider(height: 5.4, color: Colors.grey.withOpacity(0.2),));
    });
    return Column(
      children: rows,
    );
  }
}
