import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../../../client/vatservice/model/utils/privileges.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import 'order_confirm_screen.dart';
import 'order_create_screen.dart';

class ChoiceOrderProductScreen extends StatefulWidget {
  const ChoiceOrderProductScreen({Key key, this.currentSupplier}) : super(key: key);

  static String routeName = 'addproductorder';

  final SupplierModel currentSupplier;

  @override
  State<ChoiceOrderProductScreen> createState() => _ChoiceOrderProductScreenState();
}

class _ChoiceOrderProductScreenState extends State<ChoiceOrderProductScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        setState(() {

        });
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        child: Consumer<DataBundleNotifier>(
          builder: (context, dataBundleNotifier, child) {
            return Scaffold(
              key: _scaffoldKey,
              bottomSheet: SizedBox(
                height: getProportionateScreenHeight(110),
                child: Padding(
                  padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('Prodotti selezionati: ', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: getProportionateScreenWidth(14)),),
                                Text(dataBundleNotifier.setProducts.length.toString(), textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(14)),),
                              ],
                            ),
                              dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? SizedBox(height: 0,) : Row(
                              children: [
                                Text('Prezzo stimato: ', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: getProportionateScreenWidth(14)),),
                                Text(dataBundleNotifier.totalPriceOrder.toStringAsFixed(2) + ' €', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(14)),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DefaultButton(
                        textColor: Colors.white,
                        text: 'Procedi',
                        press: () async {

                          int productsAmountsDiffentThan0 = 0;
                          dataBundleNotifier.currentProductModelListForSupplier.forEach((element) {
                            if(element.orderItems != 0){
                              productsAmountsDiffentThan0 = productsAmountsDiffentThan0 + 1;
                            }
                          });
                          if(productsAmountsDiffentThan0 == 0){
                            buildSnackBar(text: 'Selezionare quantità per almeno un prodotto', color: kPinaColor);
                          }else{
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderConfirmationScreen(
                                  currentSupplier: widget.currentSupplier,
                                ),
                              ),
                            );
                          }
                        },
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => {
                      Navigator.pushNamed(context, CreateOrderScreen.routeName),
                    }),
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: kPrimaryColor,
                centerTitle: true,
                title: Column(
                  children: [
                    Text(
                      'Crea Ordine',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Immetti quantità per prodotti',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(10),
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),
                elevation: 2,
              ),
              body: FutureBuilder(
                initialData: <Widget>[
                  const Center(
                      child: CircularProgressIndicator(
                        color: kPinaColor,
                      )),
                  const SizedBox(),
                  Column(
                    children: const [
                      Center(
                        child: Text(
                          'Caricamento prodotti..',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: kPrimaryColor,
                              fontFamily: 'LoraFont'),
                        ),
                      ),
                    ],
                  ),
                ],
                future: buildProductPage(dataBundleNotifier, widget.currentSupplier),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        children: snapshot.data,
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future buildProductPage(DataBundleNotifier dataBundleNotifier, SupplierModel supplier) async {
    List<Widget> list = [];

    if(dataBundleNotifier.currentProductModelListForSupplier.isEmpty){
      list.add(Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.3,),
          const Center(child: Text('Nessun prodotto registrato per il presente fornitore')),
        ],
      ),);
      return list;
    }
    list.add(Center(child: Text(supplier.nome, textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(18)),)));
    list.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: CupertinoTextField(
          textInputAction: TextInputAction.next,
          restorationId: 'Ricerca prodotto',
          keyboardType: TextInputType.text,
          clearButtonMode: OverlayVisibilityMode.editing,
          placeholder: 'Ricerca prodotto',
          onChanged: (currentText) {
            dataBundleNotifier.filterCurrentListProductByName(currentText);
          },
        ),
      ),
    );
    dataBundleNotifier.currentProductModelListForSupplierDuplicated.forEach((currentProduct) {
      TextEditingController controller;

      if(currentProduct.orderItems > 0){
        controller = TextEditingController(text: currentProduct.orderItems.toStringAsFixed(2).replaceAll('.00', ''));
      }else{
        controller = TextEditingController();
      }

      list.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentProduct.nome, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(16), fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        Text(
                          currentProduct.unita_misura,
                          style:
                          TextStyle(fontSize: getProportionateScreenWidth(14), fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.circle, size: 4, color: Colors.grey),
                        ),
                        Text(
                          dataBundleNotifier.currentBranch.accessPrivilege == Privileges.EMPLOYEE ? '' : currentProduct.prezzo_lordo.toString() + ' €',
                          style:
                          TextStyle(fontSize: getProportionateScreenWidth(14), fontWeight: FontWeight.bold),
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
                          if (currentProduct.orderItems <= 0) {
                            dataBundleNotifier.setProducts.remove(currentProduct.pkProductId);
                          } else {
                            currentProduct.orderItems --;
                          }

                          if(currentProduct.orderItems <= 0 || currentProduct.orderItems == null){
                            dataBundleNotifier.setProducts.remove(currentProduct.pkProductId);
                            currentProduct.orderItems = 0.0;
                          }

                        });
                        dataBundleNotifier.calculatePrice();
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

                          if(text == '' || text == null || text == '0' || text == '0.0'){
                            dataBundleNotifier.setProducts.remove(currentProduct.pkProductId);
                            double totalPriceOrder = 0.0;

                            dataBundleNotifier.currentProductModelListForSupplierDuplicated.forEach((prod) {
                              if(prod.orderItems > 0){
                                totalPriceOrder = double.parse((totalPriceOrder + (prod.orderItems * prod.prezzo_lordo)).toStringAsFixed(2));
                              }
                              currentProduct.orderItems = 0.0;
                            });
                            dataBundleNotifier.totalPriceOrder = totalPriceOrder;
                          }else{
                            if (double.tryParse(text.replaceAll(',', '.')) != null) {
                              currentProduct.orderItems = double.parse(text.replaceAll(',', '.'));
                              dataBundleNotifier.totalPriceOrder = 0.0;
                              dataBundleNotifier.currentProductModelListForSupplierDuplicated.forEach((prod) {
                                if(prod.orderItems > 0){
                                  dataBundleNotifier.totalPriceOrder = double.parse((dataBundleNotifier.totalPriceOrder + (prod.orderItems * prod.prezzo_lordo)).toStringAsFixed(2));
                                }
                              });
                              dataBundleNotifier.setProducts.add(currentProduct.pkProductId);
                              double totalPriceOrder = 0.0;

                              dataBundleNotifier.currentProductModelListForSupplierDuplicated.forEach((prod) {
                                if(prod.orderItems > 0){
                                  totalPriceOrder = double.parse((totalPriceOrder + (prod.orderItems * prod.prezzo_lordo)).toStringAsFixed(2));
                                }
                              });
                              dataBundleNotifier.totalPriceOrder = totalPriceOrder;
                            }
                          }

                        },
                        textInputAction: TextInputAction.next,
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
                          currentProduct.orderItems = currentProduct.orderItems + 1;
                          dataBundleNotifier.addProdToSetProduct(currentProduct.pkProductId);
                          dataBundleNotifier.calculatePrice();
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
          ));
      list.add(Divider(color: Colors.grey.shade400, indent: 10, height: 1,));
    });

    list.add(Column(
      children: const [
        SizedBox(height: 80,),
      ],
    ));
    return list;
  }

  void buildSnackBar({@required String text, @required Color color}) {
    _scaffoldKey.currentState.
        showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 2000),
        backgroundColor: color,
        content: Text(text, style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
  }
}
