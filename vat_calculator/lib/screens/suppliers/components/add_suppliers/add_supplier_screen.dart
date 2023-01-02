import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import 'package:vat_calculator/swagger/swagger.models.swagger.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';

class AddSupplierScreen extends StatefulWidget {
  AddSupplierScreen({Key? key}) : super(key: key);

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

  String currentPassword = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            bottomSheet: Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      child: CupertinoButton(
                          color: kCustomGreen,
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
                                Response apiV1AppSuppliersSavePost = await dataBundleNotifier.getSwaggerClient().apiV1AppSuppliersSavePost(
                                    supplier: Supplier(
                                        supplierId: 0,
                                        cap: controllerCap.text,
                                        city: controllerCity.text,
                                        address: controllerAddress.text,
                                        email: controllerEmail.text,
                                        name: controllerSupplierName.text,
                                        pec: '',
                                        cf: '',
                                        createdByUserId: dataBundleNotifier.getUserEntity().userId,
                                        country: 'ITALIA',
                                        vatNumber: controllerPIva.text,
                                        phoneNumber: controllerMobileNo.text,
                                        branchId: dataBundleNotifier.getCurrentBranch().branchId!.toInt()
                                    )
                                );

                                if(apiV1AppSuppliersSavePost.isSuccessful){
                                  final snackBar = SnackBar(
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.green,
                                      content: Text('Fornitore ' + controllerSupplierName.text +' creato',
                                      )
                                  );

                                  dataBundleNotifier.refreshCurrentBranchData();

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  Navigator.pushNamed(context, SuppliersScreen.routeName);
                                  clearControllers();
                                }else{
                                  final snackBar = SnackBar(
                                      duration: const Duration(seconds: 4),
                                      backgroundColor: Colors.redAccent,
                                      content: Text('Errore durante la creazione del fornitore. Riprovare fra 2 minuti o contattare l\'amministratore del sistema. Err: ' + apiV1AppSuppliersSavePost.error.toString(),
                                      )
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
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
              iconTheme: const IconThemeData(color: kCustomGrey),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'Crea Nuovo Fornitore',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(19),
                      color: kCustomGrey,
                    ),
                  ),
                ],
              ),
              elevation: 0,
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



