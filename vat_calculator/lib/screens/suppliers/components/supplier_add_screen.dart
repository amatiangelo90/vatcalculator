import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/components/default_button.dart';
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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static TextEditingController controllerPIva = TextEditingController();
  static TextEditingController controllerCompanyName = TextEditingController();
  static TextEditingController controllerEmail = TextEditingController();
  static TextEditingController controllerAddress = TextEditingController();
  static TextEditingController controllerAddressCiy = TextEditingController();
  static TextEditingController controllerAddressCap = TextEditingController();
  static TextEditingController controllerMobileNo = TextEditingController();

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
                    'Aggiungi Nuovo Fornitore',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(17),
                      color: kCustomWhite,
                    ),
                  ),
                ],
              ),
              elevation: 2,
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Form(
                      key: _formKey,
                      autovalidate: false,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 20),
                          TextFormField(
                            maxLines: 1,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.add_business,
                                color: Colors.grey,
                              ),
                              hintText: 'Ragione Sociale',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            controller: controllerCompanyName,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Colors.grey,
                              ),
                              hintText: 'Cellulare',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            controller: controllerMobileNo,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.grey,
                              ),
                              hintText: 'eMail',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            controller: controllerEmail,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.all_inbox,
                                color: Colors.grey,
                              ),
                              hintText: 'Partita Iva',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            controller: controllerPIva,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            minLines: 1,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.home,
                                color: Colors.grey,
                              ),
                              hintText: 'Indirizzo',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            controller: controllerAddress,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            minLines: 1,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.home,
                                color: Colors.grey,
                              ),
                              hintText: 'Città',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            controller: controllerAddressCiy,
                          ),

                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            minLines: 1,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.home,
                                color: Colors.grey,
                              ),
                              hintText: 'CAP',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            controller: controllerAddressCap,
                          ),
                          const SizedBox(height: 40,),
                          DefaultButton(
                            text: "Crea Fornitore",
                            press: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
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
                            },
                          ),
                          SizedBox(height: 30,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }



  Future<void> saveProviderData(DataBundleNotifier dataBundleNotifier, context) async {
    // bool resultValidation = await validateData(mapData, context);

    ClientVatService clientService = ClientVatService();
    if(true){
      ResponseAnagraficaFornitori supplier = ResponseAnagraficaFornitori(
        pkSupplierId: 0,
        cf: '',
        extra: '',
        fax: '',
        id: '',
        indirizzo_cap: controllerAddressCap.text,
        indirizzo_citta: controllerAddressCiy.text,
        indirizzo_extra: '',
        indirizzo_provincia: '',
        indirizzo_via: controllerAddress.text,
        mail: controllerEmail.text,
        nome: controllerCompanyName.text,
        paese: 'Italia',
        pec: '',
        piva: controllerPIva.text,
        referente: '',
        tel: controllerMobileNo.text,
        fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
      );


      controllerPIva.clear();
      controllerAddress.clear();
      controllerCompanyName.clear();
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
          content: Text('Fornitore ' + controllerCompanyName.text +' creato',
          )
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushNamed(context, SuppliersScreen.routeName);
    }
  }
}

