import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/aruba/client_aruba.dart';
import 'package:vat_calculator/client/fattureICloud/client_icloud.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/aruba/aruba_home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/fatture_in_cloud_home_screen.dart';
import '../../constants.dart';
import '../../size_config.dart';

class RegisterFattureProviderScreen extends StatefulWidget {
  const RegisterFattureProviderScreen({Key key}) : super(key: key);

  static String routeName = 'fatture_registration_screen';
  @override
  State<StatefulWidget> createState() {
    return RegisterFattureProviderScreenState();
  }
}

class RegisterFattureProviderScreenState extends State<RegisterFattureProviderScreen> {
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
    return Consumer<DataBundleNotifier>(
       builder: (context, dataBundleNotifier, child) {
         return Scaffold(
           bottomSheet: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: SizedBox(
                   width: MediaQuery.of(context).size.width - 30,
                   child: CupertinoButton(
                       color: Colors.green.shade900.withOpacity(0.8),
                       child: const Text('Imposta Provider'),
                       onPressed: () async {
                         KeyboardUtil.hideKeyboard(context);
                         try{
                           if(controllerProviderName.text == 'fatture_in_cloud'){
                             var performRichiestaInfoResponse = await fattureInCloudClient.performRichiestaInfo(
                                 controllerApiUidOrPassword.text,
                                 controllerApiKeyOrUser.text);
                             if(performRichiestaInfoResponse.data.toString().contains('error')){

                               showDialog(
                                 context: context,
                                 builder: (BuildContext context) {
                                   return AlertDialog(
                                     title: const Text("Errore"),
                                     content: Text('Validazione Fallita. Messaggio di errore dal server: ' + performRichiestaInfoResponse.data.toString()),
                                     actions: <Widget>[
                                       FlatButton(
                                         child: const Text("OK"),
                                         onPressed: () {
                                           Navigator.of(context).pop();
                                         },
                                       ),
                                     ],
                                   );
                                 },
                               );
                             }else{

                               context.loaderOverlay.show();

                               BranchModel branchUpdated = BranchModel(
                                 pkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                 city: dataBundleNotifier.currentBranch.city,
                                 cap: dataBundleNotifier.currentBranch.cap,
                                 address: dataBundleNotifier.currentBranch.address,
                                 vatNumber: dataBundleNotifier.currentBranch.vatNumber,
                                 companyName: dataBundleNotifier.currentBranch.companyName,
                                 phoneNumber: dataBundleNotifier.currentBranch.phoneNumber,
                                 eMail: dataBundleNotifier.currentBranch.eMail,
                                 apiUidOrPassword: controllerApiUidOrPassword.text,
                                 apiKeyOrUser: controllerApiKeyOrUser.text,
                                 providerFatture: controllerProviderName.text);

                                Response response = await dataBundleNotifier.getclientServiceInstance().addProviderDetailsToBranch(branchModel: branchUpdated);
                                if(response.data > 0 ){
                                  dataBundleNotifier.addProviderFattureDetailsToCurrentBranch(
                                    providerFatture: controllerProviderName.text,
                                    apiKeyOrUser: controllerApiKeyOrUser.text,
                                    apiUidOrPassword: controllerApiUidOrPassword.text,
                                  );
                                  controllerProviderName.clear();
                                  controllerApiKeyOrUser.clear();
                                  controllerApiUidOrPassword.clear();

                                  context.loaderOverlay.hide();
                                  dataBundleNotifier.initializeCurrentDateTimeRangeWeekly();

                                  switch(dataBundleNotifier.currentBranch.providerFatture){
                                    case 'fatture_in_cloud':
                                      Navigator.pushNamed(context, FattureInCloudCalculatorScreen.routeName);
                                      break;
                                    case 'aruba':
                                      Navigator.pushNamed(context, ArubaCalculatorScreen.routeName);
                                      break;
                                    case '':
                                      Navigator.pushNamed(context, RegisterFattureProviderScreen.routeName);
                                      break;
                                  }
                                }else{
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Errore"),
                                        content: const Text("Impossibile salvare dettagli provider per la fatturazione elettronica"
                                            ". Provare più tardi."),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: const Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
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
                                 content: Text('Ottimo lavoro! Credenziali salvate',
                                 ),
                               );
                               ScaffoldMessenger.of(context).showSnackBar(snackBar);


                             }else{
                               showDialog(
                                 context: context,
                                 builder: (BuildContext context) {
                                   return AlertDialog(
                                     title: const Text("Errore"),
                                     content: const Text("Validazione Fallita. Credenziali errate."),
                                     actions: <Widget>[
                                       FlatButton(
                                         child: const Text("OK"),
                                         onPressed: () {
                                           Navigator.of(context).pop();
                                         },
                                       ),
                                     ],
                                   );
                                 },
                               );
                             }
                           }else{
                             showDialog(
                               context: context,
                               builder: (BuildContext context) {
                                 return AlertDialog(
                                   title: Text("Errore"),
                                   content: Text("Selezionare e configurare un provider per la fatturazione elettronica"),
                                   actions: <Widget>[
                                     FlatButton(
                                       child: new Text("OK"),
                                       onPressed: () {
                                         Navigator.of(context).pop();
                                       },
                                     ),
                                   ],
                                 );
                               },
                             );
                           }
                         }catch(e){

                           showDialog(
                             context: context,
                             builder: (BuildContext context) {
                               return AlertDialog(
                                 title: const Text("Errore"),
                                 content: Text("Impossibile salvare credenziali provider. Riprova più tardi. Errore: $e"),
                                 actions: <Widget>[
                                   FlatButton(
                                     child: const Text("OK"),
                                     onPressed: () {
                                       Navigator.of(context).pop();
                                     },
                                   ),
                                 ],
                               );
                             },
                           );
                         }
                       }),
                 ),
               ),
             ],
           ),
           appBar: AppBar(
             iconTheme: const IconThemeData(color: Colors.white),
             backgroundColor: kPrimaryColor,
             leading: GestureDetector(
               child: const Icon(Icons.arrow_back_ios),
               onTap: (){
                 Navigator.pushNamed(context, HomeScreen.routeName);
               },
             ),
             actions: [
               GestureDetector(
                 child: SvgPicture.asset(
                   'assets/icons/question-mark.svg',
                   color: kCustomWhite,
                   width: 25,
                 ),
                 onTap: (){
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
                               height: height - 550,
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
                                         color: Colors.green,
                                       ),
                                       child: Column(
                                         children: [
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Text('    Hai bisogno di aiuto?',style: TextStyle(
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
                                     Padding(
                                       padding: EdgeInsets.all(18.0),
                                       child: Text('Hai problemi con l\'autenticazione oppure il tuo provider non è fra quelli elencati? Contatta il nostro team di sviluppatori '
                                           'per qualsiasi richiesta o chiarimento.', style: TextStyle(fontSize: getProportionateScreenWidth(12)), textAlign: TextAlign.center,),
                                     ),
                                     GestureDetector(
                                       onTap: () {
                                         launch('https://api.whatsapp.com/send/?phone=+393454937047');
                                       },
                                       child: Card(
                                         elevation: 6,
                                         child: Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                                             children: [
                                               SvgPicture.asset(
                                                 'assets/icons/ws.svg',
                                                 height: 40,
                                                 width: 30,
                                               ),
                                               const Text('Contatta il supporto'),
                                               SizedBox(width: getProportionateScreenWidth(30),),
                                             ],
                                           ),
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
                 },
               ),
               const SizedBox(width: 15,),
             ],
             centerTitle: true,
             title: Column(
               children: [
                 Text(
                   'Fatturazione Elettronica',
                   style: TextStyle(
                     fontSize: getProportionateScreenWidth(13),
                     color: kCustomWhite,
                   ),
                 ),
               ],
             ),
             elevation: 0,
           ),
           body: Form(
             key: formKey,
             autovalidate: false,
             child: Padding(
               padding: const EdgeInsets.all(10.0),
               child: SingleChildScrollView(
                 scrollDirection: Axis.vertical,
                 child: Column(
                   children: <Widget>[
                     const Text('Ciao, grazie per aver registrato la tua attività. '),
                     const Text('Cosa possiamo fare adesso? Grazie all\'integrazione con alcuni dei piu famosi provider per la fatturazione elettronica, puoi, in un attimo e con un solo click, scoprire la tua situazione iva. ', textAlign: TextAlign.center,),
                     const Text('Ho solo bisogno delle tue credenziali;)', textAlign: TextAlign.center,),
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
                         if (isFattureInCloudChoiced == true && isArubaChoiced == false) TextFormField(
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
                         ) else TextFormField(
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
                       ],
                     ),
                     const SizedBox(height: 50),
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
