import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/size_config.dart';

import '../../../../home/home_screen.dart';

class OrderSentDetailsScreen extends StatelessWidget {
  const OrderSentDetailsScreen({Key key, this.message, this.number, this.mail, this.supplierName}) : super(key: key);

  final String message;
  final String number;
  final String mail;
  final String supplierName;

  @override
  Widget build(BuildContext context) {

    String messageToSend;
    messageToSend = message.replaceAll('&', '%26');
    messageToSend = message.replaceAll('#', '');

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  width: getProportionateScreenWidth(400),
                  height: getProportionateScreenHeight(110),
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
                onTap: (){
                  launch('https://api.whatsapp.com/send/?phone=${refactorNumber(number)}&text=$messageToSend');
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
                        onPressed: (){
                          launch('https://api.whatsapp.com/send/?phone=${refactorNumber(number)}&text=$messageToSend');
                        }, icon: SvgPicture.asset(
                        'assets/icons/ws.svg',

                      ),),

                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  launch('sms:${refactorNumber(number)}?body=$messageToSend');
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
                          launch('sms:${refactorNumber(number)}?body=$messageToSend');
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
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: getProportionateScreenWidth(400),
            child: CupertinoButton(
                color: kPrimaryColor,
                child: const Text('Torna alla home'),
                onPressed: () => Navigator.pushNamed(context, HomeScreen.routeName),),
          ),
        ),

      ),
    );
  }
}


