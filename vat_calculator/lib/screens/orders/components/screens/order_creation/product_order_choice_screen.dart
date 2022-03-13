import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {

          return Scaffold(
            bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                textColor: kCustomOrange,
                text: 'Procedi',
                press: () async {

                  int productsAmountsDiffentThan0 = 0;
                  dataBundleNotifier.currentProductModelListForSupplier.forEach((element) {
                    if(element.prezzo_lordo != 0){
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
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, CreateOrderScreen.routeName),
                  }),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.black.withOpacity(0.9),
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'Crea Ordine',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      color: kCustomGreen,
                    ),
                  ),
                  Text(
                    'Immetti quantità per prodotti',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(10),
                      color: kCustomWhite,
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
    );
  }

  Future buildProductPage(DataBundleNotifier dataBundleNotifier, SupplierModel supplier) async {
    List<Widget> list = [];

    if(dataBundleNotifier.currentProductModelListForSupplier.isEmpty){
      list.add(Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.3,),
          const Center(child: Text('Nessun prodotto registrato')),
        ],
      ),);
      return list;
    }
    list.add(Center(child: Text(supplier.nome)));
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
      TextEditingController controller = TextEditingController(text: currentProduct.prezzo_lordo.toString());

      list.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentProduct.nome, style: TextStyle(color: Colors.black, fontSize: getProportionateScreenWidth(15)),),
                    Text(currentProduct.unita_misura, style: TextStyle( fontSize: getProportionateScreenWidth(12))),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (currentProduct.prezzo_lordo <= 0) {
                          } else {
                            currentProduct.prezzo_lordo--;
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
                          getProportionateScreenWidth(70),
                          getProportionateScreenWidth(60))),
                      child: CupertinoTextField(
                        controller: controller,
                        onChanged: (text) {
                          if (double.tryParse(text) != null) {
                            currentProduct.prezzo_lordo = double.parse(text);
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentProduct.prezzo_lordo = currentProduct.prezzo_lordo + 1;
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
    });

    list.add(Column(
      children: const [
        SizedBox(height: 80,),
      ],
    ));
    return list;
  }

  void buildSnackBar({@required String text, @required Color color}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 2000),
        backgroundColor: color,
        content: Text(text, style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
  }
}
