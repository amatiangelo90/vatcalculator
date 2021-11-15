import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
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

        return Scaffold(
          key: key,
          bottomSheet: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoButton(
                    color: kPrimaryColor,
                    child: const Text('Salva Azienda'),
                    onPressed: () async {
                      if(controllerCompanyName.text == null || controllerCompanyName.text == ''){
                        print('Il nome dell\' azienda è obbligatorio');
                        CoolAlert.show(
                          onConfirmBtnTap: (){},
                          confirmBtnColor: kPinaColor,
                          backgroundColor: kPinaColor,
                          context: context,
                          title: 'Errore',
                          type: CoolAlertType.error,
                          text: 'Il nome dell\' azienda è obbligatorio',
                          autoCloseDuration: Duration(seconds: 2),
                          onCancelBtnTap: (){},
                        );

                      }else if(controllerEmail.text == null || controllerEmail.text == ''){
                        print('L\'indirizzo email è obbligatorio');
                        CoolAlert.show(
                            backgroundColor: kPinaColor,
                            context: context,
                            title: 'Errore',
                            type: CoolAlertType.error,
                            text: 'L\'indirizzo email è obbligatorio',
                            autoCloseDuration: Duration(seconds: 3),
                            onCancelBtnTap: (){}
                        );
                      }else if(controllerAddress.text == null || controllerAddress.text == ''){
                        print('Inserire indirizzo');
                        CoolAlert.show(
                            backgroundColor: kPinaColor,
                            context: context,
                            title: 'Errore',
                            type: CoolAlertType.error,
                            text: 'Indirizzo mancante',
                            autoCloseDuration: Duration(seconds: 3),
                            onCancelBtnTap: (){}
                        );
                      }else if(int.tryParse(controllerCap.text) == null){
                        print('Il cap è errato. Inserire un numero corretto!');
                        CoolAlert.show(
                            backgroundColor: kPinaColor,
                            context: context,
                            title: 'Errore',
                            type: CoolAlertType.error,
                            text: 'Il cap è errato. Inserire un numero corretto',
                            autoCloseDuration: Duration(seconds: 3),
                            onCancelBtnTap: (){}
                        );
                      }else if(controllerCap.text.characters.length != 5){
                        print('Il cap è errato. Inserire un numero corretto formato da 5 cifre.');
                        CoolAlert.show(
                            backgroundColor: kPinaColor,
                            context: context,
                            title: 'Errore',
                            type: CoolAlertType.error,
                            text: 'Il cap è errato. Inserire un numero corretto',
                            autoCloseDuration: Duration(seconds: 3),
                            onCancelBtnTap: (){}
                        );
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
                            accessPrivilege: Privileges.SUPER_ADMIN
                        );

                        ClientVatService clientService = dataBundleNotifier.getclientServiceInstance();
                        await clientService.performSaveBranch(company);

                        List<BranchModel> _branchList = await clientService.retrieveBranchesByUserId(dataBundleNotifier.dataBundleList[0].id);
                        dataBundleNotifier.addBranches(_branchList);

                        Navigator.pushNamed(context, HomeScreen.routeName);
                      }

                    }),
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
                autovalidate: false,
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
        );
      },
    );

  }
}