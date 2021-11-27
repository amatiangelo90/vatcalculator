import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import '../../constants.dart';
import '../../size_config.dart';

class BranchCreationScreen extends StatelessWidget {

  static String routeName = 'branch_creation';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        GlobalKey key = GlobalKey();

        TextEditingController controllerPIva = TextEditingController();
        TextEditingController controllerCompanyName = TextEditingController();
        TextEditingController controllerEmail;
        if(dataBundleNotifier.dataBundleList.isEmpty){
          controllerEmail = TextEditingController();
        }else{
          controllerEmail = TextEditingController(text: dataBundleNotifier.dataBundleList[0].email);
        }
        TextEditingController controllerAddress = TextEditingController();
        TextEditingController controllerCity = TextEditingController();
        TextEditingController controllerCap = TextEditingController();
        TextEditingController controllerMobileNo = TextEditingController();

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
                                padding: EdgeInsets.all(18.0),
                                child: Text(text,
                                  style: TextStyle(fontSize: 14),
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
          key: key,
          bottomSheet: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: CupertinoButton(
                      color: Colors.green.shade500,
                      child: const Text('Crea Attività'),
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


                          ActionModel actionModel = ActionModel(user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                              description: 'Ha creato l\'attività ${controllerCompanyName.text}',
                              date: DateTime.now().millisecondsSinceEpoch,
                              fkBranchId: 0);
                          await clientService.performSaveBranch(company, actionModel);

                          List<BranchModel> _branchList = await clientService.retrieveBranchesByUserId(dataBundleNotifier.dataBundleList[0].id);
                          dataBundleNotifier.addBranches(_branchList);

                          Navigator.pushNamed(context, HomeScreen.routeName);
                        }

                      }),
                ),
              ),
            ],
          ),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            title: Text('Registra la tua attività',
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
                          Text('Email*'),
                        ],
                      ),
                      CupertinoTextField(
                        enabled: false,
                        textInputAction: TextInputAction.next,
                        restorationId: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerEmail,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                        placeholder: 'Email',
                      ),
                      Row(
                        children: const [
                          Text('Nome*'),
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
          ),
        );
      },
    );

  }
}