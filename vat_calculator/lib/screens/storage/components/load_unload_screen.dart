import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/databundlenotifier.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.models.swagger.dart';

class LoadUnloadScreen extends StatefulWidget {
  const LoadUnloadScreen({Key? key,
    required this.isLoad,
    required this.isUnLoad}) : super(key: key);

  static String routeName = 'loadunloadscreen';
  final bool isLoad;
  final bool isUnLoad;

  @override
  State<LoadUnloadScreen> createState() => _LoadUnloadScreenState();
}

class _LoadUnloadScreenState extends State<LoadUnloadScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (child, dataBundleNotifier, _){

          return GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Scaffold(
              bottomSheet: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: getProportionateScreenWidth(400),
                  height: getProportionateScreenHeight(55),
                  child: OutlinedButton(
                    onPressed: () async {
                      List<LoadUnloadModel> list = buildListFromRStorageProduct(dataBundleNotifier);
                      Response loadUnloadResponse;
                      if(widget.isLoad){
                        loadUnloadResponse = await dataBundleNotifier.getSwaggerClient().apiV1AppStorageLoadPut(loadUnloadModel: list);
                      }else{
                        loadUnloadResponse = await dataBundleNotifier.getSwaggerClient().apiV1AppStorageUnloadPut(loadUnloadModel: list);
                      }

                      if(loadUnloadResponse.isSuccessful){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: kCustomGreen,
                          duration: Duration(milliseconds: 1000),
                          content: Text(
                              'Operazione eseguita con successo'),
                        ));

                        dataBundleNotifier.refreshCurrentBranchDataWithStorageTrakingId(dataBundleNotifier.getCurrentStorage().storageId!.toInt());

                        Navigator.of(context).pop(false);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: kRed,
                          duration: Duration(milliseconds: 2600),
                          content: Text(
                              'Si è verificato un errore durante l\'operazione. Err: ' + loadUnloadResponse.error.toString()!),
                        ));
                      }


                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.resolveWith((states) => 5),
                      backgroundColor: MaterialStateProperty.resolveWith((states) => widget.isLoad ? kCustomGreen : kRed),
                      side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey.shade100),),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                    ),
                    child: Text(widget.isLoad ? 'Effettua carico' : 'Effettua scarico', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(20)),),
                  ),
                ),
              ),
              appBar: AppBar(
                centerTitle: true,
                title: Text(widget.isLoad ? 'Effettua carico' : 'Effettua scarico', textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenHeight(20)),),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {  },
                      icon: Stack(
                        children: [
                          Icon(Icons.shopping_basket, size: getProportionateScreenWidth(20), color: kCustomGrey,),
                          Positioned(
                              left: 10,
                              top: 1,
                              child: Stack(children: [
                                const Icon(Icons.circle, size: 15,color: kCustomPinkAccent,),
                                Center(child: Text( '  ' + dataBundleNotifier.getCurrentStorage().products!.where((element) => element.orderAmount! > 0).length.toString(), style: TextStyle(fontSize: 9))),
                              ], )
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              body: buildWidgetProdList(dataBundleNotifier),
            ),
          );
        }
    );
  }

  buildWidgetProdList(DataBundleNotifier dataBundleNotifier) {
    List<Widget> listWidget = [];
    if(dataBundleNotifier.getCurrentStorage().products!.isNotEmpty){

      dataBundleNotifier.getCurrentStorage().products!.forEach((currentProduct) {
        TextEditingController controller = TextEditingController(text: currentProduct.orderAmount.toString());
        listWidget.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: getProportionateScreenWidth(180),
                        child: Text(currentProduct.productName!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey,fontSize: getProportionateScreenHeight(18)),)),
                    Row(
                      children: [
                        Text(currentProduct.stock.toString()!, style: TextStyle(fontSize: getProportionateScreenHeight(13), fontWeight: FontWeight.bold, color: kCustomGrey),),
                        currentProduct.orderAmount! > 0 ? Text(widget.isLoad ? '+' : '-', style: TextStyle(fontSize: getProportionateScreenHeight(13), fontWeight: FontWeight.bold, color: widget.isLoad ? kCustomGreen : kRed),) : Text(''),
                        currentProduct.orderAmount! > 0 ? Text(currentProduct.orderAmount.toString()!, style: TextStyle(fontSize: getProportionateScreenHeight(13), fontWeight: FontWeight.bold, color: widget.isLoad ? kCustomGreen : kRed),) : Text(''),
                        widget.isLoad ? currentProduct.orderAmount! > 0 ? Text('=' + (currentProduct.stock! + currentProduct.orderAmount!).toString(), style: TextStyle(fontSize: getProportionateScreenHeight(13), fontWeight: FontWeight.bold, color: kCustomGrey),) : Text('') :
                        currentProduct.orderAmount! > 0 ? Text('=' + (currentProduct.stock! - currentProduct.orderAmount!).toString(), style: TextStyle(fontSize: getProportionateScreenHeight(13), fontWeight: FontWeight.bold, color: kCustomGrey),) : Text(''),

                      ],
                    ),
                    Text(currentProduct.unitMeasure!, style: TextStyle(fontSize: getProportionateScreenHeight(10), fontWeight: FontWeight.bold,),),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if(currentProduct.orderAmount! > 0){
                            currentProduct.orderAmount = currentProduct.orderAmount! - 1;
                          }
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesomeIcons.minus,
                          color: kPinaColor,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.loose(Size(
                          getProportionateScreenWidth(60),
                          getProportionateScreenWidth(80))),
                      child: CupertinoTextField(
                        controller: controller,
                        onChanged: (text) {

                          if(text == '' || text == '0' || text == '0.0'){
                            for (ROrderProduct prod in dataBundleNotifier.basket) {
                              // rimuovi dalla classe il final sul campo orderAmount
                              currentProduct.orderAmount = 0.0;
                            }
                          }else{
                            if (double.tryParse(text.replaceAll(',', '.')) != null) {
                              currentProduct.orderAmount = double.parse(text.replaceAll(',', '.'));
                            }
                          }

                        },
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          color: kCustomGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: getProportionateScreenHeight(22),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        clearButtonMode: OverlayVisibilityMode.never,
                        textAlign: TextAlign.center,
                        autocorrect: false,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentProduct.orderAmount = currentProduct.orderAmount! + 1;
                          //dataBundleNotifier.addProdToSetProduct(currentProduct.pkProductId);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.plus,
                            color: Colors.green.shade900),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        listWidget.add(Divider(height: 4, color: Colors.grey.withOpacity(0.3), indent: 17, endIndent: getProportionateScreenWidth(150),));
      });

    }else{
      listWidget.add(
          Center(child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Text('Non ci sono prodotti nel magazzino selezionato. Aggiungine di nuovi ed esegui l\'ordine',style: TextStyle(fontSize: getProportionateScreenHeight(18), color: kCustomBordeaux, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),)
      );
    }
    listWidget.add(
        SizedBox(height: 100,)
    );
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: listWidget,
      ),
    );
  }

  List<LoadUnloadModel> buildListFromRStorageProduct(DataBundleNotifier dataBundleNotifier) {
    List<LoadUnloadModel> outList = [];

    for (RStorageProduct prod in dataBundleNotifier.getCurrentStorage()!.products!) {
      if(prod.orderAmount! > 0){
        outList.add(LoadUnloadModel(
            productId: prod.productId,
            storageId: dataBundleNotifier.getCurrentStorage().storageId,
            amount: prod.orderAmount
        ));
      }
    }

    return outList;
  }
}
