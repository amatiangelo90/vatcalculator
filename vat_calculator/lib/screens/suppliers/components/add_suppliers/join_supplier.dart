import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';

class JoinSupplierScreen extends StatefulWidget {
  JoinSupplierScreen({Key? key}) : super(key: key);

  static String routeName = 'joinsupplier';

  @override
  State<JoinSupplierScreen> createState() => _JoinSupplierScreenState();
}

class _JoinSupplierScreenState extends State<JoinSupplierScreen> {

  static TextEditingController supplierCodeControllerSearch = TextEditingController();

  final formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType> errorController = StreamController();

  bool hasError = false;
  String currentPassword = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            backgroundColor: kCustomGrey,

            appBar: AppBar(

              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, SuppliersScreen.routeName),
                  }
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kCustomGrey,
              centerTitle: true,
              title: Text(
                'Associa Fornitore',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(19),
                  color: Colors.white,
                ),
              ),
              elevation: 5,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        const Text('Immetti qui il codice del fornitore', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                        SizedBox(height: getProportionateScreenHeight(30),),
                        _buildInputPasswordForEventWidget(dataBundleNotifier),
                        SizedBox(height: getProportionateScreenHeight(60),),
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
                inactiveColor: kCustomGrey,
                selectedColor: Colors.lightBlueAccent,
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
                formKey.currentState?.validate();
                print('Retrieve Supplier model by code : ' + code);
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
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: CupertinoButton(
                    color: Colors.lightBlueAccent,
                    child: Text("Clear", style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(18)),),
                    onPressed: () {
                      supplierCodeControllerSearch.clear();
                    },
                  ),
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
      child: const Text("Indietro", style: TextStyle(color: kCustomGrey),),
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



