import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';

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
  static TextEditingController controllerMobileNo = TextEditingController();

  bool hasError = false;
  final formKey = GlobalKey<FormState>();

  String currentPassword;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 35,
                      child: CupertinoButton(
                          color: kCustomGreenAccent,
                          child: const Text('Salva Fornitore'),
                          onPressed: () async {
                            if(controllerSupplierName.text == null || controllerSupplierName.text == ''){
                              print('Il nome del fornitore è obbligatorio');
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                                  duration: Duration(milliseconds: 800),
                                  content: Text('Il nome del fornitore è obbligatorio')));
                            }else if(controllerEmail.text == null || controllerEmail.text == ''){
                              print('L\'indirizzo email è obbligatorio');
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                                  duration: Duration(milliseconds: 800),
                                  content: Text('L\'indirizzo email è obbligatorio')));
                            }else if(controllerMobileNo.text == null || controllerMobileNo.text == ''){
                              print('Cellulare obbligatorio');
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                                  duration: Duration(milliseconds: 800),
                                  content: Text('Il numero di cellulare è obbligatorio')));
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
                  ),
                ],
              ),
            ),
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
                      color: kCustomGreenAccent,
                    ),
                  ),
                ],
              ),
              elevation: 2,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
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
                        restorationId: 'Nome Fornitore',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerSupplierName,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                        placeholder: 'Nome Fornitore',
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

    if(true){
      SupplierModel supplier = SupplierModel(
        pkSupplierId: 0,
        cf: '',
        extra: getUniqueCustomId(),
        fax: '',
        id: dataBundleNotifier.userDetailsList[0].id.toString(),
        indirizzo_cap: controllerCap.text,
        indirizzo_citta: controllerCity.text,
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
      clearControllers();

      print(supplier.toMap());
      await dataBundleNotifier.getclientServiceInstance().performSaveSupplier(
          anagraficaFornitore: supplier,
          actionModel: ActionModel(
              date: DateTime.now().millisecondsSinceEpoch,
              description: 'Ha creato il fornitore ${supplier.nome}',
              fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
              user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
              type: ActionType.SUPPLIER_CREATION
          )
      );

      List<SupplierModel> _suppliersList = await dataBundleNotifier.getclientServiceInstance().retrieveSuppliersListByBranch(dataBundleNotifier.currentBranch);

      dataBundleNotifier.addCurrentSuppliersList(_suppliersList);
      dataBundleNotifier.clearAndUpdateMapBundle();
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

  void clearControllers() {
    setState(() {
        controllerPIva.clear();
        controllerAddress.clear();
        controllerSupplierName.clear();
        controllerMobileNo.clear();
        controllerEmail.clear();
        controllerCity.clear();
        controllerCap.clear();
    });
  }
}



