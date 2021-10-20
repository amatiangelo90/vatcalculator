import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/client/aruba/client_aruba.dart';
import 'package:vat_calculator/client/aruba/constant/utils_aruba.dart';
import 'package:vat_calculator/client/fattureICloud/client_icloud.dart';
import 'package:vat_calculator/client/fattureICloud/constant/utils_icloud.dart';

import '../../../constants.dart';
import '../../../enums.dart';
import '../../../size_config.dart';

class VatProvider extends StatefulWidget {
  const VatProvider({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VatProviderState();
  }
}

class VatProviderState extends State<VatProvider> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static bool isFattureInCloudChoiced = false;
  static bool isArubaChoiced = false;

  static TextEditingController controllerProviderName = TextEditingController();

  static TextEditingController controllerApiKeyOrUser = TextEditingController();
  static TextEditingController controllerApiUidOrPassword = TextEditingController();

  FattureInCloudClient fattureInCloudClient = FattureInCloudClient();
  ArubaClient arubaClient = ArubaClient();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidate: false,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState((){
                      isFattureInCloudChoiced = true;
                      isArubaChoiced = false;
                      controllerApiKeyOrUser.clear();
                      controllerApiUidOrPassword.clear();
                      controllerProviderName.text = 'fatture_in_cloud';
                    });
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width / 4,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      color: isFattureInCloudChoiced ? Colors.blueAccent : Colors.grey,
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.asset(
                        'assets/images/fattureincloud.png',
                        fit: BoxFit.contain,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState((){
                      isFattureInCloudChoiced = false;
                      isArubaChoiced = true;
                      controllerApiKeyOrUser.clear();
                      controllerApiUidOrPassword.clear();
                      controllerProviderName.text = 'aruba';
                    });
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width / 4,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      color: isArubaChoiced ? Colors.orange : Colors.grey,
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.asset(
                        'assets/images/aruba.png',
                        fit: BoxFit.contain,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (isFattureInCloudChoiced == false && isArubaChoiced == false) SizedBox() else Column(
            children: [
              (isFattureInCloudChoiced == true && isArubaChoiced == false) ? Row(
                children: [
                  GestureDetector(
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "  ",
                          ),
                          WidgetSpan(
                            child: Icon(Icons.info_outlined, size: 19, color: Colors.blueAccent,),
                          ),
                          TextSpan(
                              text: " ApiKey e ApiUid? Come fare per ottenerli?",
                              style: TextStyle(color: Colors.black, fontSize: 12)
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
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
                                  height: height - 250,
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
                                            color: Colors.blue,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('  ApiKey e ApiUid?',style: TextStyle(
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
                                        const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Text('L\' ApiKey e l\'ApiUid sono una coppia di parametri che servono per integrare '
                                              'la presente applicazione con il tuo provider per la gestione delle fatture elettroniche. \n\nTutto ciò di cui hai '
                                              'bisogno sono le tue credenziali FattureInCloud, accedere al servizio e recuperare i dati nella sezione dedicata.\n\n'
                                              ''
                                              'https://secure.fattureincloud.it/help/articolo/309-integrazioni-ecommerce', style: TextStyle(fontSize: 14),),
                                        ),

                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                      );
                    },
                  ),
                ],
              ) : const SizedBox(),
              const SizedBox(height: 10),
              (isFattureInCloudChoiced == true && isArubaChoiced == false) ? TextFormField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.vpn_key_outlined,
                      color: Colors.grey,
                    ),
                    hintText: 'Api Key',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return "ApiKey è un campo obbligatorio";
                    }
                  },
                  controller: controllerApiKeyOrUser
              ) : TextFormField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    hintText: 'User Aruba',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return "L'utenza Aruba è un campo obbligatorio";
                    }
                  },
                  controller: controllerApiKeyOrUser
              ),
              const SizedBox(height: 20),
              (isFattureInCloudChoiced == true && isArubaChoiced == false) ? TextFormField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.keyboard_rounded,
                      color: Colors.grey,
                    ),
                    hintText: 'Api Uid',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return "ApiUid è un campo obbligatorio";
                    }
                  },
                  controller: controllerApiUidOrPassword
              ) : TextFormField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.password,
                      color: Colors.grey,
                    ),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return "Immettere la password per l'account Aruba";
                    }else{
                    }
                  },
                  controller: controllerApiUidOrPassword
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: ()  async {

                      if(controllerProviderName.text == 'fatture_in_cloud'){
                        var performRichiestaInfoResponse = await fattureInCloudClient.performRichiestaInfo(
                            controllerApiUidOrPassword.text,
                            controllerApiKeyOrUser.text);
                        if(performRichiestaInfoResponse.data.toString().contains('error')){
                          final snackBar =
                          SnackBar(
                              duration: Duration(seconds: 5),
                              backgroundColor: Colors.red,
                              content: Text('Validazione Fallita. Messaggio di errore dal server: ' + performRichiestaInfoResponse.data.toString(),
                              )
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }else{
                          const snackBar =
                          SnackBar(
                            duration: Duration(seconds: 5),
                            backgroundColor: Colors.green,
                            content: Text('Credenziali Valide!',
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }else if (controllerProviderName.text == 'aruba'){

                        Response performAuthAruba = await arubaClient.performVerifyCredentials(
                            controllerApiUidOrPassword.text,
                            controllerApiKeyOrUser.text);

                        if(performAuthAruba.statusCode == 200){
                          const snackBar =
                          SnackBar(
                            duration: Duration(seconds: 5),
                            backgroundColor: Colors.green,
                            content: Text('Credenziali Valide!',
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }else{
                          const snackBar =
                          SnackBar(
                              duration: Duration(seconds: 5),
                              backgroundColor: Colors.red,
                              content: Text('Validazione Fallita. Credenziali errate ',
                              )
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }else{
                        const snackBar = SnackBar(
                          duration: Duration(seconds: 5),
                          backgroundColor: Colors.red,
                          content: Text('Selezionare e configurare un provider per la fatturazione elettronica',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      },
                    child: const Text('Verifica Credenziali'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

}
