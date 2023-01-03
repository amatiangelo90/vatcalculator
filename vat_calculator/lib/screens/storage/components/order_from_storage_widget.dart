import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/databundlenotifier.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.models.swagger.dart';

class OrderFromStorageWidget extends StatefulWidget {
  const OrderFromStorageWidget({Key? key}) : super(key: key);

  static String routeName = 'orderfromstorage';

  @override
  State<OrderFromStorageWidget> createState() => _OrderFromStorageWidgetState();
}

class _OrderFromStorageWidgetState extends State<OrderFromStorageWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (child, dataBundleNotifier, _){

          return GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('Seleziona i prodotti', textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenHeight(20)),),
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

      dataBundleNotifier.getProdToGroupedBySupplierIdToPerformOrder().forEach((key, value) {
        listWidget.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 15, 13, 2),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: kCustomGrey,
              ),
              width: MediaQuery.of(context).size.width,
              child: Text('Fornitore: ' + dataBundleNotifier.getSupplierNameById(key!), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: kCustomWhite),),
            ),
          ),
        );

        for (var currentProduct in value) {
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
                          child: Text(currentProduct.productName!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey,fontSize: getProportionateScreenHeight(15)),)),
                      Text(currentProduct.unitMeasure!, style: TextStyle(fontSize: getProportionateScreenHeight(11), fontWeight: FontWeight.bold,),),
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
        }
      });
    }else{
      listWidget.add(
          Center(child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Text('Non ci sono prodotti nel magazzino selezionato. Aggiungine di nuovi ed esegui l\'ordine',style: TextStyle(fontSize: getProportionateScreenHeight(18), color: kCustomBordeaux, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),)
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: listWidget,
      ),
    );
  }
}
