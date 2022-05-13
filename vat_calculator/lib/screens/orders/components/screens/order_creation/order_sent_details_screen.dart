import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/screens/main_page.dart';
import 'package:vat_calculator/screens/orders/components/screens/orders_utils.dart';
import 'package:vat_calculator/size_config.dart';

import '../../../../../client/fattureICloud/model/response_fornitori.dart';
import '../../../../home/home_screen.dart';

class OrderSentDetailsScreen extends StatelessWidget {
  const OrderSentDetailsScreen({Key key, this.message, this.number, this.mail, this.supplierName}) : super(key: key);

  final String message;
  final String number;
  final String mail;
  final String supplierName;

  @override
  Widget build(BuildContext context) {

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  width: getProportionateScreenWidth(400),

                  child: Card(color: Colors.green,child:
                  Center(child:
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text('Ordine inviato correttamente al fornitore [$supplierName] tramite \nemail [$mail]', overflow: TextOverflow.visible, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(18),
                    ),),
                  ),),),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Desideri inoltrare l\'ordine tramite sms o messaggio what\'s app al tuo fornitore?' , textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: getProportionateScreenWidth(500),
                    padding: const EdgeInsets.all(5.0),
                    height: getProportionateScreenHeight(300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: kPrimaryColor,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        message.replaceAll('%0a', '\n'),
                        style: TextStyle(color: kCustomWhite),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('-- inoltra tramite --' , textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              GestureDetector(
                onTap: () async {
                  String messageToSend = message;

                  messageToSend = messageToSend.replaceAll('&', '%26');
                  messageToSend = messageToSend.replaceAll(' ', '%20');
                  messageToSend = messageToSend.replaceAll('#', '');
                  messageToSend = messageToSend.replaceAll('<br>', '%0a');
                  messageToSend = messageToSend.replaceAll('</h4>', '');
                  messageToSend = messageToSend.replaceAll('<h4>', '');
                  messageToSend = messageToSend.replaceAll('à', 'a');
                  messageToSend = messageToSend.replaceAll('è', 'e');
                  messageToSend = messageToSend.replaceAll('ò', 'o');
                  messageToSend = messageToSend.replaceAll('ù', 'u');
                  messageToSend = messageToSend.replaceAll('é', 'e');

                  print(messageToSend);
                  String urlString = 'https://api.whatsapp.com/send/?phone=${refactorNumber(number)}&text=$messageToSend';

                  if(Platform.isIOS){
                    if (await canLaunch(urlString)) {
                      await launch(urlString);
                    } else {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          duration: Duration(milliseconds: 3000),
                          content: Text('Errore durante l\'invio del messaggio $urlString. Contattare il supporto'
                          )));
                      throw 'Could not launch $urlString';
                    }
                  }else{
                    await launch(urlString);
                  }
                },
                child: Card(
                  elevation: 5,
                  color: kPrimaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(''),
                      Text('INOLTRA CON WHAT\'S APP', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () async {
                          String messageToSend = message;

                          messageToSend = messageToSend.replaceAll('&', '%26');
                          messageToSend = messageToSend.replaceAll(' ', '%20');
                          messageToSend = messageToSend.replaceAll('#', '');
                          messageToSend = messageToSend.replaceAll('<br>', '%0a');
                          messageToSend = messageToSend.replaceAll('</h4>', '');
                          messageToSend = messageToSend.replaceAll('<h4>', '');
                          messageToSend = messageToSend.replaceAll('à', 'a');
                          messageToSend = messageToSend.replaceAll('è', 'e');
                          messageToSend = messageToSend.replaceAll('ò', 'o');
                          messageToSend = messageToSend.replaceAll('ù', 'u');
                          messageToSend = messageToSend.replaceAll('é', 'e');

                          String urlString = 'https://api.whatsapp.com/send/?phone=${refactorNumber(number)}&text=$messageToSend';

                          if(Platform.isIOS){
                            if (await canLaunch(urlString)) {
                              await launch(urlString);
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  backgroundColor: kPinaColor,
                                  duration: Duration(milliseconds: 3000),
                                  content: Text('Errore durante l\'invio del messaggio $urlString. Contattare il supporto'
                                  )));
                              throw 'Could not launch $urlString';
                            }
                          }else{
                            await launch(urlString);
                          }


                        }, icon: SvgPicture.asset(
                        'assets/icons/ws.svg',

                      ),),

                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  launch('sms:${refactorNumber(number)}?body=$message');
                },
                child: Card(
                  color: kPrimaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(''),
                      Text('INOLTRA CON SMS', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: (){
                          launch('sms:${refactorNumber(number)}?body=$message');
                        }, icon: SvgPicture.asset(
                        'assets/icons/textmessage.svg',

                      ),),

                    ],
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text('-- oppure torna alla home --' , textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
          child: SizedBox(
            width: getProportionateScreenWidth(400),
            child: CupertinoButton(
                color: kPrimaryColor,
                child: const Text('Torna alla home'),
                onPressed: () {

                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, HomeScreenMain.routeName);

                },),
          ),
        ),

      ),
    );
  }
}


