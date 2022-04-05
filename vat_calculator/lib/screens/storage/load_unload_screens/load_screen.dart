import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class LoadStorageScreen extends StatefulWidget {
  const LoadStorageScreen({Key key}) : super(key: key);

  static String routeName = 'load_screen_storage';

  @override
  State<LoadStorageScreen> createState() => _LoadStorageScreenState();
}

class _LoadStorageScreenState extends State<LoadStorageScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
      return Scaffold(
        key: _scaffoldKey,
        bottomSheet: Padding(
          padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
          child: DefaultButton(
            color: Colors.green.shade700,
            text: 'Effettua Carico',
            press: () {

              int currentProductWithMorethan0Amount = 0;

              dataBundleNotifier.currentStorageProductListForCurrentStorageLoad.forEach((element) {
                if (element.stock != 0) {
                  currentProductWithMorethan0Amount = currentProductWithMorethan0Amount + 1;
                }
              });

              if (currentProductWithMorethan0Amount == 0) {
                _scaffoldKey.currentState.showSnackBar(const SnackBar(
                  backgroundColor: kPinaColor,
                  content: Text(
                      'Immettere la quantità di carico per almeno un prodotto'),
                ));
              } else {
                dataBundleNotifier.currentStorageProductListForCurrentStorageLoad.forEach((element) {
                  dataBundleNotifier.currentStorageProductListForCurrentStorage.forEach((standardElement) {
                    if (standardElement.pkStorageProductId == element.pkStorageProductId) {
                      element.stock = standardElement.stock + element.stock;
                    }
                  });
                });
                ClientVatService getclientServiceInstance = dataBundleNotifier.getclientServiceInstance();

                //TODO aggiungere lista merce aggiunta a fronte del carico
                getclientServiceInstance.updateStock(
                  currentStorageProductListForCurrentStorageUnload: dataBundleNotifier.currentStorageProductListForCurrentStorageLoad,
                    actionModel: ActionModel(
                        date: DateTime.now().millisecondsSinceEpoch,
                        description: 'Ha eseguito carico merce nel magazzino ${dataBundleNotifier.currentStorage.name}. ',
                        fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                        user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                        type: ActionType.STORAGE_LOAD
                    )
                );

                dataBundleNotifier.clearUnloadProductList();
                dataBundleNotifier.refreshProductListAfterInsertProductIntoStorage();
                refreshPage(dataBundleNotifier);
              }
            },
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: getProportionateScreenHeight(20),
            ),
          ),
          actions: [
            IconButton(onPressed: (){
              dataBundleNotifier.clearLoadProductList();
            }, icon: Icon(Icons.clear, color: kPinaColor, size: getProportionateScreenWidth(20),))
          ],
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: Column(
            children: [
              Text(
                dataBundleNotifier.currentStorage.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionateScreenHeight(17)),
              ),
              Text('Sezione Carico Magazzino', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreenAccent, fontSize: getProportionateScreenHeight(11)),),
            ],
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: Colors.white,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: buildCurrentListProdutctTableForStockManagmentLoad(
                        dataBundleNotifier, context),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  buildCurrentListProdutctTableForStockManagmentLoad(
      DataBundleNotifier dataBundleNotifier, context) {
    List<Widget> rows = [
    ];

    dataBundleNotifier.currentStorageProductListForCurrentStorageLoad
        .forEach((element) {
      TextEditingController controller =
          TextEditingController(text: element.stock.toString());
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
                  child: Text(
                    element.productName,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: getProportionateScreenWidth(18)),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      element.unitMeasure,
                        style: TextStyle(fontSize: getProportionateScreenWidth(10), fontWeight: FontWeight.bold, color: kCustomGreenAccent),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        FontAwesomeIcons.dotCircle,
                        size: getProportionateScreenWidth(3),
                      ),
                    ),
                    dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? Text('',style:
                    TextStyle(fontSize: getProportionateScreenWidth(8))) : Text(
                      element.price.toString() + ' €',
                      style:
                          TextStyle(fontSize: getProportionateScreenWidth(10), fontWeight: FontWeight.bold, color: kPrimaryColor)
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
                      if (element.stock <= 0) {
                      } else {
                        element.stock--;
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
                        element.stock = double.parse(text.replaceAll(',', '.'));
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
                      element.stock = element.stock + 1;
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
      );
      rows.add(Divider(height: 0.3, color: Colors.grey.withOpacity(0.2),));
    });
    return Column(
      children: rows,
    );
  }

  refreshPage(DataBundleNotifier dataBundleNotifier) {
    dataBundleNotifier.refreshProductListAfterInsertProductIntoStorage();
  }
}
