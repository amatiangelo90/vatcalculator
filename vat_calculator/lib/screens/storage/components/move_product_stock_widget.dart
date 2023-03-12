import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/swagger/swagger.models.swagger.dart';

import '../../../constants.dart';
import '../../../models/databundlenotifier.dart';
import '../../../size_config.dart';
import '../move_prod_to_other_storage.dart';

class MoveStockProductWidgetDetails extends StatefulWidget {
  const MoveStockProductWidgetDetails({Key? key, required this.index}) : super(key: key);

  static String routeName = 'move_stock_prod_details';

  final int index;

  @override
  State<MoveStockProductWidgetDetails> createState() => _MoveStockProductWidgetDetailsState();
}


class _MoveStockProductWidgetDetailsState extends State<MoveStockProductWidgetDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        Iterable<RStorageProduct> productFromStorageSelectedList = dataBundleNotifier.rStorageProdListToMoveProdBetweenStorages.where((element) => element.productId == dataBundleNotifier.getCurrentStorage().products![widget.index].productId);
        RStorageProduct rStorageProduct;

        if(productFromStorageSelectedList.isEmpty){
          rStorageProduct = RStorageProduct(
            stock: 0.0,
          );
        }else{
          rStorageProduct = productFromStorageSelectedList.first;
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            bottomSheet: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                width: getProportionateScreenWidth(500),
                height:  getProportionateScreenWidth(50),
                child: OutlinedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.resolveWith((states) => 5),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
                    side: MaterialStateProperty.resolveWith((states) => const BorderSide(width: 0.5, color: kCustomGreen),),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                  ),
                  onPressed: () async {

                    Response apiV1AppStorageMoveproductbetweenstoragesPut = await dataBundleNotifier.getSwaggerClient().apiV1AppStorageMoveproductbetweenstoragesPut(
                        storageIdFrom: dataBundleNotifier.getCurrentStorage().storageId!.toInt(),
                        storageIdTo: dataBundleNotifier.selectedStorageNameToMoveProd.storageId!.toInt(),
                        productId: dataBundleNotifier.getCurrentStorage().products![widget.index].productId!.toInt(),
                        amount: dataBundleNotifier.stock);


                    if(apiV1AppStorageMoveproductbetweenstoragesPut.isSuccessful){

                      Navigator.pushNamed(context, MoveProductToOtherStorageScreen.routeName);
                      sleep(const Duration(milliseconds: 190));
                      dataBundleNotifier.updateProductOnCurrentStorage(dataBundleNotifier.getCurrentStorage().products![widget.index].productId!.toInt(), dataBundleNotifier.stock);

                      Response apiV1AppStorageFindstoragebybranchidGet = await dataBundleNotifier.getSwaggerClient().apiV1AppStorageFindproductsbystorageidGet(storageId: dataBundleNotifier.selectedStorageNameToMoveProd.storageId!.toInt());

                      if(apiV1AppStorageFindstoragebybranchidGet.isSuccessful){
                        dataBundleNotifier.refreshDataIntoChoicedStorageToMoveProduct(apiV1AppStorageFindstoragebybranchidGet.body);

                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: kCustomBordeaux,
                          duration: Duration(milliseconds: 2000),
                          content: Text(
                              'Potrebbero essersi verificati degli errori durante il refresh della pagina. Riavviare l\'app per un corretto allineamento dei dati')));
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: kCustomGreen,
                        duration: const Duration(milliseconds: 2000),
                        content: Text(
                            dataBundleNotifier.stock.toStringAsFixed(2) + ' x ' +  dataBundleNotifier.getCurrentStorage().products![widget.index].unitMeasure! + 
                                ' di ' + dataBundleNotifier.getCurrentStorage().products![widget.index].productName! + ' spostati correttamente da ' + dataBundleNotifier.getCurrentStorage().name! + ' a ' + dataBundleNotifier.selectedStorageNameToMoveProd.name!,
                      )));


                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: kCustomBordeaux,
                        duration: const Duration(milliseconds: 2000),
                        content: Text(
                            'Errore durante l\'operazione. Err: ' + apiV1AppStorageMoveproductbetweenstoragesPut.error.toString()),
                      ));
                    }

                  }, child: Text('Sposta prodotto', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(17)),),
                ),
              ),
            ),
            appBar: AppBar(
              title: Text('Sposta prodotto', style: TextStyle(color: Colors.black, fontSize: getProportionateScreenHeight(17)) ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Text(dataBundleNotifier.getCurrentStorage().products![widget.index].productName!, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:
                    getProportionateScreenWidth(18),
                    color: kCustomGrey,
                  ),),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(

                      height: MediaQuery.of(context).size.height *0.08,
                      child: TextField(
                        style: TextStyle(fontSize: getProportionateScreenHeight(20)),
                        controller: dataBundleNotifier.stockController,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.done,
                        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                        onEditingComplete: (){
                          dataBundleNotifier.updateStock();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        onSubmitted: (stock){
                          FocusManager.instance.primaryFocus?.unfocus();
                          if(double.parse(stock.replaceAll(',','.')) > dataBundleNotifier.getCurrentStorage().products![widget.index].stock!){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              backgroundColor: kCustomBordeaux,
                              duration: Duration(milliseconds: 2000),
                              content: Text(
                                  'Non puoi inserire una quantità superiore all\'attuale giacenza'),
                            ));
                            dataBundleNotifier.updateStockByPassingValue(dataBundleNotifier.stock);
                          }else{
                            dataBundleNotifier.updateStockByPassingValue(double.parse(stock.replaceAll(',','.')));
                          }
                        },
                      ),
                    ),
                  ),
                  Slider(
                    activeColor: kCustomGreen,
                    max: dataBundleNotifier.getCurrentStorage().products![widget.index].stock!,
                    min: 0,
                    divisions: dataBundleNotifier.getCurrentStorage().products![widget.index].stock! < 1 ? 1 : (dataBundleNotifier.getCurrentStorage().products![widget.index].stock!).round(),
                    value: dataBundleNotifier.stock,
                    onChanged: (double value) {
                      dataBundleNotifier.setStockToMoveProd(value);
                    },
                  ),
                  Text(dataBundleNotifier.getCurrentStorage().products![widget.index].unitMeasure!, style: TextStyle(fontSize: 15)),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: getProportionateScreenHeight(260),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: Colors.grey.shade300
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(dataBundleNotifier.getCurrentStorage().name!, style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize:
                                          getProportionateScreenWidth(15),
                                          color: kCustomGrey,
                                        ),),
                                        Row(
                                            children: const [
                                              Expanded(child: Center(child: Text('Giacenza', style: TextStyle(fontSize: 8)))),
                                              Expanded(child: Center(child: Text('Prodotto da spostare', style: TextStyle(fontSize: 8)))),
                                              Expanded(child: Center(child: Text('Giacenza dopo spostamento', style: TextStyle(fontSize: 8)))),
                                            ]
                                        ),
                                        Table(
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          children: [
                                            TableRow(
                                                children: [
                                                  Center(child: Text(dataBundleNotifier.getCurrentStorage().products![widget.index].stock!.toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontSize: 20))),

                                                  Center(child: Text(dataBundleNotifier.stock!.toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontSize: 20))),
                                                  Center(
                                                    child: Text((dataBundleNotifier.getCurrentStorage().products![widget.index].stock!
                                                        - dataBundleNotifier.stock!).toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontSize: 20)),
                                                  ),
                                                ]
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Divider(
                                      color: Colors.grey.shade300,
                                      thickness: 1,
                                      endIndent: 5,
                                      indent: 5,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 30),
                                    child: Column(
                                      children: [
                                        Text(dataBundleNotifier.selectedStorageNameToMoveProd.name!, style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize:
                                          getProportionateScreenWidth(18),
                                          color: kCustomGrey,
                                        ),),
                                        Row(
                                            children: const [
                                              Expanded(child: Center(child: Text('Giacenza', style: TextStyle(fontSize: 8)))),
                                              Expanded(child: Center(child: Text('Prodotto in arrivo', style: TextStyle(fontSize: 8)))),
                                              Expanded(child: Center(child: Text('Giacenza dopo spostamento', style: TextStyle(fontSize: 8)))),
                                            ]
                                        ),
                                        Table(
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          border: TableBorder(
                                          ),
                                          children: [
                                            TableRow(
                                                children: [
                                                  Center(child: Text(rStorageProduct.stock!.toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontSize: 20))),
                                                  Center(child: Text(dataBundleNotifier.stock!.toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontSize: 20))),
                                                  Center(
                                                    child: Text((rStorageProduct.stock!
                                                        + dataBundleNotifier.stock!).toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontSize: 20)),
                                                  ),
                                                ]
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
        );
      },
    );
  }
}
