import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../main_page.dart';

class UpdateBranchScreen extends StatefulWidget {

  static String routeName = 'branch_update';

  @override
  State<UpdateBranchScreen> createState() => _UpdateBranchScreenState();
}

class _UpdateBranchScreenState extends State<UpdateBranchScreen> {

  @override
  Widget build(BuildContext context) {


    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){

        TextEditingController controllerPIva2 = TextEditingController(text: dataBundleNotifier.currentBranch.vatNumber.toString());
        TextEditingController controllerCompanyName2 = TextEditingController(text: dataBundleNotifier.currentBranch.companyName);
        TextEditingController controllerAddress2 = TextEditingController(text: dataBundleNotifier.currentBranch.address);
        TextEditingController controllerCity2 = TextEditingController(text: dataBundleNotifier.currentBranch.city);
        TextEditingController controllerCap2 = TextEditingController(text: dataBundleNotifier.currentBranch.cap.toString());
        TextEditingController controllerMobileNo2 = TextEditingController(text: dataBundleNotifier.currentBranch.phoneNumber);
        TextEditingController controllerEmail2;

        if(dataBundleNotifier.userDetailsList.isEmpty){
          controllerEmail2 = TextEditingController();
        }else{
          controllerEmail2 = TextEditingController(text: dataBundleNotifier.userDetailsList[0].email);
        }

        void buildShowErrorDialog(String text) {
          Widget cancelButton = TextButton(
            child: const Text("Indietro", style: TextStyle(color: kPrimaryColor),),
            onPressed:  () {
              Navigator.of(context).pop();
            },
          );

          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                actions: [
                  cancelButton
                ],
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
                      height: getProportionateScreenHeight(150),
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
                                color: kPinaColor,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('  Errore ',style: TextStyle(
                                        fontSize: getProportionateScreenWidth(14),
                                        fontWeight: FontWeight.bold,
                                        color: kCustomWhite,
                                      ),),
                                      IconButton(icon: const Icon(
                                        Icons.clear,
                                        color: kCustomWhite,
                                      ), onPressed: () { Navigator.pop(context); },),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(text,
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
          );
        }

        return Scaffold(
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
                          child: const Text('AGGIORNA'),
                          onPressed: () async {
                            if(controllerCompanyName2.text == null || controllerCompanyName2.text == ''){
                              print('Il nome dell\' azienda è obbligatorio');
                              buildShowErrorDialog('Il nome dell\' azienda è obbligatorio');

                            }else if(controllerEmail2.text == null || controllerEmail2.text == ''){
                              print('L\'indirizzo email è obbligatorio');
                              buildShowErrorDialog('L\'indirizzo email è obbligatorio');
                            }else if(controllerAddress2.text == null || controllerAddress2.text == ''){
                              print('Inserire indirizzo');
                              buildShowErrorDialog('Inserire indirizzo');
                            }else if(int.tryParse(controllerCap2.text) == null){
                              print('Il cap è errato. Inserire un numero corretto!');
                              buildShowErrorDialog('Il cap è errato. Inserire un numero corretto');
                            }else if(controllerCap2.text.characters.length != 5){
                              print('Il cap è errato. Inserire un numero corretto formato da 5 cifre.');
                              buildShowErrorDialog('Il cap è errato. Inserire un numero corretto formato da 5 cifre.');
                            }else{
                              BranchModel company = BranchModel(
                                  eMail: controllerEmail2.text,
                                  phoneNumber: controllerMobileNo2.text,
                                  address: controllerAddress2.text,
                                  apiKeyOrUser: '',
                                  apiUidOrPassword: '',
                                  companyName: controllerCompanyName2.text,
                                  cap: int.parse(controllerCap2.text),
                                  city: controllerCity2.text,
                                  providerFatture: '',
                                  vatNumber: controllerPIva2.text,
                                  pkBranchId: 0,
                                  accessPrivilege: Privileges.OWNER, token: ''
                              );

                              await dataBundleNotifier.getclientServiceInstance().performUpdateBranch(company);
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
            title: Text('Aggiorna dettagli attività',
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
                        controller: controllerEmail2,
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
                        restorationId: 'Nome Attività',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerCompanyName2,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        onChanged: (text) {},
                        placeholder: 'Nome Attività',
                      ),
                      Row(
                        children: const [
                          Text('Cellulare*', style: TextStyle(color: kCustomWhite),),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Cellulare',
                        keyboardType: TextInputType.number,
                        controller: controllerMobileNo2,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        onChanged: (text) {},
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
                        controller: controllerPIva2,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        onChanged: (text) {},
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
                        controller: controllerAddress2,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        onChanged: (text) {},
                        placeholder: 'Indirizzo',
                      ),
                      Row(
                        children: const [
                          Text('Città', style: TextStyle(color: kCustomWhite),),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Città',
                        keyboardType: TextInputType.name,
                        controller: controllerCity2,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        onChanged: (text) {},
                        placeholder: 'Città',
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
                        controller: controllerCap2,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        onChanged: (text) {},
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
}