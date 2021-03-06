import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../main_page.dart';

class CreationBranchScreen extends StatefulWidget {

  static String routeName = 'branch_creation';

  @override
  State<CreationBranchScreen> createState() => _CreationBranchScreenState();
}

class _CreationBranchScreenState extends State<CreationBranchScreen> {
  TextEditingController controllerPIva;
  TextEditingController controllerCompanyName;
  TextEditingController controllerEmail;
  TextEditingController controllerAddress;
  TextEditingController controllerCity;
  TextEditingController controllerCap;
  TextEditingController controllerMobileNo;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {


    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){

        if(dataBundleNotifier.userDetailsList.isEmpty){
          controllerEmail = TextEditingController();
        }else{
          controllerEmail = TextEditingController(text: dataBundleNotifier.userDetailsList[0].email);
        }

        void buildShowErrorDialog(String text) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.redAccent.withOpacity(0.9),
            content: Text(text),
          ));
        }

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: kPrimaryColor,
          bottomSheet: Container(
            color: kPrimaryColor,
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
                          color: kCustomGreenAccent,
                          child: const Text('CREA'),
                          onPressed: () async {
                            if(controllerCompanyName.text == null || controllerCompanyName.text == ''){
                              print('Il nome dell\' azienda ?? obbligatorio');
                              buildShowErrorDialog('Il nome dell\' azienda ?? obbligatorio');
                            }else if(controllerEmail.text == null || controllerEmail.text == ''){
                              print('L\'indirizzo email ?? obbligatorio');
                              buildShowErrorDialog('L\'indirizzo email ?? obbligatorio');
                            }else if(controllerAddress.text == null || controllerAddress.text == ''){
                              print('Inserire indirizzo');
                              buildShowErrorDialog('Inserire indirizzo');
                            }else if(int.tryParse(controllerCap.text) == null){
                              print('Il cap ?? errato. Inserire un numero corretto!');
                              buildShowErrorDialog('Il cap ?? errato. Inserire un numero corretto');
                            }else if(controllerCap.text.characters.length != 5){
                              print('Il cap ?? errato. Inserire un numero corretto formato da 5 cifre.');
                              buildShowErrorDialog('Il cap ?? errato. Inserire un numero corretto formato da 5 cifre.');
                            }else{
                              BranchModel company = BranchModel(
                                  eMail: controllerEmail.text,
                                  phoneNumber: controllerMobileNo.text,
                                  address: controllerAddress.text,
                                  apiKeyOrUser: '',
                                  apiUidOrPassword: '',
                                  companyName: controllerCompanyName.text,
                                  cap: int.parse(controllerCap.text),
                                  city: controllerCity.text,
                                  providerFatture: '',
                                  vatNumber: controllerPIva.text,
                                  pkBranchId: 0,
                                  accessPrivilege: Privileges.OWNER
                              );

                              ClientVatService clientService = dataBundleNotifier.getclientServiceInstance();
                              ActionModel actionModel =
                              ActionModel(
                                  user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                  description: 'Ha creato l\'attivit?? ${controllerCompanyName.text}',
                                  type: ActionType.BRANCH_CREATION,
                                  date: DateTime.now().millisecondsSinceEpoch,
                                  fkBranchId: 0);
                              await clientService.performSaveBranch(company, actionModel);

                              List<BranchModel> _branchList = await clientService.retrieveBranchesByUserId(dataBundleNotifier.userDetailsList[0].id);
                              dataBundleNotifier.addBranches(_branchList);


                              dataBundleNotifier.onItemTapped(0);
                              Navigator.pushNamed(context, HomeScreenMain.routeName);
                            }

                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            elevation: 5,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            title: Text('Crea nuova attivit??',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(17),
                color: Colors.white,
              ),
            ),
            backgroundColor: kPrimaryColor,
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
                          Text('Email*', style: TextStyle(color: kCustomWhite),),
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
                          Text('Nome*', style: TextStyle(color: kCustomWhite),),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Nome Attivit??',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerCompanyName,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                        placeholder: 'Nome Attivit??',
                      ),
                      Row(
                        children: [
                          Text('Cellulare*', style: TextStyle(color: kCustomWhite),),
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
                          Text('Partita Iva', style: TextStyle(color: kCustomWhite),),
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
                          Text('Indirizzo', style: TextStyle(color: kCustomWhite),),
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
                          Text('Citt??', style: TextStyle(color: kCustomWhite),),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Citt??',
                        keyboardType: TextInputType.name,
                        controller: controllerCity,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                        placeholder: 'Citt??',
                      ),
                      Row(
                        children: const [
                          Text('Cap', style: TextStyle(color: kCustomWhite),),
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