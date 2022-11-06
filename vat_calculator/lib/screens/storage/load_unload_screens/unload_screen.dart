import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../components/unload_comunication_page.dart';

class UnloadStorageScreen extends StatefulWidget {
  const UnloadStorageScreen({Key key}) : super(key: key);

  static String routeName = 'unload_screen_storage';

  @override
  _UnloadStorageScreenState createState() => _UnloadStorageScreenState();
}

class _UnloadStorageScreenState extends State<UnloadStorageScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              backgroundColor: kPrimaryColor,
              key: _scaffoldKey,
              appBar: AppBar(
                elevation: 5,
                actions: [
                  IconButton(onPressed: (){
                    dataBundleNotifier.clearLoadUnloadParameterOnEachProductForCurrentStorage();
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
                    Text('Sezione Scarico Magazzino', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: getProportionateScreenHeight(11)),),
                  ],
                ),
              ),
              bottomSheet: Container(
                color: kPrimaryColor,
                child: Padding(
                  padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
                  child: DefaultButton(
                    color: kCustomBordeaux,
                    text: 'Effettua Scarico',
                    press: () async {
                      int stockProductDiffentThan0 = 0;
                      Map<int, List<StorageProductModel>> orderedMapBySuppliers = {};
                      dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated.forEach((element) {

                        if(element.loadUnloadAmount != 0){
                          stockProductDiffentThan0 = stockProductDiffentThan0 + 1;

                          if(orderedMapBySuppliers.keys.contains(element.supplierId)){
                            orderedMapBySuppliers[element.supplierId].add(element);
                          }else{
                            orderedMapBySuppliers[element.supplierId] = [element];
                          }
                        }
                      });
                      if(stockProductDiffentThan0 == 0){

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text('Immettere la quantità di scarico per almeno un prodotto'),
                        ));
                      }else{
                        Map<int, List<StorageProductModel>> recapMapForCustomer = orderedMapBySuppliers;

                        orderedMapBySuppliers.forEach((fkSupplierId, storageProductModelList) async {
                         /* String code = DateTime.now().microsecondsSinceEpoch.toString().substring(3,16);*/
                          /*Response performSaveOrderId = await dataBundleNotifier.getclientServiceInstance().performSaveOrder(
                              orderModel: OrderModel(
                                paid: 'false',
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
                                fk_supplier_id: fkSupplierId
                              ),
                              actionModel: ActionModel(
                                  date: DateTime.now().millisecondsSinceEpoch,
                                  description: 'Ha creato l\'ordine bozza #$code per il fornitore ${dataBundleNotifier.getSupplierName(fkSupplierId)} per conto di ' + dataBundleNotifier.currentBranch.companyName + ' a fronte dello scarico da magazzino ${dataBundleNotifier.currentStorage.name}.',
                                  fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                  user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                  type: ActionType.DRAFT_ORDER_CREATION
                              )
                          );*/

                          storageProductModelList.forEach((storageProductModelItem) {
                            /*print('Create relation between ' + performSaveOrderId.data.toString() + ' and : ' + storageProductModelItem.fkProductId.toString() + ' - Stock: ' +  storageProductModelItem.loadUnloadAmount.toString());
*/
                            /*dataBundleNotifier.getclientServiceInstance().performSaveProductIntoOrder(
                                storageProductModelItem.loadUnloadAmount,
                                storageProductModelItem.fkProductId,
                                performSaveOrderId.data
                            );*/

                              if(storageProductModelItem.loadUnloadAmount > 0){

                                storageProductModelItem.stock = storageProductModelItem.stock - storageProductModelItem.loadUnloadAmount;
                                ClientVatService getclientServiceInstance = dataBundleNotifier.getclientServiceInstance();

                                getclientServiceInstance.updateStock(
                                  currentStorageProductListForCurrentStorageUnload: [storageProductModelItem],
                                    actionModel: ActionModel(
                                        date: DateTime.now().millisecondsSinceEpoch,
                                        description: 'Ha eseguito scarico da magazzino ${dataBundleNotifier.currentStorage.name}. '
                                            '${storageProductModelItem.loadUnloadAmount.toStringAsFixed(2)} x ${storageProductModelItem.productName} rimossi. '
                                            'Precedente disponibilità per ${storageProductModelItem.productName}: ${storageProductModelItem.stock.toStringAsFixed(2)} ${storageProductModelItem.unitMeasure} ',
                                        fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                        user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                      type: ActionType.STORAGE_UNLOAD
                                    )
                                );
                              }
                          });
                        });

                        dataBundleNotifier.getclientMessagingFirebase().sendNotificationToUsersByTokens(dataBundleNotifier.currentBossTokenList,
                            '${dataBundleNotifier.userDetailsList[0].firstName} ha effettuato uno scarico su magazzino '
                                '${dataBundleNotifier.currentStorage.name} per ${dataBundleNotifier.currentBranch.companyName}.',
                            'Scarico ${dataBundleNotifier.currentStorage.name}',DateTime.now().millisecondsSinceEpoch.toString());

                        Navigator.push(context, MaterialPageRoute(builder: (context) => ComunicationUnloadStorageScreen(orderedMapBySuppliers: recapMapForCustomer ,),),);
                      }
                    },
                  ),
                ),
              ),

              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  color: kPrimaryColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: getProportionateScreenHeight(40),
                          width: getProportionateScreenWidth(500),
                          child: CupertinoTextField(
                            textInputAction: TextInputAction.next,
                            restorationId: 'Ricerca per nome o fornitore',
                            keyboardType: TextInputType.text,
                            clearButtonMode: OverlayVisibilityMode.editing,
                            placeholder: 'Ricerca per nome o fornitore',
                            onChanged: (currentText) {
                              dataBundleNotifier.filterStorageProductList(currentText);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: buildCurrentListProdutctTableForStockManagmentUnload(dataBundleNotifier, context),
                      ),
                      const SizedBox(height: 80,),
                    ],
                  ),
                ),
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
      if(element.loadUnloadAmount > 0){
        controller = TextEditingController(text: element.loadUnloadAmount.toString());
      }else{
        controller = TextEditingController();
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 4),
          child: Column(
            children: [
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


                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if(element.loadUnloadAmount <= 0){
                                }else{
                                  element.loadUnloadAmount --;
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
                                element.loadUnloadAmount = double.parse(text.replaceAll(',', '.'));
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                              clearButtonMode: OverlayVisibilityMode.never,
                              textAlign: TextAlign.center,
                              autocorrect: false,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                element.loadUnloadAmount = element.loadUnloadAmount + 1;
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(FontAwesomeIcons.plus, color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text('Giacenza: ', overflow: TextOverflow.clip,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: getProportionateScreenWidth(12)),),
                  Text(element.stock.toStringAsFixed(2).replaceAll('.00', ''), overflow: TextOverflow.clip,
                    style: TextStyle(fontWeight: FontWeight.bold, color: element.stock > 0 ? Colors.green : Colors.redAccent, fontSize: getProportionateScreenWidth(12)),),
                  Text(
                    ' x ' + element.unitMeasure,
                    style: TextStyle(fontSize: getProportionateScreenWidth(12), fontWeight: FontWeight.bold, color: Colors.white),
                  ),

                ],
              ),
            ],

          ),
        ),
      );
      rows.add(Divider(height: 0.3, color: Colors.grey.withOpacity(0.2),));
    });
    return Column(
      children: rows,
    );
  }
}
