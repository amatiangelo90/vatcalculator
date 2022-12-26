import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.models.swagger.dart';

class AddStorageScreen extends StatelessWidget {
  const AddStorageScreen({Key? key,required this.branch}) : super(key: key);

  final Branch branch;
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


    void buildSnackBar({required String text, required Color color}) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
          backgroundColor: color,
          duration: const Duration(milliseconds: 800),
          content: Text(text)));
    }

    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Scaffold(
          backgroundColor: Colors.white,
          bottomSheet: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    child: DefaultButton(
                    color: kCustomGreen,
                    text: 'Crea Magazzino',
                    press: () async {
                      if(_nameController.text.isEmpty || _nameController.text == ''){
                        buildSnackBar(text: 'Inserire il nome del magazzino', color: kPinaColor);
                      }else if(_addressController.text.isEmpty || _addressController.text == ''){
                        buildSnackBar(text: 'Inserire l\'indirizzo', color: kPinaColor);
                      }else if(_cityController.text.isEmpty || _cityController.text == ''){
                        buildSnackBar(text: 'Inserire la città', color: kPinaColor);
                      }else if(_capController.text.isEmpty || _capController.text == ''){
                        buildSnackBar(text: 'Inserire il cap', color: kPinaColor);
                      }else{

                        Response apiV1AppStorageSavePost = await dataBundleNotifier.getSwaggerClient().apiV1AppStorageSavePost(
                          name: _nameController.text,
                          branchId: branch.branchId!.toInt(),
                          address: _addressController.text,
                          cap: _capController.text,
                          city: _cityController.text,
                        );

                        if(apiV1AppStorageSavePost.isSuccessful){
                          buildSnackBar(text: 'Magazzino creato con successo', color: Colors.green);
                          dataBundleNotifier.getCurrentBranch().storages!.add(apiV1AppStorageSavePost.body);
                        }else{
                          buildSnackBar(text: 'Errore. ' + apiV1AppStorageSavePost.error.toString(), color: kPinaColor);
                        }
                        Navigator.pop(context);
                      }

                    }, textColor: Colors.white,),
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: kPrimaryColor,),
                onPressed: () => {
                  Navigator.of(context).pop(),
                }
            ),
            centerTitle: true,
            title: Text('Crea Magazzino',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(17),
                color: kPrimaryColor,
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Row(
                  children: [
                    const SizedBox(width: 11,),
                    Text('   Nome*', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12), fontWeight: FontWeight.bold)),
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
                const SizedBox(height: 10,),
                Row(
                  children: [
                    const SizedBox(width: 11,),
                    Text('   Indirizzo*', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12), fontWeight: FontWeight.bold)),
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
                const SizedBox(height: 10,),
                Row(
                  children: [
                    const SizedBox(width: 11,),
                    Text('   Città*', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12), fontWeight: FontWeight.bold)),
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
                const SizedBox(height: 10,),
                Row(
                  children: [
                    const SizedBox(width: 11,),
                    Text('   Cap*', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12), fontWeight: FontWeight.bold)),
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('*campo obbligatorio'),
                ),
                const SizedBox(height: 50,),
              ],
            ),
          ),
        );
      },
    );
  }


}
