import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/aruba/client_aruba.dart';
import 'package:vat_calculator/client/fattureICloud/client_icloud.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/user_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/registration_company/components/fatture_provider_registration.dart';
import 'package:vat_calculator/theme.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class CompanyRegistration extends StatefulWidget {

  static String routeName = 'companyregistration';
  @override
  _CompanyRegistrationState createState() => _CompanyRegistrationState();
}

class _CompanyRegistrationState extends State<CompanyRegistration> {
  var currentStep = 0;

  FattureInCloudClient fattureInCloudClient = FattureInCloudClient();
  ArubaClient arubaClient = ArubaClient();

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
                            pkBranchId: 0
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
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              autovalidate: false,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
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
        );
      },
    );
  }

  Future<bool> validateCredentialsFattureInCloud(mapData) async {

    var performRichiestaInfoResponse = await fattureInCloudClient.performRichiestaInfo(
        mapData['apiuid_or_password'],
        mapData['apikey_or_user']);

    if(performRichiestaInfoResponse.data.toString().contains('error')){
      final snackBar =
      SnackBar(
          duration: const Duration(seconds: 7),
          backgroundColor: Colors.red,
          content: Text('Impossibile salvare i dati. Dati non corretti per l\'integrazione con ' + mapData['provider_name'] + '. Error: ' + performRichiestaInfoResponse.data.toString(),
          )
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }else {
      return true;
    }
  }

  Future<bool> validateCredentialsAruba(mapData) async {
    Response performAuthAruba = await arubaClient.performVerifyCredentials(
        mapData['apiuid_or_password'],
        mapData['apikey_or_user']);

    if(performAuthAruba.statusCode == 200){
      return true;
    }else{
      final snackBar =
      SnackBar(
          duration: const Duration(seconds: 7),
          backgroundColor: Colors.red,
          content: Text('Impossibile salvare i dati. Dati non corretti per l\'integrazione con ' + mapData['provider_name'] + '. Error: ' + performAuthAruba.data.toString(),
          )
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }

  Future<void> saveCompanyData(mapData, DataBundleNotifier dataBundleNotifier, context) async {
    bool resultValidation = await validateData(mapData, context);


    if(resultValidation){



      print('Saving the following company to database: ');



      RegisterFattureProviderScreenState.controllerApiKeyOrUser.clear();
      RegisterFattureProviderScreenState.controllerApiUidOrPassword.clear();


    }
  }

  Future<bool> validateData(mapData, context) async {

    if(mapData['company_name'] == null || mapData['company_name'] == ''){
      Scaffold.of(context).showSnackBar(const SnackBar(
               content: Text('Nome azienda vuoto'),
             ));
      return false;

    }else if(mapData['provider_name'] == null || mapData['provider_name'] == ''){
      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text('Selezionare un provider per la fatturazione elettronica'),
      ));
      return false;
    }else if(mapData['apiuid_or_password'] == null || mapData['apiuid_or_password'] == ''){

      if(mapData['provider_name'] == 'fatture_in_cloud'){
        Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text('Inserire ApiUid per il provider FattureInCloud'),
        ));
        return false;

      } else if(mapData['provider_name'] == 'aruba'){
        Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text('Inserire la password per il provider Aruba'),
        ));
        return false;
      }
    }else if(mapData['piva'] == null || mapData['piva'] == ''){
      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text('Inserire la partita Iva'),
      ));
      return false;
    }else if(mapData['apikey_or_user'] == null || mapData['apikey_or_user'] == ''){

      if(mapData['provider_name'] == 'fatture_in_cloud'){
        Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text('Inserire ApiKey per il provider FattureInCloud'),
        ));
        return false;
      }else if(mapData['provider_name'] == 'aruba'){
        Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text('Inserire utenza per il provider Aruba'),
        ));
        return false;
      }

    }else if(mapData['mobile_no'] == null || mapData['mobile_no'] == ''){

      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text('Inserire il recapito dell\'azienda'),
      ));
      return false;
    }else if(mapData['address'] == null || mapData['address'] == ''){
      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text('Inserire l\'indirizzo'),
      ));
      return false;
    }

    if(mapData['provider_name'] == 'fatture_in_cloud'){
      bool result = await validateCredentialsFattureInCloud(mapData);
      if(result){
        return true;
      }else{
        return false;
      }
    }else if (mapData['provider_name'] == 'aruba'){

      bool result = await validateCredentialsAruba(mapData);
      if(result){
        return true;
      }else{
        return false;
      }
    }
  }

}