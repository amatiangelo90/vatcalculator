import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/main_page.dart';
import 'package:vat_calculator/size_config.dart';
import 'package:vat_calculator/swagger/swagger.enums.swagger.dart';

import '../../../../../swagger/swagger.models.swagger.dart';

class OrderSentDetailsScreen extends StatelessWidget {
  const OrderSentDetailsScreen({Key? key,
    required this.orderSent,
    required this.message,
    required this.number,
    required this.mail,
    required this.supplierName,
    required this.orderStatus,
    required this.orderStatusMessage,
  }) : super(key: key);

  final OrderEntity orderSent;
  final String message;
  final String number;
  final String mail;
  final String supplierName;
  final String orderStatusMessage;
  final OrderEntityOrderStatus orderStatus;


  @override
  Widget build(BuildContext context) {

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  color: orderStatus == OrderEntityOrderStatus.inviato ? kCustomGreen : kRed,
                  width: getProportionateScreenWidth(400),
                  child: Center(child:
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      children: [
                        orderStatus == OrderEntityOrderStatus.inviato ? Text('Ordine inviato correttamente al fornitore [$supplierName] tramite \nemail [$mail]',
                          overflow: TextOverflow.visible, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(15),
                          ), ) : Text('ERRORE\nOrdine NON inviato al fornitore [$supplierName] tramite \nemail [$mail]. \nErrore rilevato durante l\'invio: ' + orderStatusMessage,
                          overflow: TextOverflow.visible, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(15),
                          ), ),
                        Text('STATO ORDINE : ' + orderEntityOrderStatusToJson(orderStatus).toString(),
                          overflow: TextOverflow.visible, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(15),
                          ), ),
                      ],
                    ),
                  ),),
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
                        color: kCustomWhite,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          message.replaceAll('%0a', '\n'),
                          style: TextStyle(color: kCustomGrey),
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('-- inoltra tramite --' , textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () async {
                      String messageToSend = message;

                      messageToSend = messageToSend.replaceAll('&', '%26');
                      messageToSend = messageToSend.replaceAll(' ', '%20');
                      messageToSend = messageToSend.replaceAll('#', '');
                      messageToSend = messageToSend.replaceAll('<br>', '%0a');
                      messageToSend = messageToSend.replaceAll('</h4>', '');
                      messageToSend = messageToSend.replaceAll('<h4>', '');
                      messageToSend = messageToSend.replaceAll('à', 'a');
                      messageToSend = messageToSend.replaceAll('á', 'a');
                      messageToSend = messageToSend.replaceAll('â', 'a');
                      messageToSend = messageToSend.replaceAll('è', 'e');
                      messageToSend = messageToSend.replaceAll('ò', 'o');
                      messageToSend = messageToSend.replaceAll('ù', 'u');
                      messageToSend = messageToSend.replaceAll('é', 'e');

                      print(messageToSend);
                      String urlString = 'https://api.whatsapp.com/send/?phone=${refactorNumber(number)}&text=$messageToSend';

                      if(Platform.isIOS){
                        if (await canLaunch(urlString)) {

                          if(orderStatus == OrderEntityOrderStatus.nonInviato){
                            //TODO qui non funziona l'aggiornamento dello stato
                            orderSent.orderStatus = OrderEntityOrderStatus.inviatoTramiteWhatsApp;
                            dataBundleNotifier.getSwaggerClient().apiV1AppOrderUpdatePut(orderEntity: orderSent);
                          }
                          await launch(urlString);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: kPinaColor,
                              duration: Duration(milliseconds: 3000),
                              content: Text('Errore durante l\'invio del messaggio $urlString. Contattare il supporto'
                              )));
                          throw 'Could not launch $urlString';
                        }
                      }else{
                        if(orderStatus == OrderEntityOrderStatus.nonInviato){
                          //TODO qui non funziona l'aggiornamento dello stato
                          orderSent.orderStatus = OrderEntityOrderStatus.inviatoTramiteWhatsApp;
                          dataBundleNotifier.getSwaggerClient().apiV1AppOrderUpdatePut(orderEntity: orderSent);
                        }
                        await launch(urlString);
                      }
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.resolveWith((states) => 5),
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                      side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 1.5, color: kCustomGreen),),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Invia tramite What\'s App',style: TextStyle(
                                  color: kCustomGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  getProportionateScreenWidth(
                                      15)),),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/ws.svg',
                                    height: getProportionateScreenHeight(25),

                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
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
                color: kCustomGrey,
                child: const Text('Torna alla home'),
                onPressed: () {

                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, HomeScreenMain.routeName);

                },),
            ),
          ),

        );
      },
    );
  }
}


