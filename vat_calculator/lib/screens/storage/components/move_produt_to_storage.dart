import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import '../../../client/vatservice/model/branch_model.dart';
import 'confirm_move_product_to_storage.dart';

class MoveProductToStorageScreen extends StatefulWidget {
  const MoveProductToStorageScreen({Key key, this.currentSupplier}) : super(key: key);

  static String routeName = 'move_product_storage';

  final SupplierModel currentSupplier;

  @override
  State<MoveProductToStorageScreen> createState() => _MoveProductToStorageScreenState();
}

class _MoveProductToStorageScreenState extends State<MoveProductToStorageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {

          return Scaffold(
            key: _scaffoldKey,
            bottomSheet: Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
              child: DefaultButton(
                textColor: Colors.white,
                text: 'Procedi',
                press: () async {
                  bool canExecute = true;

                  for(StorageProductModel storageProductModel in dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated){
                    if(storageProductModel.extra != 0 && storageProductModel.extra > storageProductModel.stock){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: kPinaColor,
                        content: Text(storageProductModel.productName + '. Scarico richiesto: ' + storageProductModel.extra.toStringAsFixed(2) + '. Stock: ' + storageProductModel.stock.toStringAsFixed(2)),
                      ));
                      canExecute = false;
                      break;
                    }
                  }

                  if(canExecute){
                    bool atLeastOneGraterThan0 = false;
                    for(StorageProductModel storageProductModel in dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated){
                      if(storageProductModel.extra > 0){
                        atLeastOneGraterThan0 = true;
                        break;
                      }
                    }
                    if(atLeastOneGraterThan0){
                      List<StorageModel> storageModelListForAllBranches = [];

                      await Future.forEach(dataBundleNotifier.userDetailsList[0].companyList, (BranchModel branch) async {
                        List<StorageModel> appoggio = await dataBundleNotifier.getclientServiceInstance().retrieveStorageListByBranch(branch);
                        storageModelListForAllBranches.addAll(appoggio);
                      });

                      storageModelListForAllBranches.removeWhere((element) => element.pkStorageId == dataBundleNotifier.currentStorage.pkStorageId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductMoveToOtherStorageConfirmationScreen(
                            storageList: storageModelListForAllBranches
                          ),
                        ),
                      );

                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: kPinaColor,
                        content: Text('Immettere quantità per almeno un prodotto'),
                      ));

                    }
                  }
                },
                color: kPrimaryColor,
              ),
            ),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              actions: [
                IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      dataBundleNotifier.cleanExtraArgsListProduct();
                    }),
              ],
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'Sposta prodotti da magazzino',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Immetti quantità per prodotti',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(10),
                      color: Colors.green,
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
              future: buildProductPage(dataBundleNotifier),
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

  Future buildProductPage(DataBundleNotifier dataBundleNotifier) async {
    List<Widget> list = [
      Center(child: Text(dataBundleNotifier.currentStorage.name, style: TextStyle(fontSize: getProportionateScreenHeight(14), fontWeight: FontWeight.bold)))
    ];

    if(dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated.isEmpty){
      list.add(Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.3,),
          const Center(child: Text('Nessun prodotto registrato')),
        ],
      ),);
      return list;
    }
    list.add(
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
    );
    dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated.forEach((currentProduct) {
      TextEditingController controller;

      if(currentProduct.extra != 0.0){
        controller = TextEditingController(text: currentProduct.extra.toStringAsFixed(2));
      }else{
        controller = TextEditingController();
      }

      list.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentProduct.productName, style: TextStyle(color: Colors.black, fontSize: getProportionateScreenWidth(15)),),
                    Row(
                      children: [
                        Text(currentProduct.stock.toStringAsFixed(2), style: TextStyle( fontSize: getProportionateScreenWidth(12))),
                        Text( ' x ' + currentProduct.unitMeasure, style: TextStyle( fontSize: getProportionateScreenWidth(12))),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (currentProduct.extra <= 0) {
                          } else {
                            currentProduct.extra--;
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
                            currentProduct.extra = double.parse(text);
                          } else {

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: kPinaColor,
                              content: Text(
                                  'Immettere un valore numerico corretto per ' +
                                      currentProduct.productName),
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
                          currentProduct.extra = currentProduct.extra + 1;
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
