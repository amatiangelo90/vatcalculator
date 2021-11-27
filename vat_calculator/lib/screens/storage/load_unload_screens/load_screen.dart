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
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
      return Scaffold(
        bottomSheet: Padding(
          padding: const EdgeInsets.all(8.0),
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
                Scaffold.of(context).showSnackBar(const SnackBar(
                  backgroundColor: kPinaColor,
                  content: Text(
                      'Immettere la quantità di carico per almeno un prodotto'),
                ));
              } else {
                dataBundleNotifier.currentStorageProductListForCurrentStorageLoad.forEach((element) {
                  dataBundleNotifier.currentStorageProductListForCurrentStorage.forEach((standardElement) {
                    if (standardElement.pkStorageProductId ==
                        element.pkStorageProductId) {
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
              color: kPrimaryColor,
              size: getProportionateScreenHeight(20),
            ),
          ),
          actions: [
            IconButton(onPressed: (){
              dataBundleNotifier.clearLoadProductList();
            }, icon: Icon(Icons.clear, color: kPinaColor,))
          ],
          centerTitle: true,
          title: Text(
            dataBundleNotifier.currentStorage.name,
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: getProportionateScreenHeight(15)),
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
    List<Row> rows = [
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
                    style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      element.unitMeasure,
                      style:
                          TextStyle(fontSize: getProportionateScreenWidth(8)),
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
                          TextStyle(fontSize: getProportionateScreenWidth(8)),
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
                      if (double.tryParse(text) != null) {
                        element.stock = double.parse(text);
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text(
                              'Immettere un valore numerico corretto per ' +
                                  element.productName),
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
    });
    return Column(
      children: rows,
    );
  }

  refreshPage(DataBundleNotifier dataBundleNotifier) {
    dataBundleNotifier.refreshProductListAfterInsertProductIntoStorage();
  }
}
