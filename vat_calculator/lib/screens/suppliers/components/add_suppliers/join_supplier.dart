import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';

class JoinSupplierScreen extends StatefulWidget {
  JoinSupplierScreen({Key key}) : super(key: key);

  static String routeName = 'joinsupplier';

  @override
  State<JoinSupplierScreen> createState() => _JoinSupplierScreenState();
}

class _JoinSupplierScreenState extends State<JoinSupplierScreen> {

  static TextEditingController supplierCodeControllerSearch = TextEditingController();

  final formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentPassword;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            bottomSheet: Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
            ),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, SuppliersScreen.routeName),
                  }
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.black,
              centerTitle: true,
              title: Text(
                'Associa Fornitore',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(17),
                  color: kCustomGreenAccent,
                ),
              ),
              elevation: 2,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        const Text('Immetti qui il codice che ti ha fornitore il fornitore', textAlign: TextAlign.center,),
                        SizedBox(height: getProportionateScreenHeight(10),),
                        _buildInputPasswordForEventWidget(dataBundleNotifier),
                        SizedBox(height: getProportionateScreenHeight(50),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }


  Widget _buildInputPasswordForEventWidget(DataBundleNotifier dataBundleNotifier) {
    return Container(
      child: Column(
        children: <Widget>[
          Form(
            key: formKey,
            child: PinCodeTextField(
              appContext: context,
              length: 8,
              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              textStyle: const TextStyle(color: Colors.black),
              pinTheme: PinTheme(
                inactiveColor: kPrimaryColor,
                selectedColor: kPinaColor,
                activeColor: Colors.white,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(4),
                fieldHeight: getProportionateScreenHeight(40),
                fieldWidth: getProportionateScreenHeight(40),
                activeFillColor:
                hasError ? Colors.blue.shade100 : Colors.white,
              ),
              cursorColor: Colors.black,
              animationDuration: const Duration(milliseconds: 300),
              errorAnimationController: errorController,
              controller: supplierCodeControllerSearch,
              keyboardType: TextInputType.number,
              boxShadows: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  color: Colors.white,
                  blurRadius: 1,
                )
              ],
              onCompleted: (code) async {
                formKey.currentState.validate();
                print('Retrieve Supplier model by code : ' + code);
                List<SupplierModel> retrieveSuppliersListByCode = await dataBundleNotifier.getclientServiceInstance().retrieveSuppliersListByCode(
                    code: code
                );
                bool alreadyPresent = false;
                if(retrieveSuppliersListByCode != null && retrieveSuppliersListByCode.isNotEmpty){
                  if(retrieveSuppliersListByCode.length == 1){
                    dataBundleNotifier.currentListSuppliers.forEach((alreadyPresentSupplier) {
                      if(alreadyPresentSupplier.pkSupplierId == retrieveSuppliersListByCode[0].pkSupplierId){
                        alreadyPresent = true;
                      }
                    });

                    if(alreadyPresent){
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog (
                            contentPadding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(
                                    Radius.circular(10.0))),
                            content: Builder(
                              builder: (context) {
                                var height = MediaQuery.of(context).size.height;
                                var width = MediaQuery.of(context).size.width;
                                return SizedBox(
                                  height: getProportionateScreenHeight(340),
                                  width: width - 90,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                topLeft: Radius.circular(10.0) ),
                                            color: kPinaColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('    Attenzione',style: TextStyle(
                                                      fontSize: getProportionateScreenWidth(15),
                                                      fontWeight: FontWeight.bold,
                                                      color: kCustomWhite,
                                                    ),),
                                                    IconButton(icon: const Icon(
                                                      Icons.clear,
                                                      color: kCustomWhite,
                                                    ), onPressed: () {
                                                      Navigator.pop(context);
                                                      },),

                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('Il seguente fornitore ', style: TextStyle(fontSize: getProportionateScreenWidth(13)), textAlign: TextAlign.center,),
                                              SizedBox(width: getProportionateScreenHeight(30),),
                                              Card(child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('' + retrieveSuppliersListByCode[0].nome, style: TextStyle(fontSize: getProportionateScreenWidth(25)), textAlign: TextAlign.center,),
                                              )),
                                              SizedBox(width: getProportionateScreenHeight(30),),
                                              Text('con codice ', style: TextStyle(fontSize: getProportionateScreenWidth(13)), textAlign: TextAlign.center,),
                                              Card(child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(code, style: TextStyle(fontSize: getProportionateScreenWidth(25)), textAlign: TextAlign.center,),
                                              )),

                                              SizedBox(width: getProportionateScreenHeight(30),),
                                              Text('risulta già associato alla tua attività.', style: TextStyle(fontSize: getProportionateScreenWidth(13)), textAlign: TextAlign.center,),

                                              SizedBox(width: getProportionateScreenHeight(30),),
                                              SizedBox(width: 0,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                      );
                    }else{

                      Widget cancelButton = TextButton(
                        child: const Text("Indietro", style: TextStyle(color: kPinaColor),),
                        onPressed:  () {
                          clearControllers();
                          Navigator.of(context).pop();
                        },
                      );
                      Widget continueButton = TextButton(
                        child: const Text("Aggiungi", style: TextStyle(color: Colors.green)),
                        onPressed:  () async {

                          print('Adding retrieved supplier ' + retrieveSuppliersListByCode[0].nome + ' to branch ' +
                              dataBundleNotifier.currentBranch.companyName + ' with id ' + dataBundleNotifier.currentBranch.pkBranchId.toString());

                          SupplierModel supplierRetrievedByCodeToUpdateRelationTableBranchSupplier = retrieveSuppliersListByCode[0];

                          supplierRetrievedByCodeToUpdateRelationTableBranchSupplier.fkBranchId = dataBundleNotifier.currentBranch.pkBranchId;
                          await dataBundleNotifier.getclientServiceInstance().addSupplierToCurrentBranch(
                              supplierRetrievedByCodeToUpdateRelationTableBranchSupplier: supplierRetrievedByCodeToUpdateRelationTableBranchSupplier,
                              actionModel: ActionModel(
                                  date: DateTime.now().millisecondsSinceEpoch,
                                  description: 'Ha associato a ${dataBundleNotifier.currentBranch.companyName} il fornitore ${supplierRetrievedByCodeToUpdateRelationTableBranchSupplier.nome} tramite il codice ${supplierCodeControllerSearch.text.toString()}.',
                                  fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                  user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                  type: ActionType.SUPPLIER_ASSOCIATION
                              )
                          );

                          List<SupplierModel> _suppliersList = await dataBundleNotifier.getclientServiceInstance()
                              .retrieveSuppliersListByBranch(dataBundleNotifier.currentBranch);
                          dataBundleNotifier.addCurrentSuppliersList(_suppliersList);
                          dataBundleNotifier.clearAndUpdateMapBundle();
                          clearControllers();
                          Navigator.pushNamed(context, SuppliersScreen.routeName);
                        },
                      );

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog (
                            actions: [
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceAround,
                                children: [
                                  cancelButton,
                                  continueButton,
                                ],
                              ),
                            ],
                            contentPadding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(
                                    Radius.circular(10.0))),
                            content: Builder(
                              builder: (context) {
                                var height = MediaQuery.of(context).size.height;
                                var width = MediaQuery.of(context).size.width;
                                return SizedBox(
                                  height: getProportionateScreenHeight(300),
                                  width: width - 90,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                topLeft: Radius.circular(10.0) ),
                                            color: kPrimaryColor,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('    Aggiungi Fornitore',style: TextStyle(
                                                    fontSize: getProportionateScreenWidth(15),
                                                    fontWeight: FontWeight.bold,
                                                    color: kCustomWhite,
                                                  ),),
                                                  IconButton(icon: const Icon(
                                                    Icons.clear,
                                                    color: kCustomWhite,
                                                  ), onPressed: () { Navigator.pop(context); },),

                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            const Text('Aggiungere alla tua lista il seguente fornitore?', textAlign: TextAlign.center,),
                                            SizedBox(width: getProportionateScreenHeight(20),),
                                            Text('' + retrieveSuppliersListByCode[0].nome, style: TextStyle(fontSize: getProportionateScreenWidth(25)), textAlign: TextAlign.center,),
                                            const SizedBox(width: 0,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                      );
                    }
                  }else{

                  }
                }else{
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                      backgroundColor: Colors.redAccent.withOpacity(0.8),
                      duration: Duration(milliseconds: 3000),
                      content: Text('Nessun fornitore trovato con il seguente codice: ' + supplierCodeControllerSearch.text)));
                  clearControllers();
                }
              },
              onChanged: (value) {
                setState(() {
                  currentPassword = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: CupertinoButton(
                  color: Colors.black54.withOpacity(0.5),
                  child: Text("Clear", style: TextStyle(color: kCustomGreenAccent, fontSize: getProportionateScreenHeight(18)),),
                  onPressed: () {
                    supplierCodeControllerSearch.clear();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  void buildShowErrorDialog(String text) {
    Widget cancelButton = TextButton(
      child: const Text("Indietro", style: TextStyle(color: kPrimaryColor),),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          actions: [
            cancelButton
          ],
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return SizedBox(
                height: getProportionateScreenHeight(150),
                width: width - 90,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0) ),
                          color: kPinaColor,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('  Errore ',style: TextStyle(
                                  fontSize: getProportionateScreenWidth(14),
                                  fontWeight: FontWeight.bold,
                                  color: kCustomWhite,
                                ),),
                                IconButton(icon: const Icon(
                                  Icons.clear,
                                  color: kCustomWhite,
                                ), onPressed: () { Navigator.pop(context); },),

                              ],
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text(text,
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
    );
  }

  void clearControllers() {
    setState(() {
      supplierCodeControllerSearch.clear();
    });
  }
}



