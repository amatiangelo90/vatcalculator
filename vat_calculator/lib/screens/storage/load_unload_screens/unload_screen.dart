import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
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
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(

            appBar: AppBar(
              actions: [
                IconButton(onPressed: (){
                  dataBundleNotifier.clearUnloadProductList();
                }, icon: const Icon(Icons.clear, color: kPinaColor,))
              ],
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor, size: getProportionateScreenHeight(20),),
              ),
              centerTitle: true, 
              title: Text(dataBundleNotifier.currentStorage.name, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(15)),),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                color: kPinaColor,
                text: 'Effettua Scarico',
                press: () async {
                  int stockProductDiffentThan0 = 0;
                  Map<int, List<StorageProductModel>> orderedMapBySuppliers = {};
                  dataBundleNotifier.currentStorageProductListForCurrentStorageUnload.forEach((element) {
                    if(element.stock != 0){
                      stockProductDiffentThan0 = stockProductDiffentThan0 + 1;

                      if(orderedMapBySuppliers.keys.contains(element.supplierId)){
                        orderedMapBySuppliers[element.supplierId].add(element);
                      }else{
                        orderedMapBySuppliers[element.supplierId] = [element];
                      }
                    }
                  });
                  if(stockProductDiffentThan0 == 0){
                    Scaffold.of(context).showSnackBar(const SnackBar(
                      backgroundColor: kPinaColor,
                      content: Text('Immettere la quantità di scarico per almeno un prodotto'),
                    ));
                  }else{
                    Map<int, List<StorageProductModel>> recapMapForCustomer = orderedMapBySuppliers;
                    orderedMapBySuppliers.forEach((key, value) async {
                      Response performSaveOrderId = await dataBundleNotifier.getclientServiceInstance().performSaveOrder(OrderModel(
                          code: DateTime.now().microsecondsSinceEpoch.toString().substring(3,16),
                          details: 'Ordine Bozza per fornitore con id ' + key.toString(),
                          total: 0.0,
                          status: OrderState.DRAFT,
                          creation_date: DateTime.now().millisecondsSinceEpoch,
                          delivery_date: null,
                          fk_branch_id: dataBundleNotifier.currentBranch.pkBranchId,
                          fk_storage_id: dataBundleNotifier.currentStorage.pkStorageId,
                          fk_user_id: dataBundleNotifier.dataBundleList[0].id,
                          pk_order_id: 0,
                          fk_supplier_id: key
                      ));

                      value.forEach((element) {

                        print('Create relation between ' + performSaveOrderId.data.toString() + ' and : ' + element.fkProductId.toString() + ' - Stock: ' +  element.stock.toString());
                        dataBundleNotifier.getclientServiceInstance().performSaveProductIntoOrder(
                            element.stock,
                            element.fkProductId,
                            performSaveOrderId.data
                        );

                        dataBundleNotifier.currentStorageProductListForCurrentStorage.forEach((standardElement) {
                          if(standardElement.pkStorageProductId == element.pkStorageProductId){
                            element.stock = standardElement.stock - element.stock;
                            ClientVatService getclientServiceInstance = dataBundleNotifier.getclientServiceInstance();
                            getclientServiceInstance.updateStock([element]);
                          }
                        });


                      });
                    });

                    Navigator.push(context, MaterialPageRoute(builder: (context) => ComunicationUnloadStorageScreen(orderedMapBySuppliers: recapMapForCustomer ,),),);
                  }
                },
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
    List<Row> rows = [

    ];

    dataBundleNotifier.currentStorageProductListForCurrentStorageUnload.forEach((element) {
      TextEditingController controller = TextEditingController(text: element.stock.toString());
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
                  child: Text(element.productName, overflow: TextOverflow.clip, style: TextStyle(fontSize: getProportionateScreenWidth(16)),),
                ),
                Row(
                  children: [
                    Text(element.unitMeasure, style: TextStyle(fontSize: getProportionateScreenWidth(8)),),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(FontAwesomeIcons.dotCircle, size: getProportionateScreenWidth(3),),
                    ),
                    Text(element.price.toString() + ' €', style: TextStyle(fontSize: getProportionateScreenWidth(8)),),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if(element.stock <= 0){
                      }else{
                        element.stock --;
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
                      if( double.tryParse(text) != null){
                        element.stock = double.parse(text);
                      }else{
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text('Immettere un valore numerico corretto per ' + element.productName),
                        ));
                      }

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
                      element.stock = element.stock + 1;
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
    });
    return Column(
      children: rows,
    );
  }
}
