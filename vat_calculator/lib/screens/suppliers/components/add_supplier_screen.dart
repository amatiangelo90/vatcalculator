import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class AddSupplierScreen extends StatefulWidget {
  AddSupplierScreen({Key key}) : super(key: key);

  static String routeName = 'addsupplier';

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {

  static TextEditingController controllerPIva = TextEditingController();
  static TextEditingController controllerCap = TextEditingController();
  static TextEditingController controllerCity = TextEditingController();
  static TextEditingController controllerSupplierName = TextEditingController();
  static TextEditingController controllerEmail = TextEditingController();
  static TextEditingController controllerAddress = TextEditingController();
  static TextEditingController controllerAddressCiy = TextEditingController();
  static TextEditingController controllerAddressCap = TextEditingController();
  static TextEditingController controllerMobileNo = TextEditingController();

  static TextEditingController branchCodeControllerSearch = TextEditingController();
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  final formKey = GlobalKey<FormState>();

  String currentPassword;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, SuppliersScreen.routeName),
                  }
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'Crea Nuovo Fornitore',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(17),
                      color: kCustomWhite,
                    ),
                  ),
                ],
              ),
              elevation: 2,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                autovalidate: false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: const [
                          Text('Nome*'),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Nome Attività',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerSupplierName,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                        placeholder: 'Nome Attività',
                      ),
                      Row(
                        children: [
                          Text('Email*'),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerEmail,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                        placeholder: 'Email',
                      ),
                      Row(
                        children: [
                          Text('Cellulare*'),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Cellulare',
                        keyboardType: TextInputType.number,
                        controller: controllerMobileNo,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                        placeholder: 'Cellulare',
                      ),
                      Row(
                        children: [
                          Text('Partita Iva'),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Partita Iva',
                        keyboardType: TextInputType.number,
                        controller: controllerPIva,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                        placeholder: 'Partita Iva',
                      ),
                      Row(
                        children: [
                          Text('Indirizzo'),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Indirizzo',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerAddress,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                        placeholder: 'Indirizzo',
                      ),
                      Row(
                        children: [
                          Text('Città'),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Città',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerCity,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                        placeholder: 'Città',
                      ),
                      Row(
                        children: [
                          Text('Cap'),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Cap',
                        keyboardType: TextInputType.number,
                        controller: controllerCap,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                        placeholder: 'Cap',
                      ),
                      const Text('*campo obbligatorio'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CupertinoButton(
                                color: kPrimaryColor,
                                child: const Text('Salva Fornitore'),
                                onPressed: () async {
                                  if(controllerSupplierName.text == null || controllerSupplierName.text == ''){
                                    print('Il nome del fornitore è obbligatorio');
                                    CoolAlert.show(
                                      onConfirmBtnTap: (){},
                                      confirmBtnColor: kPinaColor,
                                      backgroundColor: kPinaColor,
                                      context: context,
                                      title: 'Errore',
                                      type: CoolAlertType.error,
                                      text: 'Il nome del fornitore è obbligatorio',
                                      autoCloseDuration: Duration(seconds: 2),
                                      onCancelBtnTap: (){},
                                    );

                                  }else if(controllerEmail.text == null || controllerEmail.text == ''){
                                    print('L\'indirizzo email è obbligatorio');
                                    CoolAlert.show(
                                        onConfirmBtnTap: (){},
                                        backgroundColor: kPinaColor,
                                        context: context,
                                        title: 'Errore',
                                        type: CoolAlertType.error,
                                        text: 'L\'indirizzo email è obbligatorio',
                                        autoCloseDuration: Duration(seconds: 3),
                                        onCancelBtnTap: (){}
                                    );
                                  }else if(controllerMobileNo.text == null || controllerMobileNo.text == ''){
                                    print('Cellulare obbligatorio');
                                    CoolAlert.show(
                                        onConfirmBtnTap: (){},
                                        backgroundColor: kPinaColor,
                                        context: context,
                                        title: 'Errore',
                                        type: CoolAlertType.error,
                                        text: 'Inserire il numero di cellulare',
                                        autoCloseDuration: Duration(seconds: 3),
                                        onCancelBtnTap: (){}
                                    );
                                  }else{
                                    KeyboardUtil.hideKeyboard(context);
                                    try{
                                      saveProviderData(dataBundleNotifier, context);
                                    }catch(e){
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          duration: const Duration(milliseconds: 5000),
                                          backgroundColor: Colors.red,
                                          content: Text('Impossibile creare fornitore. Riprova più tardi. Errore: $e', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                                    }
                                  }

                                }),
                          ),
                        ],
                      ),
                      const Text(' - '),
                      const Text('oppure associane uno alla tua attività tramite codice', textAlign: TextAlign.center,),
                      SizedBox(height: getProportionateScreenHeight(10),),
                      _buildInputPasswordForEventWidget(dataBundleNotifier),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CupertinoButton(
                                color: kPrimaryColor,
                                child: const Text('Associa Fornitore'),
                                onPressed: () async {

                                }),
                          ),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenHeight(50),),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }


  Future<void> saveProviderData(DataBundleNotifier dataBundleNotifier, context) async {

    ClientVatService clientService = ClientVatService();
    if(true){
      ResponseAnagraficaFornitori supplier = ResponseAnagraficaFornitori(
        pkSupplierId: 0,
        cf: '',
        extra: getUniqueCustomId(),
        fax: '',
        id: '',
        indirizzo_cap: controllerAddressCap.text,
        indirizzo_citta: controllerAddressCiy.text,
        indirizzo_extra: '',
        indirizzo_provincia: '',
        indirizzo_via: controllerAddress.text,
        mail: controllerEmail.text,
        nome: controllerSupplierName.text,
        paese: 'Italia',
        pec: '',
        piva: controllerPIva.text,
        referente: '',
        tel: controllerMobileNo.text,
        fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
      );


      controllerPIva.clear();
      controllerAddress.clear();
      controllerSupplierName.clear();
      controllerMobileNo.clear();
      controllerEmail.clear();
      controllerAddressCiy.clear();
      controllerAddressCap.clear();

      print('Saving the following provider to database: ');
      print(supplier.toMap());
      await clientService.performSaveSupplier(supplier);

      List<ResponseAnagraficaFornitori> _suppliersList = await clientService.retrieveSuppliersListByBranch(dataBundleNotifier.currentBranch);

      dataBundleNotifier.addCurrentSuppliersList(_suppliersList);
      final snackBar =
      SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
          content: Text('Fornitore ' + controllerSupplierName.text +' creato',
          )
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushNamed(context, SuppliersScreen.routeName);
    }
  }

  getUniqueCustomId() {
    String microSecondsSinceEpoch = DateTime.now().microsecondsSinceEpoch.toString();
    return microSecondsSinceEpoch.substring(microSecondsSinceEpoch.length -8, microSecondsSinceEpoch.length);
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
              controller: branchCodeControllerSearch,
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
                List<ResponseAnagraficaFornitori> retrieveSuppliersListByCode = await dataBundleNotifier.getclientServiceInstance().retrieveSuppliersListByCode(
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

                    if(!alreadyPresent){

                    }else{
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
                                  height: height - 450,
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
                                            color: Colors.green,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('  Complimenti',style: TextStyle(
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
                                              Column(
                                                children: [
                                                  Text('Aggiungere alla tua lista il seguente fornitore?', textAlign: TextAlign.center,),
                                                  Text(''),
                                                  Text('' + retrieveSuppliersListByCode[0].nome),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // buildDateList(),
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
                child: TextButton(
                  child: Text("Clear",style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(13)),),
                  onPressed: () {
                    branchCodeControllerSearch.clear();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



