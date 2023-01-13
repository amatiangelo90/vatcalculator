import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            bottomSheet: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      height: getProportionateScreenHeight(60),
                      width: getProportionateScreenWidth(300),
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
                                duration: Duration(milliseconds: 800),
                                content: Text('Inserisci il cognome')));

                          }else if(phonecontroller.text == ''){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                backgroundColor: kCustomBordeaux,
                                duration: Duration(milliseconds: 800),
                                content: Text('Inserisci il cellulare')));

                          }else{
                            Response apiV1AppUsersUpdatePut = await dataBundle.getSwaggerClient().apiV1AppUsersUpdatePut(userEntity: UserEntity(
                              email: dataBundle.getUserEntity().email,
                              userId: dataBundle.getUserEntity().userId,
                              phone: phonecontroller.text,
                              name: namecontroller.text,
                              lastname: lastnamecontroller.text,
                              profileCompleted: true,
                              branchList: [],
                              photo: '',
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
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: getProportionateScreenHeight(80),
                          backgroundColor: Colors.grey.shade400,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Icon(FontAwesomeIcons.camera, color: Colors.white, size: getProportionateScreenHeight(50)),
                          ),
                        ),
                        Text(dataBundle.getUserEntity().email!, style: TextStyle(fontSize: getProportionateScreenHeight(20), color: kCustomGrey),),
                      ],
                    ),
                  ), SizedBox(height: 20,),
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
}
