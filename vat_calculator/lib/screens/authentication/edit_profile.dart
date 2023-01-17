import 'dart:io';
import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/main_page.dart';
import 'package:vat_calculator/swagger/swagger.enums.swagger.dart';
import 'package:vat_calculator/swagger/swagger.models.swagger.dart';
import '../../size_config.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  static String routeName = 'edit_profile_screen';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {



    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundle, _){
        
        TextEditingController phonecontroller = TextEditingController(text: dataBundle.getUserEntity().phone ?? '');
        TextEditingController namecontroller = TextEditingController(text: dataBundle.getUserEntity().name ?? '');
        TextEditingController lastnamecontroller = TextEditingController(text: dataBundle.getUserEntity().lastname ?? '');

        return GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            bottomSheet: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(50),
                    width: getProportionateScreenWidth(350),
                    child: OutlinedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.resolveWith((states) => 5),
                        backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
                        side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey),),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                      ), onPressed: () async {

                        if(namecontroller.text == ''){
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              backgroundColor: kCustomBordeaux,
                              duration: Duration(milliseconds: 800),
                              content: Text('Inserisci il nome')));

                        }else if(lastnamecontroller.text == ''){
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              backgroundColor:kCustomBordeaux,
                              duration: Duration(milliseconds: 1800),
                              content: Text('Inserisci il cognome')));

                        }else if(phonecontroller.text == ''){
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              backgroundColor: kCustomBordeaux,
                              duration: Duration(milliseconds: 1800),
                              content: Text('Inserisci il cellulare')));

                        }else{

                          print('image url: ' + imageUrl);
                          Response apiV1AppUsersUpdatePut = await dataBundle.getSwaggerClient().apiV1AppUsersUpdatePut(userEntity: UserEntity(
                            email: dataBundle.getUserEntity().email,
                            userId: dataBundle.getUserEntity().userId,
                            phone: phonecontroller.text,
                            name: namecontroller.text,
                            lastname: lastnamecontroller.text,
                            profileCompleted: true,
                            branchList: [],
                            photo: dataBundle.getUserEntity().photo,
                            userType: UserEntityUserType.entrepreneur
                          ));
                          if(apiV1AppUsersUpdatePut.isSuccessful){

                            dataBundle.updateProfile(namecontroller.text, lastnamecontroller.text, phonecontroller.text, true);
                            Navigator.pushNamed(context, HomeScreenMain.routeName);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                backgroundColor: kCustomGreen,
                                duration: Duration(milliseconds: 800),
                                content: Text('Profilo aggiornato')));
                          }else{
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                backgroundColor: kCustomBordeaux,
                                duration: Duration(milliseconds: 2800),
                                content: Text('Errore durante l\'oprerazione. Err. ' + apiV1AppUsersUpdatePut.error!.toString() )));
                          }
                        }
                    }, child: Text('Aggiorna Profilo', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(15))),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              title: const Text('Gestione profilo', style: TextStyle(color: kCustomGrey)),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            _getFromCamera(dataBundle);
                          },
                          child: CircleAvatar(
                            radius: getProportionateScreenHeight(80),
                            backgroundColor: Colors.grey.shade400,
                            backgroundImage: Image.network(dataBundle.getUserEntity().photo == null
                                ? '' : dataBundle.getUserEntity().photo!, fit: BoxFit.fill).image,
                          ),
                        ),
                        IconButton(onPressed: (){
                            _getFromCamera(dataBundle);
                          }, icon: Icon(FontAwesomeIcons.camera, color: kCustomGrey, size: getProportionateScreenHeight(20)),),
                        Text(dataBundle.getUserEntity().email!, style: TextStyle(fontSize: getProportionateScreenHeight(20), color: kCustomGrey),),
                      ],
                    ),
                  ), const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      textInputAction: TextInputAction.newline,
                      restorationId: 'Nome',
                      keyboardType: TextInputType.text,
                      controller: namecontroller,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      placeholder: 'Nome',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      textInputAction: TextInputAction.newline,
                      restorationId: 'Cognome',
                      keyboardType: TextInputType.text,
                      controller: lastnamecontroller,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      placeholder: 'Cognome',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      textInputAction: TextInputAction.newline,
                      restorationId: 'Cellulare',
                      keyboardType: TextInputType.number,
                      controller: phonecontroller,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      placeholder: 'Cellulare',
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  _getFromCamera(DataBundleNotifier dataBundle) async {
    XFile? xFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (xFile != null) {

      Reference reference = FirebaseStorage.instance.ref();
      Reference referenceDirImage = reference.child('images');
      Reference referenceImageToUpload = referenceDirImage.child(dataBundle.getUserEntity().userId.toString());
      await referenceImageToUpload.putFile(File(xFile.path));

      String imageUrlRetrieved = await referenceImageToUpload.getDownloadURL();

      dataBundle.setImagePhotoUrlToCurrentProfile(imageUrlRetrieved);



    }
  }

}
