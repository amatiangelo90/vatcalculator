import 'package:dio/src/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/screens/main_page.dart';
import 'package:vat_calculator/size_config.dart';
import '../../../../../client/vatservice/model/action_model.dart';
import '../../../../../client/vatservice/model/order_model.dart';
import '../../../../../client/vatservice/model/utils/action_type.dart';
import '../../../../../client/vatservice/model/utils/order_state.dart';
import '../../../../../models/databundlenotifier.dart';

class OrderErrorDetailsScreen extends StatelessWidget {
  const OrderErrorDetailsScreen({Key key, this.message, this.number, this.mail, this.supplier, this.performSaveOrderId, this.code, this.deliveryDate}) : super(key: key);

  final String message;
  final String number;
  final String mail;
  final SupplierModel supplier;
  final Response performSaveOrderId;
  final String code;
  final DateTime deliveryDate;

  @override
  Widget build(BuildContext context) {

    String messageToSend;
    messageToSend = message.replaceAll('&', '%26');
    messageToSend = message.replaceAll('#', '');

    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier,_){
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
                            'un paio di minuti.\n\n' , textAlign: TextAlign.center,),
                        Divider(height: 1, indent: 20, endIndent: 20, color: Colors.grey.withOpacity(0.3)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text('Se non disponi della mail puoi inviare il messaggio tramite what\'s app oppure sms.  ' , textAlign: TextAlign.center,),
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
                        GestureDetector(
                          onTap: (){
                            launch('https://api.whatsapp.com/send/?phone=${refactorNumber(supplier.tel)}&text=$messageToSend');
                          },
                          child: Card(
                            elevation: 5,
                            color: kPrimaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(''),
                                Column(
                                  children: [
                                    Text('INOLTRA CON WHAT\'S APP', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                    Text('AL NUMERO ${supplier.tel}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                IconButton(
                                  onPressed: (){
                                    launch('https://api.whatsapp.com/send/?phone=${refactorNumber(supplier.tel)}&text=$messageToSend');
                                  }, icon: SvgPicture.asset(
                                  'assets/icons/ws.svg',

                                ),),

                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            launch('sms:${refactorNumber(supplier.tel)}?body=$messageToSend');
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
                                    launch('sms:${refactorNumber(supplier.tel)}?body=$messageToSend');
                                  }, icon: SvgPicture.asset(
                                  'assets/icons/textmessage.svg',

                                ),),

                              ],
                            ),
                          ),
                        ),

                        const Text('oppure, se il numero configurato è sbagliato invia l\'ordine selezionando un numero dalla tua lista di contatti' , textAlign: TextAlign.center,),
                        GestureDetector(
                          onTap: (){
                            launch('https://api.whatsapp.com/send/?text=$messageToSend');
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
                                  onPressed: (){
                                    launch('https://api.whatsapp.com/send/?text=$messageToSend');
                                  }, icon: SvgPicture.asset(
                                  'assets/icons/ws.svg',
                                ),),

                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            performFinishOrderAndSaveInSentBySmsOrWhatappState(dataBundleNotifier, performSaveOrderId);
                            launch('sms:?body=$messageToSend');
                            Navigator.pushNamed(context, HomeScreenMain.routeName);
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
                                    performFinishOrderAndSaveInSentBySmsOrWhatappState(dataBundleNotifier, performSaveOrderId);
                                    launch('sms:?body=$messageToSend');
                                    Navigator.pushNamed(context, HomeScreenMain.routeName);

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
              padding: const EdgeInsets.all(8.0),
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
      },
    );
  }

  Future<void> performFinishOrderAndSaveInSentBySmsOrWhatappState(DataBundleNotifier dataBundleNotifier, Response performSaveOrderId) async {
    await dataBundleNotifier
        .getclientServiceInstance()
        .updateOrderStatus(
        orderModel: OrderModel(
            pk_order_id: performSaveOrderId.data,
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
}


