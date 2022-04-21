import 'dart:io';

import 'package:dio/src/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/screens/main_page.dart';
import 'package:vat_calculator/size_config.dart';
import '../../../../../client/vatservice/model/action_model.dart';
import '../../../../../client/vatservice/model/order_model.dart';
import '../../../../../client/vatservice/model/utils/action_type.dart';
import '../../../../../client/vatservice/model/utils/order_state.dart';
import '../../../../../models/databundlenotifier.dart';

class OrderErrorDetailsScreen extends StatelessWidget {
  const OrderErrorDetailsScreen({Key key, this.message, this.number, this.mail, this.supplier, this.performSaveOrderId, this.code, this.deliveryDate, this.storageModel}) : super(key: key);

  final String message;
  final String number;
  final String mail;
  final SupplierModel supplier;
  final int performSaveOrderId;
  final String code;
  final DateTime deliveryDate;
  final StorageModel storageModel;

  @override
  Widget build(BuildContext context) {

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier,_){
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

                      child: Card(color: Colors.red, child:
                      Center(child:
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text('Errore invio ordine al fornitore [${supplier.nome}] tramite \nemail [$mail]', overflow: TextOverflow.visible, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(18),
                        ),),
                      ),),),
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Text('E\' stato riscontrato un errore durate l\''
                            'invio dell\'ordine. Controlla che la mail ['+ supplier.mail +'] sia corretta oppure riprova fra '
                            'un paio di minuti.\n\n' , textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                        Divider(height: 1, indent: 20, endIndent: 20, color: Colors.grey.withOpacity(0.3)),

                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Se non disponi della mail puoi inviare il messaggio tramite what\'s app oppure sms.  ' , textAlign: TextAlign.center,),
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
                                  style: const TextStyle(color: kCustomWhite),
                                ),
                              ),
                            ),
                          ),
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

                            if (await canLaunch(urlString)) {
                            await launch(urlString);
                            sendOrderPushNotification(dataBundleNotifier, supplier, deliveryDate, storageModel);
                            performFinalAction(dataBundleNotifier, context);
                            } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: kPinaColor,
                            duration: Duration(milliseconds: 3000),
                            content: Text('Errore durante l\'invio del messaggio $urlString. Contattare il supporto'
                            )));
                            throw 'Could not launch $urlString';
                            }

                          },
                          child: Card(
                            elevation: 5,
                            color: kPrimaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(''),
                                Column(
                                  children: [
                                    const Text('INOLTRA CON WHAT\'S APP', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                    Text('AL NUMERO ${supplier.tel}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                  ],
                                ),
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

                                    print(messageToSend);
                                    String urlString = 'https://api.whatsapp.com/send/?phone=${refactorNumber(number)}&text=$messageToSend';

                                    if (await canLaunch(urlString)) {
                                    await launch(urlString);
                                    sendOrderPushNotification(dataBundleNotifier, supplier, deliveryDate, storageModel);
                                    performFinalAction(dataBundleNotifier, context);
                                    } else {
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    backgroundColor: kPinaColor,
                                    duration: Duration(milliseconds: 3000),
                                    content: Text('Errore durante l\'invio del messaggio $urlString. Contattare il supporto'
                                    )));
                                    throw 'Could not launch $urlString';
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

                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: kPinaColor,
                                duration: Duration(milliseconds: 3000),
                                content: Text('Funzione non ancora implementata'
                                )));
                            //sendOrderPushNotification(dataBundleNotifier, supplier, deliveryDate, storageModel);
                            //launch('sms:${refactorNumber(supplier.tel)}?body=$messageToSend');
                            //performFinalAction(dataBundleNotifier, context);
                          },
                          child: Card(
                            color: kPrimaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(''),
                                Column(
                                  children: [
                                    Text('INOLTRA CON SMS', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                    Text('AL NUMERO ${supplier.tel}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                IconButton(
                                  onPressed: (){

                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        backgroundColor: kPinaColor,
                                        duration: Duration(milliseconds: 3000),
                                        content: Text('Funzione non ancora implementata'
                                        )));
                                    //sendOrderPushNotification(dataBundleNotifier, supplier, deliveryDate, storageModel);
                                    //launch('sms:${refactorNumber(supplier.tel)}?body=$messageToSend');
                                    //performFinishOrderAndSaveInSentBySmsOrWhatappState(dataBundleNotifier, performSaveOrderId);

                                  }, icon: SvgPicture.asset(
                                  'assets/icons/textmessage.svg',

                                ),),

                              ],
                            ),
                          ),
                        ),

                        const Text('oppure, se il numero configurato è sbagliato invia l\'ordine selezionando un numero dalla tua lista di contatti' , textAlign: TextAlign.center,),
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
                            String urlString = 'https://api.whatsapp.com/send/?text=$messageToSend';

                            if (await canLaunch(urlString)) {
                            await launch(urlString);
                            sendOrderPushNotification(dataBundleNotifier, supplier, deliveryDate, storageModel);
                            performFinalAction(dataBundleNotifier, context);
                            } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: kPinaColor,
                            duration: Duration(milliseconds: 3000),
                            content: Text('Errore durante l\'invio del messaggio $urlString. Contattare il supporto'
                            )));
                            throw 'Could not launch $urlString';
                            }
                          },
                          child: Card(
                            elevation: 5,
                            color: kPrimaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(''),
                                Column(
                                  children: const [
                                    Text('INOLTRA CON WHAT\'S APP', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                    Text('SCEGLIENDO DA RUBRICA', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                  ],
                                ),
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

                                    print(messageToSend);
                                    String urlString = 'https://api.whatsapp.com/send/?text=$messageToSend';

                                    if (await canLaunch(urlString)) {
                                    await launch(urlString);
                                    sendOrderPushNotification(dataBundleNotifier, supplier, deliveryDate, storageModel);
                                    performFinalAction(dataBundleNotifier, context);
                                    } else {
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    backgroundColor: kPinaColor,
                                    duration: Duration(milliseconds: 3000),
                                    content: Text('Errore durante l\'invio del messaggio $urlString. Contattare il supporto'
                                    )));
                                    throw 'Could not launch $urlString';
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
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: kPinaColor,
                                duration: Duration(milliseconds: 3000),
                                content: Text('Funzione non ancora implementata'
                                )));
                            //sendOrderPushNotification(dataBundleNotifier, supplier, deliveryDate, storageModel);
                            //launch('sms:?body=$messageToSend');
                            //performFinalAction(dataBundleNotifier, context);
                          },
                          child: Card(
                            color: kPrimaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(''),
                                Column(
                                  children: const [
                                    Text('INOLTRA CON SMS', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                    Text('SCEGLIENDO DA RUBRICA', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)), ],
                                ),
                                IconButton(
                                  onPressed: (){
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        backgroundColor: kPinaColor,
                                        duration: Duration(milliseconds: 3000),
                                        content: Text('Funzione non ancora implementata'
                                        )));
                                    //sendOrderPushNotification(dataBundleNotifier, supplier, deliveryDate, storageModel);
                                    //launch('sms:?body=$messageToSend');
                                    //performFinalAction(dataBundleNotifier, context);

                                  }, icon: SvgPicture.asset(
                                  'assets/icons/textmessage.svg',

                                ),),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('-- oppure torna alla home --' , textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 50,),
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

                    dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, HomeScreenMain.routeName);

                  },),
              ),
            ),

          ),
        );
      },
    );
  }

  Future<void> performFinishOrderAndSaveInSentBySmsOrWhatappState(DataBundleNotifier dataBundleNotifier, int performSaveOrderId) async {
    await dataBundleNotifier
        .getclientServiceInstance()
        .updateOrderStatus(
        orderModel: OrderModel(
            pk_order_id: performSaveOrderId,
            status: OrderState.SENT_BY_MESSAGE,
            delivery_date: deliveryDate.millisecondsSinceEpoch,
            closedby: dataBundleNotifier
                .retrieveNameLastNameCurrentUser()),
        actionModel: ActionModel(
            date: DateTime.now().millisecondsSinceEpoch,
            description:
            'Ha inviato l\'ordine #${code} '
                'al fornitore ${supplier.nome}. ',
            fkBranchId: dataBundleNotifier
                .currentBranch.pkBranchId,
            user: dataBundleNotifier
                .retrieveNameLastNameCurrentUser(),
            type: ActionType.SENT_BY_MESSAGE));

    dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
    dataBundleNotifier.onItemTapped(0);
  }

  void performFinalAction(DataBundleNotifier dataBundleNotifier, context) {
    performFinishOrderAndSaveInSentBySmsOrWhatappState(dataBundleNotifier, performSaveOrderId);
    dataBundleNotifier.setIndexIvaListValue(2);
    Navigator.pushNamed(context, HomeScreenMain.routeName);
  }

  void sendOrderPushNotification(DataBundleNotifier dataBundleNotifier, SupplierModel supplier, DateTime currentDate, StorageModel currentStorageModel) {
    String eventDatePretty = '${getDayFromWeekDay(currentDate.weekday)} ${currentDate.day.toString()} ${getMonthFromMonthNumber(currentDate.month)} ${currentDate.year.toString()}';

    dataBundleNotifier.getclientMessagingFirebase().sendNotificationToTopic('branch-${dataBundleNotifier.currentBranch.pkBranchId.toString()}',
        'Ordine per fornitore ${supplier.nome} da ricevere $eventDatePretty in via ${currentStorageModel.address} (${currentStorageModel.city})', '${dataBundleNotifier.userDetailsList[0].firstName} ha creato un nuovo ordine', '');

  }
}


