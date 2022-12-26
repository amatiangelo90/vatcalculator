import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/swagger/swagger.models.swagger.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../../swagger/swagger.enums.swagger.dart';
import '../home/main_page.dart';

class CreationBranchScreen extends StatefulWidget {

  static String routeName = 'branch_creation';

  @override
  State<CreationBranchScreen> createState() => _CreationBranchScreenState();
}

class _CreationBranchScreenState extends State<CreationBranchScreen> {
  late TextEditingController controllerPIva;
  late TextEditingController controllerCompanyName;
  late TextEditingController controllerEmail;
  late TextEditingController controllerAddress;
  late TextEditingController controllerCity;
  late TextEditingController controllerCap;
  late TextEditingController controllerMobileNo;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {


    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){

        if(dataBundleNotifier.getUserEntity().email == ''){
          controllerEmail = TextEditingController();
        }else{
          controllerEmail = TextEditingController(text: dataBundleNotifier.getUserEntity().email);
        }
        void buildShowErrorDialog(String text) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.redAccent.withOpacity(0.9),
            content: Text(text),
          ));
        }

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          bottomSheet: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoButton(
                          color: kCustomGreen,
                          child: const Text('CREA'),
                          onPressed: () async {
                            if(controllerCompanyName.text == null || controllerCompanyName.text == ''){
                              print('Il nome dell\' azienda è obbligatorio');
                              buildShowErrorDialog('Il nome dell\' azienda è obbligatorio');
                            }else if(controllerEmail.text == null || controllerEmail.text == ''){
                              print('L\'indirizzo email è obbligatorio');
                              buildShowErrorDialog('L\'indirizzo email è obbligatorio');
                            }else if(controllerAddress.text == null || controllerAddress.text == ''){
                              print('Inserire indirizzo');
                              buildShowErrorDialog('Inserire indirizzo');
                            }else if(int.tryParse(controllerCap.text) == null){
                              print('Il cap è errato. Inserire un numero corretto!');
                              buildShowErrorDialog('Il cap è errato. Inserire un numero corretto');
                            }else if(controllerCap.text.characters.length != 5){
                              print('Il cap è errato. Inserire un numero corretto formato da 5 cifre.');
                              buildShowErrorDialog('Il cap è errato. Inserire un numero corretto formato da 5 cifre.');
                            }else{

                              Response apiV1AppBranchesSavePost = await dataBundleNotifier.getSwaggerClient().apiV1AppBranchesSavePost(
                                  email: controllerEmail.text,
                                  phoneNumber: controllerMobileNo.text,
                                  address: controllerAddress.text,
                                  name: controllerCompanyName.text,
                                  cap: controllerCap.text,
                                  city: controllerCity.text,
                                  vatNumber: controllerPIva.text,
                                  branchId: 0,
                                  userId: dataBundleNotifier.getUserEntity().userId!.toInt(),
                                  userPriviledge: branchUserPriviledgeToJson(BranchUserPriviledge.superAdmin),
                                  token: ''
                              );

                              if(apiV1AppBranchesSavePost.isSuccessful){
                                Response response = await dataBundleNotifier.getSwaggerClient().apiV1AppUsersFindbyemailGet(email: controllerEmail.text);
                                dataBundleNotifier.setUser(response.body);

                                print('User : ' + response.body.toString());
                                Navigator.pushNamed(context, HomeScreenMain.routeName);
                              }else{
                                buildShowErrorDialog(apiV1AppBranchesSavePost.error.toString());
                              }
                            }
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: kPrimaryColor,
              ),
            ),
            centerTitle: true,
            title: Text('Crea nuova attività',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(17),
                color: kPrimaryColor,
              ),
            ),
            backgroundColor: Colors.white,
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: const [
                          Text('Email*', style: TextStyle(color: kPrimaryColor),),
                        ],
                      ),
                      CupertinoTextField(
                        enabled: false,
                        textInputAction: TextInputAction.next,
                        restorationId: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerEmail,
                        clearButtonMode: OverlayVisibilityMode.never,
                        autocorrect: false,
                        placeholder: 'Email',
                      ),
                      Row(
                        children: const [
                          Text('Nome*', style: TextStyle(color: kPrimaryColor),),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Nome Attività',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerCompanyName,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                        placeholder: 'Nome Attività',
                      ),
                      Row(
                        children: [
                          Text('Cellulare*', style: TextStyle(color: kPrimaryColor),),
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
                          Text('Partita Iva', style: TextStyle(color: kPrimaryColor),),
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
                          Text('Indirizzo', style: TextStyle(color: kPrimaryColor),),
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
                        children: const [
                          Text('Città', style: TextStyle(color: kPrimaryColor),),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Città',
                        keyboardType: TextInputType.name,
                        controller: controllerCity,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                        placeholder: 'Città',
                      ),
                      Row(
                        children: const [
                          Text('Cap', style: TextStyle(color: kPrimaryColor),),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Cap',
                        keyboardType: TextInputType.number,
                        controller: controllerCap,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Cap',
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('*campo obbligatorio'),
                      ),
                      SizedBox(height: getProportionateScreenHeight(50),),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

  }

  @override
  void initState() {
    super.initState();
    controllerPIva = TextEditingController();
    controllerCompanyName = TextEditingController();
    controllerAddress = TextEditingController();
    controllerCity = TextEditingController();
    controllerCap = TextEditingController();
    controllerMobileNo = TextEditingController();
  }
}