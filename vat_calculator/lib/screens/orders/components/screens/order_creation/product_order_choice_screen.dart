import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import '../../../../../swagger/swagger.enums.swagger.dart';
import '../../../../../swagger/swagger.models.swagger.dart';
import 'order_confirm_screen.dart';
import 'order_create_screen.dart';

class ChoiceOrderProductScreen extends StatefulWidget {
  const ChoiceOrderProductScreen({Key? key, required this.currentSupplier}) : super(key: key);

  static String routeName = 'addproductorder';

  final Supplier currentSupplier;

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
                  height: getProportionateScreenHeight(130),
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
                                  Text('Prodotti: ', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: getProportionateScreenWidth(14)),),
                                  Text(dataBundleNotifier.getProdNumberFromBasket(), textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenWidth(14)),),
                                ],
                              ),
                              dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? SizedBox(height: 0,) : Row(
                                children: [
                                  Text('Prezzo: ', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: getProportionateScreenWidth(14)),),
                                  Text(dataBundleNotifier.calculateTotalFromBasket()!.toStringAsFixed(2) + ' €', textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenWidth(14)),),
                                ],
                              ),
                            ],
                          ),
                        ),
                        DefaultButton(
                          textColor: Colors.white,
                          text: 'Procedi',
                          press: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderConfirmationScreen(
                                    currentSupplier: widget.currentSupplier
                                ),
                              ),
                            );

                          },
                          color: kCustomGrey,
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
                  iconTheme: const IconThemeData(color: kCustomGrey),
                  backgroundColor: Colors.white,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderConfirmationScreen(
                                  currentSupplier: widget.currentSupplier
                              ),
                            ),
                          );
                        },
                        icon: Stack(
                          children: [
                            const Icon(Icons.shopping_basket, color: kCustomGrey,),
                            dataBundleNotifier.getProdNumberFromBasket() == '0' ? Text('') : Positioned(
                                left: 10,
                                top: 1,
                                child: Stack(children: [
                                  const Icon(Icons.circle, size: 15,color: kCustomPinkAccent,),
                                  Center(child: Text( '  ' + dataBundleNotifier.getProdNumberFromBasket(), style: TextStyle(fontSize: 9))),
                                ], )
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                  centerTitle: true,
                  title: Column(
                    children: [
                      Text(
                        'Crea Ordine',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          color: kCustomGrey,
                        ),
                      ),
                      Text(
                        'Immetti quantità per prodotti',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(10),
                          color: kCustomGrey,
                        ),
                      ),
                    ],
                  ),
                  elevation: 0,
                ),
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: buildProductPage(dataBundleNotifier, widget.currentSupplier),
                  ),
                )
            );
          },
        ),
      ),
    );
  }

  buildProductPage(DataBundleNotifier dataBundleNotifier, Supplier supplier) {
    List<Widget> list = [];
    if(dataBundleNotifier.basket!.isEmpty){
      list.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.3,),
          const Center(child: Text('Nessun prodotto registrato per il presente fornitore', textAlign: TextAlign.center,)),
          SizedBox(height: 20,),

        ],
      ),);
      return list;
    }
    list.add(Center(child: Text(supplier.name!, textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(18)),)));
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

          },
        ),
      ),
    );
    for (var currentProduct in dataBundleNotifier.basket!) {
      TextEditingController controller = TextEditingController(text: currentProduct.amount! > 0
          ? currentProduct.amount!.toStringAsFixed(2).replaceAll('.00', '') : '');

      list.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentProduct.productName!, style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenWidth(16), fontWeight: FontWeight.w700),),
                      Row(
                        children: [
                          Text(
                            currentProduct.unitMeasure! == 'ALTRO' ? currentProduct.unitMeasure! : currentProduct.unitMeasure!,
                            style:
                            TextStyle(fontSize: getProportionateScreenWidth(13), fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.circle, size: 4, color: Colors.grey),
                          ),
                          Text(
                            dataBundleNotifier.getCurrentBranch().userPriviledge.toString().toLowerCase() == branchUserPriviledgeFromJson(BranchUserPriviledge.employee).toString() ? '' : currentProduct.price.toString() + ' €',
                            style:
                            TextStyle(fontSize: getProportionateScreenWidth(13), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if(currentProduct.amount! > 0){
                            currentProduct.amount = currentProduct.amount! - 1;
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
                              // rimuovi dalla classe il final sul campo
                              currentProduct.amount = 0.0;
                            }
                          }else{
                            if (double.tryParse(text.replaceAll(',', '.')) != null) {
                              currentProduct.amount = double.parse(text.replaceAll(',', '.'));
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
                          currentProduct.amount = currentProduct.amount! + 1;
                          //dataBundleNotifier.addProdToSetProduct(currentProduct.pkProductId);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.plus,
                            color: kCustomGreen),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
      list.add(Divider(color: Colors.grey.shade400, indent: 10, height: 1,));
    }

    list.add(Column(
      children: const [
        SizedBox(height: 200,),
      ],
    ));
    return list;
  }

  void buildSnackBar({required String text, required Color color}) {
    ScaffoldMessenger.of(context).
    showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 2000),
        backgroundColor: color,
        content: Text(text, style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
  }

  refresh() {
    setState((){});
  }
}
