import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/aruba/constant/utils_aruba.dart';
import 'package:vat_calculator/client/fattureICloud/client_icloud.dart';
import 'package:vat_calculator/client/fattureICloud/constant/utils_icloud.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/registration_company/components/recap_data.dart';
import 'package:vat_calculator/screens/registration_company/components/vatprovider.dart';
import 'package:vat_calculator/theme.dart';
import '../../../enums.dart';
import 'company_details.dart';

class CompanyRegistration extends StatefulWidget {

  @override
  _CompanyRegistrationState createState() => _CompanyRegistrationState();
}

class _CompanyRegistrationState extends State<CompanyRegistration> {
  var currentStep = 0;

  FattureInCloudClient fattureInCloudClient = FattureInCloudClient();

  @override
  Widget build(BuildContext context) {

    var mapData = HashMap<String, String>();

    mapData["piva"] = ContactState.controllerPIva.text;
    mapData["email"] = ContactState.controllerEmail.text;
    mapData["address"] = ContactState.controllerAddress.text;
    mapData["company_name"] = ContactState.controllerCompanyName.text;
    mapData["mobile_no"] = ContactState.controllerMobileNo.text;

    mapData["provider_name"] = VatProviderState.controllerProviderName.text;
    mapData["apikey_or_user"] = VatProviderState.controllerApiKeyOrUser.text;
    mapData["apiuid_or_password"] = VatProviderState.controllerApiUidOrPassword.text;


    List<Step> steps = [
      Step(
        title: const Text('Dettagli Attività'),
        content: const Contact(),
        state: currentStep == 0 ? StepState.editing : StepState.indexed,
        isActive: true,
      ),
      Step(
        title: const Text('Provider Fatturazione Elettronica'),
        content: const VatProvider(),
        state: currentStep == 1 ? StepState.editing : StepState.indexed,
        isActive: true,
      ),
      Step(
        title: const Text('Abbiamo finito! Conferma i tuoi dati'),
        content: RecapData(mapData),
        state: StepState.complete,
        isActive: true,
      ),
    ];

    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return SafeArea(
          child : SingleChildScrollView(
            child: Theme(
              data: themeStepper(),
              child: Stepper(
                currentStep: currentStep,
                steps: steps,
                type: StepperType.vertical,
                onStepTapped: (step) {
                  setState(() {
                    currentStep = step;
                  });
                },
                onStepContinue: () {
                  setState(() {
                    if (currentStep < steps.length - 1) {
                      if (currentStep == 0) {
                        currentStep = currentStep + 1;
                      } else {
                        if (currentStep == 1) {
                          currentStep = currentStep + 1;
                        }
                      }
                    } else {
                      saveCompanyData(mapData, dataBundleNotifier);
                    }
                  });
                },
                onStepCancel: () {
                  setState(() {
                    if (currentStep > 0) {
                      currentStep = currentStep - 1;
                    } else {
                      currentStep = 0;
                    }
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> validateCredentials(mapData) async {

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

  Future<void> saveCompanyData(mapData, DataBundleNotifier dataBundleNotifier) async {
    print(mapData.toString());
    print(dataBundleNotifier.dataBundleList[0].email);
    bool resultValidation = await validateData(mapData);
    if(resultValidation){
      // TODO salvare dati azienda

    }
  }

  Future<bool> validateData(mapData) async {
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
    }else if(mapData['email'] == null || mapData['email'] == ''){
      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text('Inserire la mail'),
      ));
      return false;
    }else if(mapData['apiuid_or_password'] == null || mapData['apiuid_or_password'] == ''){
      if(mapData['provider_name'] == ProviderFattureElettroniche.fattureInCloud.toString()){
        Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text('Inserire ApiUid per il provider FattureInCloud'),
        ));
        return false;
      }else if(mapData['provider_name'] == ProviderFattureElettroniche.aruba.toString()){
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
      if(mapData['provider_name'] == ProviderFattureElettroniche.fattureInCloud.toString()){
        Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text('Inserire ApiKey per il provider FattureInCloud'),
        ));
        return false;
      }else if(mapData['provider_name'] == ProviderFattureElettroniche.aruba.toString()){
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

    if(mapData['provider_name'] == 'ProviderFattureElettroniche.fattureInCloud'){
      print('validate');
      bool result = await validateCredentials(mapData);
      if(result){
        return true;
      }else{
        return false;
      }
    }else if (mapData['provider_name'] == 'ProviderFattureElettroniche.aruba'){
      // TODO VALIDATE CREDENTIAL ARUBA AND SAVE IT
      if(true){
        return true;
      }else{
        return false;
      }
    }
  }
}