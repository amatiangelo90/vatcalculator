import 'dart:io';

import 'package:dio/dio.dart';
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

import '../../../client/vatservice/model/move_product_between_storage_model.dart';
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
        backgroundColor: kPrimaryColor,
        key: _scaffoldKey,
        bottomSheet: Container(
          color: kPrimaryColor,
          child: Padding(
            padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
            child: DefaultButton(
              color: Colors.green,
              text: 'Effettua Carico',
              press: () async {

                int currentProductWithMorethan0Amount = 0;

                dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated.forEach((element) {
                  if (element.loadUnloadAmount != 0) {
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

                  List<MoveProductBetweenStorageModel> listMoveProductBetweenStorageModel = [];

                  dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated.forEach((element) {
                      if (element.loadUnloadAmount > 0) {
                        element.loadUnloadAmount = element.stock + element.loadUnloadAmount;
                        listMoveProductBetweenStorageModel.add(
                            MoveProductBetweenStorageModel(
                                amount: element.loadUnloadAmount,
                                pkProductId: element.fkProductId,
                                storageIdFrom: 0,
                                storageIdTo: dataBundleNotifier.currentStorage.pkStorageId
                            )
                        );
                      }
                  });

                  Response response = await dataBundleNotifier.getclientServiceInstance()
                      .moveProductBetweenStorage(listMoveProductBetweenStorageModel: listMoveProductBetweenStorageModel,
                      actionModel: ActionModel(
                          date: DateTime.now().millisecondsSinceEpoch,
                          description: 'Ha effettuato carico in magazzino ${dataBundleNotifier.currentStorage.pkStorageId}',
                          fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                          user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                          type: ActionType.STORAGE_LOAD
                      )
                  );
                  if(response != null && response.data == 1){
                    dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                          'Carico effettuato per magazzino ${dataBundleNotifier.currentStorage.name}'),
                    ));
                  }else{
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      backgroundColor: kPinaColor,
                      content: Text(
                          'Errore. Carico non effettuato per magazzino ${dataBundleNotifier.currentStorage.name}. Riprova fra un paio di minuti.'),
                    ));
                  }


                }
              },
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 5,
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
              dataBundleNotifier.clearLoadUnloadParameterOnEachProductForCurrentStorage();
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
              Text('Sezione Carico Magazzino', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: getProportionateScreenHeight(12)),),
            ],
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: kPrimaryColor,
            child: Column(
              children: [
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
      );
    });
  }

  buildCurrentListProdutctTableForStockManagmentLoad(
      DataBundleNotifier dataBundleNotifier, context) {
    List<Widget> rows = [
    ];

    dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated
        .forEach((element) {
      TextEditingController controller;

          if(element.loadUnloadAmount > 0){
            controller = TextEditingController(text: element.loadUnloadAmount.toString());
          }else{
            controller = TextEditingController();
          }

      rows.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Row(
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
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenWidth(18)),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        element.unitMeasure,
                          style: TextStyle(fontSize: getProportionateScreenWidth(12), fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          FontAwesomeIcons.dotCircle,
                          size: getProportionateScreenWidth(3),
                        ),
                      ),
                      dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? Text('',style:
                      TextStyle(fontSize: getProportionateScreenWidth(10))) : Text(
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
                        if (element.loadUnloadAmount <= 0) {
                        } else {
                          element.loadUnloadAmount--;
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
                          element.loadUnloadAmount = double.parse(text.replaceAll(',', '.'));
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
                        element.loadUnloadAmount = element.loadUnloadAmount + 1;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(FontAwesomeIcons.plus,
                          color: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      rows.add(Divider(height: 0.3, color: Colors.grey.withOpacity(0.2),));
    });
    return Column(
      children: rows,
    );
  }
}
