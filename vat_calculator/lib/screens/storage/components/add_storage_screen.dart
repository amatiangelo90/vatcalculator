import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../storage_screen.dart';

class AddStorageScreen extends StatelessWidget {
  const AddStorageScreen({Key key, this.branch}) : super(key: key);

  final BranchModel branch;
  static String routeName = "/addstoragescreen";

  @override
  Widget build(BuildContext context) {


    TextEditingController _nameController = TextEditingController();
    TextEditingController _addressController = TextEditingController(text: branch.address);
    TextEditingController _cityController = TextEditingController(text: branch.city);
    TextEditingController _capController;
    if(branch.cap == null || branch.cap == ''){
      _capController = TextEditingController();
    }else{
     _capController = TextEditingController(text: branch.cap.toString());
    }


    void buildSnackBar({@required String text, @required Color color}) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 2000),
          backgroundColor: color,
          content: Text(text, style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
    }

    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Scaffold(
          bottomSheet: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoButton(
                color: kPrimaryColor,
                child: const Text('Crea Magazzino'),
                onPressed: () async {
                  if(_nameController.text.isEmpty || _nameController.text == ''){
                    buildSnackBar(text: 'Inserire il nome del magazzino', color: kPinaColor);
                  }else if(_addressController.text.isEmpty || _addressController.text == ''){
                    buildSnackBar(text: 'Inserire l\'indirizzo', color: kPinaColor);
                  }else if(_cityController.text.isEmpty || _cityController.text == ''){
                    buildSnackBar(text: 'Inserire la città', color: kPinaColor);
                  }else if(_capController.text.isEmpty || _capController.text == ''){
                    buildSnackBar(text: 'Inserire il cap', color: kPinaColor);
                  }else if(dataBundleNotifier.retrieveListStoragesName().contains(_nameController.text)){
                    buildSnackBar(text: 'Esiste già un magazzino con questo nome : ' + _nameController.text, color: kPinaColor);
                  }else{

                    //EasyLoading.show();

                    ClientVatService vatService = ClientVatService();
                    StorageModel storageModel = StorageModel(
                        name: _nameController.text,
                        fkBranchId: branch.pkBranchId,
                        address: _addressController.text,
                        cap: _capController.text,
                        city: _cityController.text,
                        code: Uuid().v1().toString(),
                        creationDate: DateTime.now(),
                        pkStorageId: 0
                    );
                    Response performSaveStorage = await vatService.performSaveStorage(storageModel);
                    //sleep(const Duration(seconds: 1));


                    if(performSaveStorage != null && performSaveStorage.statusCode == 200){

                      List<StorageModel> retrievedStorageList = await vatService.retrieveStorageListByBranch(branch);
                      dataBundleNotifier.addCurrentStorageList(retrievedStorageList);
                      dataBundleNotifier.clearAndUpdateMapBundle();
                      //EasyLoading.dismiss();
                      buildSnackBar(text: 'Magazzino ' + _nameController.text + ' creato per  ' + branch.companyName, color: Colors.green.shade700);
                    }else{
                      //EasyLoading.dismiss();
                      buildSnackBar(text: 'Si sono verificati problemi durante il salvataggio. Risposta servizio: ' + performSaveStorage.toString(), color: kPinaColor);
                    }
                    Navigator.pushNamed(context, StorageScreen.routeName);
                  }

                }),
              ),
            ],
          ),
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: kCustomWhite,),
                onPressed: () => {
                  Navigator.of(context).pop(),
                }
            ),
            centerTitle: true,
            title: Text('Crea Magazzino',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(17),
                color: kCustomWhite,
              ),
            ),
            backgroundColor: kPrimaryColor,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(

              children: [
                const SizedBox(height: 20,),
                Row(
                  children: [
                    const SizedBox(width: 11,),
                    Text('   Nome*', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *0.05,
                    child: CupertinoTextField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      autocorrect: false,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    const SizedBox(width: 11,),
                    Text('   Indirizzo', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *0.05,
                    child: CupertinoTextField(
                      controller: _addressController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      autocorrect: false,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    const SizedBox(width: 11,),
                    Text('   Città', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *0.05,
                    child: CupertinoTextField(
                      controller: _cityController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      autocorrect: false,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    const SizedBox(width: 11,),
                    Text('   Cap', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *0.05,
                    child: CupertinoTextField(
                      controller: _capController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      autocorrect: false,
                    ),
                  ),
                ),
                Text('*campo obbligatorio'),
                const SizedBox(height: 50,),
              ],
            ),
          ),
        );
      },
    );
  }


}
