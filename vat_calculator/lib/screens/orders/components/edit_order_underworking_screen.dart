import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/pdf/pdf_service.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/components/light_colors.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/bundle_users_storage_supplier_forbranch.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/components/screens/orders_utils.dart';
import 'package:vat_calculator/size_config.dart';

import '../../../client/fattureICloud/model/response_fornitori.dart';
import '../../../client/vatservice/model/move_product_between_storage_model.dart';
import '../../main_page.dart';

class OrderCompletionScreen extends StatefulWidget {
  const OrderCompletionScreen({Key key, this.orderModel, this.productList, }) : super(key: key);

  final OrderModel orderModel;
  final List<ProductOrderAmountModel> productList;

  @override
  State<OrderCompletionScreen> createState() => _OrderCompletionScreenState();
}

class _OrderCompletionScreenState extends State<OrderCompletionScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController totalController;
  TextEditingController controllerUpdate;

  @override
  Widget build(BuildContext context) {

    totalController = TextEditingController(text: calculateTotal(widget.productList));
    controllerUpdate = TextEditingController(text: widget.orderModel.total.toStringAsFixed(2));

    totalController.selection = TextSelection.fromPosition(TextPosition(offset: totalController.text.length));
    controllerUpdate.selection = TextSelection.fromPosition(TextPosition(offset: controllerUpdate.text.length));

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.9,
      overlayWidget: const LoaderOverlayWidget(message: 'Caricamento dati...',),
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child){
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {});
            },
            child: Scaffold(
              key: _scaffoldKey,
              bottomSheet: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: CupertinoButton(
                          color: kCustomBlue,
                          child: const Text('RICEVUTO', style: TextStyle(color: kCustomWhite, fontWeight: FontWeight.w700),),
                          onPressed: (){

                            FocusScope.of(context).requestFocus(FocusNode());
                            Widget cancelButton = TextButton(
                              child: const Text("INDIETRO", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                              onPressed:  () {
                                Navigator.of(context).pop();
                              },
                            );
                            Widget continueButton = TextButton(
                              child: const Text("RICEVUTO", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700)),
                              onPressed:  () async {

                                Navigator.of(context).pop();

                                context.loaderOverlay.show();
                                if(dataBundleNotifier.executeLoadStorage == 'NO'){
                                  await dataBundleNotifier.getclientServiceInstance().updateOrderStatus(
                                      orderModel: OrderModel(
                                          pk_order_id: widget.orderModel.pk_order_id,
                                          status: OrderState.RECEIVED_ARCHIVED,
                                          paid: dataBundleNotifier.signAsPaid == 'SI' ? 'true' : 'false',
                                          total: dataBundleNotifier.sameTotalThanCalculated == 'SI' ? double.parse(totalController.text.replaceAll(',', '.')) : widget.orderModel.total,
                                          delivery_date: dateFormat.format(DateTime.now()),
                                          closedby: dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName
                                      ),
                                      actionModel: ActionModel(
                                          date: DateTime.now().millisecondsSinceEpoch,
                                          description: 'Ha modificato in ${OrderState.RECEIVED_ARCHIVED} l\'ordine #${widget.orderModel.code} da parte del fornitore ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)}.',
                                          fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                          user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                          type: ActionType.RECEIVED_ORDER
                                      )
                                  );
                                  dataBundleNotifier.updateOrderStatusById(
                                      widget.orderModel.pk_order_id,
                                      OrderState.RECEIVED_ARCHIVED,
                                      dateFormat.format(DateTime.now()),
                                      dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName);

                                  dataBundleNotifier.removeFromUnderWorkingOrdersTheOnesUpdateAsReceived(widget.orderModel.pk_order_id);
                                  dataBundleNotifier.onItemTapped(0);
                                  Navigator.pushNamed(context, HomeScreenMain.routeName);
                                }else{
                                  StorageModel storageModel = dataBundleNotifier.getStorageFromCurrentStorageListByStorageId(widget.orderModel.fk_storage_id);
                                  List<MoveProductBetweenStorageModel> listMoveProductBetweenStorageModel = [];

                                  widget.productList.forEach((element) {
                                    if(element.amount > 0){
                                      listMoveProductBetweenStorageModel.add(
                                          MoveProductBetweenStorageModel(
                                              amount: element.amount,
                                              pkProductId: element.pkProductId,
                                              storageIdFrom: 0,
                                              storageIdTo: storageModel.pkStorageId
                                          )
                                      );
                                    }
                                  });

                                  Response response = await dataBundleNotifier.getclientServiceInstance()
                                      .moveProductBetweenStorage(listMoveProductBetweenStorageModel: listMoveProductBetweenStorageModel,
                                      actionModel: ActionModel(
                                          date: DateTime.now().millisecondsSinceEpoch,
                                          description: 'Ha effettuato carico in magazzino ${storageModel.name} a fronte della ricezione dell\'ordine #${widget.orderModel.code} da parte del fornitore ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)}.',
                                          fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                          user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                          type: ActionType.STORAGE_LOAD
                                      )
                                  );
                                  if(response != null && response.data == 1){
                                    dataBundleNotifier.cleanExtraArgsListProduct();
                                    dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                                    await dataBundleNotifier.getclientServiceInstance().updateOrderStatus(
                                        orderModel: OrderModel(
                                            pk_order_id: widget.orderModel.pk_order_id,
                                            status: OrderState.RECEIVED_ARCHIVED,
                                            paid: dataBundleNotifier.signAsPaid == 'SI' ? 'true' : 'false',
                                            total: dataBundleNotifier.sameTotalThanCalculated == 'SI' ? double.parse(totalController.text.replaceAll(',', '.')) : widget.orderModel.total,
                                            delivery_date: dateFormat.format(DateTime.now()),
                                            closedby: dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName
                                        ),
                                        actionModel: ActionModel(
                                            date: DateTime.now().millisecondsSinceEpoch,
                                            description: 'Ha modificato in ${OrderState.RECEIVED_ARCHIVED} l\'ordine #${widget.orderModel.code} da parte del fornitore ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)}.',
                                            fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                            user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                            type: ActionType.RECEIVED_ORDER
                                        )
                                    );
                                    dataBundleNotifier.updateOrderStatusById(widget.orderModel.pk_order_id, OrderState.RECEIVED_ARCHIVED, dateFormat.format(DateTime.now()), dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName);
                                    dataBundleNotifier.removeFromUnderWorkingOrdersTheOnesUpdateAsReceived(widget.orderModel.pk_order_id);

                                    dataBundleNotifier.getclientMessagingFirebase().sendNotificationToUsersByTokens(dataBundleNotifier.currentBossTokenList,
                                        '${dataBundleNotifier.userDetailsList[0].firstName} ha ricevuto l\'ordine di ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)} '
                                            'per ${dataBundleNotifier.currentBranch.companyName}.',
                                        'Ordine ${widget.orderModel.code} Ricevuto',DateTime.now().millisecondsSinceEpoch.toString());

                                    dataBundleNotifier.onItemTapped(0);
                                    Navigator.pushNamed(context, HomeScreenMain.routeName);
                                  }else{
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                        backgroundColor: LightColors.kRed,
                                        duration: Duration(milliseconds: 1200),
                                        content: Text('Non sono riuscito a completare l\'ordine i prodotti da magazzino. Contatta il supporto')));
                                  }
                                }

                                context.loaderOverlay.hide();
                              },
                            );

                            if((dataBundleNotifier.sameTotalThanCalculated == 'SI' && double.tryParse(totalController.text.replaceAll(',', '.')) != null)
                                || (dataBundleNotifier.sameTotalThanCalculated == 'NO' && widget.orderModel.total != 0.0)){
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                context: context,
                                builder: (context) {
                                  var width = MediaQuery.of(context).size.width;
                                  return SizedBox(
                                    height: getProportionateScreenHeight(900),
                                    width: width - 90,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                topLeft: Radius.circular(10.0) ),
                                            color: kPrimaryColor,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('  Completa Ordine ed Archivia',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: getProportionateScreenWidth(15),
                                                    fontWeight: FontWeight.bold,
                                                    color: kCustomWhite,
                                                  )),
                                              IconButton(icon: const Icon(
                                                Icons.clear,
                                                color: kCustomWhite,
                                              ), onPressed: () { Navigator.pop(context); },),

                                            ],
                                          ),
                                        ),
                                        Text(''),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text('Contrassegna ordine #${widget.orderModel.code.toString()} '
                                                'come RICEVUTO ED ARCHIVIATO.', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w800, fontSize: getProportionateScreenHeight(15))),
                                          ),
                                        ),
                                        Divider(color: Colors.grey),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text('Eseguire carico:', style: TextStyle(fontSize: getProportionateScreenHeight(18), color: kPrimaryColor, fontWeight: FontWeight.w800)),
                                                Text('Ordine pagato:', style: TextStyle(fontSize: getProportionateScreenHeight(18), color: kPrimaryColor, fontWeight: FontWeight.w800)),
                                                Text('Totale uguale in fattura:', style: TextStyle(fontSize: getProportionateScreenHeight(18), color: kPrimaryColor, fontWeight: FontWeight.w800)),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(dataBundleNotifier.executeLoadStorage, style: TextStyle(fontSize: getProportionateScreenHeight(18), color: dataBundleNotifier.executeLoadStorage == 'SI' ? LightColors.kGreen : LightColors.kRed, fontWeight: FontWeight.w800)),
                                                Text(dataBundleNotifier.signAsPaid, style: TextStyle(fontSize: getProportionateScreenHeight(18), color: dataBundleNotifier.signAsPaid == 'SI' ? LightColors.kGreen : LightColors.kRed, fontWeight: FontWeight.w800)),
                                                Text(dataBundleNotifier.sameTotalThanCalculated, style: TextStyle(fontSize: getProportionateScreenHeight(18), color: dataBundleNotifier.sameTotalThanCalculated == 'SI' ? LightColors.kGreen : LightColors.kRed, fontWeight: FontWeight.w800)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(color: Colors.grey, height: 10),
                                        dataBundleNotifier.sameTotalThanCalculated == 'SI' ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:  buildProductListTotal(false),
                                        ) : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:  buildProductListTotalUpdate(false),
                                        ),

                                        ButtonBar(
                                          alignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            cancelButton,
                                            continueButton,
                                          ],
                                        ),


                                      ],
                                    ),
                                  );
                                },);
                            }else{
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  backgroundColor: LightColors.kRed,
                                  duration: Duration(milliseconds: 1200),
                                  content: Text('Immettere un valore numerico corretto per il totale')));
                            }
                          }),
                    ),
                  ),
                ],
              ),
              appBar: AppBar(
                actions: [
                  IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/textmessage.svg',
                        height: getProportionateScreenHeight(30),
                      ),
                      onPressed: () {
                        DateTime deliveryDate = dateFormat.parse(widget.orderModel.delivery_date);
                        String message = OrderUtils.buildMessageFromCurrentOrderListFromDraft(
                            branchName: dataBundleNotifier.currentBranch.companyName,
                            orderId: widget.orderModel.code,
                            orderProductList: widget.productList,
                            deliveryDate: getDayFromWeekDay(deliveryDate.weekday) + ' ' + deliveryDate.day.toString() + '/' + deliveryDate.month.toString() + '/' + deliveryDate.year.toString(),
                            supplierName: dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id),
                            currentUserName: dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName,
                            storageAddress: dataBundleNotifier.getStorageModelById(widget.orderModel.fk_storage_id).address,
                            storageCap: dataBundleNotifier.getStorageModelById(widget.orderModel.fk_storage_id).cap,
                            storageCity: dataBundleNotifier.getStorageModelById(widget.orderModel.fk_storage_id).city);

                        print('Message to send: ' + message);
                        SupplierModel supplierNumber = dataBundleNotifier.getSupplierFromList(widget.orderModel.fk_supplier_id);

                        message = message.replaceAll('#', '');
                        message = message.replaceAll('<br>', '\n');
                        message = message.replaceAll('</h4>', '');
                        message = message.replaceAll('<h4>', '');

                        launch('sms:${refactorNumber(supplierNumber.tel)}?body=$message');
                        //launch('sms:${refactorNumber(number)}?body=$message');
                      }
                  ),
                  IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/ws.svg',
                        height: getProportionateScreenHeight(30),
                      ),
                      onPressed: () async {
                        DateTime deliveryDate = dateFormat.parse(widget.orderModel.delivery_date);
                        String message = OrderUtils.buildMessageFromCurrentOrderListFromDraft(
                            branchName: dataBundleNotifier.currentBranch.companyName,
                            orderId: widget.orderModel.code,
                            orderProductList: widget.productList,
                            deliveryDate: getDayFromWeekDay(deliveryDate.weekday) + ' ' + deliveryDate.day.toString() + '/' + deliveryDate.month.toString() + '/' + deliveryDate.year.toString(),
                            supplierName: dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id),
                            currentUserName: dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName,
                            storageAddress: dataBundleNotifier.getStorageModelById(widget.orderModel.fk_storage_id).address,
                            storageCap: dataBundleNotifier.getStorageModelById(widget.orderModel.fk_storage_id).cap,
                            storageCity: dataBundleNotifier.getStorageModelById(widget.orderModel.fk_storage_id).city);

                        SupplierModel supplierNumber = dataBundleNotifier.getSupplierFromList(widget.orderModel.fk_supplier_id);

                        print(message);

                        message = message.replaceAll('&', '%26');
                        message = message.replaceAll(' ', '%20');
                        message = message.replaceAll('#', '');
                        message = message.replaceAll('<br>', '%0a');
                        message = message.replaceAll('</h4>', '');
                        message = message.replaceAll('<h4>', '');
                        message = message.replaceAll('à', 'a');
                        message = message.replaceAll('è', 'e');
                        message = message.replaceAll('ò', 'o');
                        message = message.replaceAll('ù', 'u');
                        message = message.replaceAll('é', 'e');

                        String urlString = 'https://api.whatsapp.com/send/?phone=${refactorNumber(supplierNumber.tel)}&text=$message';

                        if(Platform.isIOS){
                          if (await canLaunch(urlString)) {
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
                          await launch(urlString);
                        }
                      }
                  ),
                ],
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                backgroundColor: kPrimaryColor,
                centerTitle: true,
                automaticallyImplyLeading: true,
                title: const Text(
                  'Completa Ordine', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: CupertinoButton(
                            color: kPinaColor,
                            child: const Text('NON RICEVUTO', style: TextStyle(color: kCustomWhite, fontWeight: FontWeight.w700),),
                            onPressed: (){
                              Widget cancelButton = TextButton(
                                child: const Text("Indietro", style: TextStyle(color: kPrimaryColor),),
                                onPressed:  () {
                                  Navigator.of(context).pop();
                                },
                              );
                              Widget continueButton = TextButton(
                                child: const Text("ELIMINA", style: TextStyle(color: kPinaColor, fontWeight: FontWeight.w700)),
                                onPressed:  () async {
                                  Navigator.of(context).pop();
                                  context.loaderOverlay.show();
                                  await dataBundleNotifier.getclientServiceInstance().updateOrderStatus(
                                      orderModel: OrderModel(
                                          pk_order_id: widget.orderModel.pk_order_id,
                                          status: OrderState.REFUSED_ARCHIVED,
                                          paid: 'false',
                                          delivery_date: dateFormat.format(DateTime.now()),
                                          closedby: dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName
                                      ),
                                      actionModel: ActionModel(
                                          date: DateTime.now().millisecondsSinceEpoch,
                                          description: 'Ha modificato in ${OrderState.REFUSED_ARCHIVED} l\'ordine #${widget.orderModel.code} da parte del fornitore ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)}.',
                                          fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                          user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                          type: ActionType.ORDER_DELETE
                                      )
                                  );

                                  dataBundleNotifier.cleanExtraArgsListProduct();
                                  dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                                  dataBundleNotifier.updateOrderStatusById(widget.orderModel.pk_order_id, OrderState.RECEIVED_ARCHIVED, dateFormat.format(DateTime.now()), dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName);
                                  dataBundleNotifier.removeFromUnderWorkingOrdersTheOnesUpdateAsReceived(widget.orderModel.pk_order_id);

                                  dataBundleNotifier.getclientMessagingFirebase().sendNotificationToUsersByTokens(dataBundleNotifier.currentBossTokenList,
                                        '${dataBundleNotifier.userDetailsList[0].firstName} ha eliminato l\'ordine di ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)} '
                                            'per ${dataBundleNotifier.currentBranch.companyName}.',
                                        'Ordine ${widget.orderModel.code} NON Ricevuto', DateTime.now().millisecondsSinceEpoch.toString());

                                    dataBundleNotifier.onItemTapped(0);
                                    Navigator.pushNamed(context, HomeScreenMain.routeName);

                                  context.loaderOverlay.hide();
                                },
                              );

                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog (
                                    actions: [
                                      ButtonBar(
                                        alignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          cancelButton,
                                          continueButton,
                                        ],
                                      ),
                                    ],
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
                                          height: getProportionateScreenHeight(300),
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
                                                    color: kPinaColor,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('  Elimina Ordine ed Archivia',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: getProportionateScreenWidth(15),
                                                            fontWeight: FontWeight.bold,
                                                            color: kCustomWhite,
                                                          )),
                                                      IconButton(icon: const Icon(
                                                        Icons.clear,
                                                        color: kCustomWhite,
                                                      ), onPressed: () { Navigator.pop(context); },),

                                                    ],
                                                  ),
                                                ),
                                                Text(''),
                                                Center(
                                                  child: Text('Contrassegna ordine #${widget.orderModel.code.toString()} come NON ricevuto?', textAlign: TextAlign.center,),
                                                ),
                                                Text(''),
                                                Text('Nota: L\'ordine verrà spostato in archivio ma la merce non sarà caricata nel magazzino' , style: TextStyle(fontSize: getProportionateScreenHeight(12)), textAlign: TextAlign.center,),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                              );
                            }),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Card(
                            child: Column(
                              children: [
                                Text(dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id), style: TextStyle(fontWeight: FontWeight.w700, fontSize: getProportionateScreenHeight(25)),),
                                Text('#' + widget.orderModel.code, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(17)),),
                                Divider(endIndent: 40, indent: 40,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Creato da: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text(getUserDetailsById(widget.orderModel.fk_user_id, widget.orderModel.fk_branch_id, dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers), style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('il: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text(widget.orderModel.creation_date, style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Magazzino: ', style: TextStyle(fontWeight: FontWeight.bold),),

                                    dataBundleNotifier.getStorageFromCurrentStorageListByStorageId(widget.orderModel.fk_storage_id) == null ? SizedBox(width: 0,) : Text(dataBundleNotifier.getStorageFromCurrentStorageListByStorageId(widget.orderModel.fk_storage_id).name, style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Stato: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text(widget.orderModel.status, style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),),
                                  ],
                                ),
                                Divider(endIndent: 40, indent: 40,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Da consegnare a: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                    dataBundleNotifier.currentBranch == null ? Text('') : Text(dataBundleNotifier.currentBranch.companyName, style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('In via: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                    dataBundleNotifier.currentBranch == null ? Text('') : Text(dataBundleNotifier.currentBranch.address, style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Città: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                    dataBundleNotifier.currentBranch == null ? Text('') : Text(dataBundleNotifier.currentBranch.city, style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('CAP : ', style: TextStyle(fontWeight: FontWeight.bold),),
                                    dataBundleNotifier.currentBranch == null ? Text('') : Text(dataBundleNotifier.currentBranch.cap.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Da consegnare il: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text(widget.orderModel.delivery_date, style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),),
                                  ],
                                ),
                                const Divider(endIndent: 40, indent: 40,),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Dettagli'),
                                ),

                                Text(widget.orderModel.details,textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                                Divider(color: Colors.grey),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Eseguire carico magazzino una volta ricevuto l\'ordine?'),
                                ),
                                Column(
                                    children: [
                                      ListTile(
                                        title: Text("SI"),
                                        leading: Radio(
                                            value: "SI",
                                            groupValue: dataBundleNotifier.executeLoadStorage,
                                            onChanged: (value){
                                              dataBundleNotifier.setExdecuteLoadStorage(value);
                                            }),
                                      ),
                                      ListTile(
                                        title: Text("NO"),
                                        leading: Radio(
                                            value: "NO",
                                            groupValue: dataBundleNotifier.executeLoadStorage,
                                            onChanged: (value){
                                              dataBundleNotifier.setExdecuteLoadStorage(value);
                                            }),
                                      )
                                    ]
                                ),
                                dataBundleNotifier.currentPrivilegeType != Privileges.EMPLOYEE ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Contrassegnare l\'ordine come pagato?'),
                                ) : Text(''),
                                dataBundleNotifier.currentPrivilegeType != Privileges.EMPLOYEE ? Column(
                                    children: [
                                      ListTile(
                                        title: Text("SI"),
                                        leading: Radio(
                                            value: "SI",
                                            groupValue: dataBundleNotifier.signAsPaid,
                                            onChanged: (value){
                                              dataBundleNotifier.setSignAsPaid(value);
                                            }),
                                      ),
                                      ListTile(
                                        title: Text("NO"),
                                        leading: Radio(
                                            value: "NO",
                                            groupValue: dataBundleNotifier.signAsPaid,
                                            onChanged: (value){
                                              dataBundleNotifier.setSignAsPaid(value);
                                            }),
                                      )
                                    ]
                                ) : Text(''),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Carrello', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(20), fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: IconButton(
                                  icon: SvgPicture.asset('assets/icons/pdf.svg', width: getProportionateScreenWidth(23),),
                                    onPressed: (){
                                      PdfService pdfService = PdfService();
                                      pdfService.generatePdfOrderAndOpenOnDevide(
                                          widget.orderModel,
                                          widget.productList,
                                          dataBundleNotifier.currentBranch
                                      );
                                    },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    buildProductListWidget(context, dataBundleNotifier),
                    Divider(color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildProductListTotal(false),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('L\'importo totale coincide con l\'importo della fattura?'),
                    ),
                    Column(
                        children: [
                          ListTile(
                            title: Text("SI"),
                            leading: Radio(
                                value: "SI",
                                groupValue: dataBundleNotifier.sameTotalThanCalculated,
                                onChanged: (value){
                                  dataBundleNotifier.setSameTotalThanCalcuated(value);
                                }),
                          ),
                          ListTile(
                            title: Text("NO"),
                            leading: Radio(
                                value: "NO",
                                groupValue: dataBundleNotifier.sameTotalThanCalculated,
                                onChanged: (value){
                                  dataBundleNotifier.setSameTotalThanCalcuated(value);
                                }),
                          )
                        ]
                    ),
                    dataBundleNotifier.sameTotalThanCalculated == 'NO' ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  buildProductListTotalUpdate(true),
                    ) : SizedBox(height: 0),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Nb: Se il totale non conincide con l\'importo presente in fattura puoi modificarlo prima di contrassegnare l\'ordine come ricevuto', textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                    ),
                    SizedBox(height: getProportionateScreenHeight(120),),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  buildProductListWidget(context, DataBundleNotifier dataBundleNotifier) {

    List<Widget> tableRowList = [];
    widget.productList.forEach((currentProduct) {
      TextEditingController controller = TextEditingController(text: currentProduct.amount.toStringAsFixed(2));
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
      tableRowList.add(Divider(color: Colors.grey, height: 0),);
      tableRowList.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    currentProduct.nome.length > 25 ? currentProduct.nome.substring(0, 24) + '..': currentProduct.nome,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(overflow: TextOverflow.fade,
                        fontWeight: FontWeight.w900,
                        fontSize: getProportionateScreenHeight(15),
                        color: kPrimaryColor),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Unità di misura: ', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: getProportionateScreenHeight(11)),),
                          Text(currentProduct.unita_misura, style: TextStyle(fontWeight: FontWeight.w600, color: kCustomBlue),),
                        ],
                      ),
                        dataBundleNotifier.currentBranch.accessPrivilege != Privileges.EMPLOYEE ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Prezzo: ', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: getProportionateScreenHeight(11)),),
                          Text(currentProduct.prezzo_lordo.toStringAsFixed(2) + '€', style: TextStyle(fontWeight: FontWeight.w600, color: kCustomBlue),),
                        ],
                      ) : SizedBox(height: 0,)
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if(currentProduct.amount <= 0){
                                }else{
                                  currentProduct.amount --;
                                }
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(FontAwesomeIcons.minus, color: LightColors.kRed,),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints.loose(Size(
                                getProportionateScreenWidth(80),
                                getProportionateScreenWidth(60))),
                            child: CupertinoTextField(
                              controller: controller,
                              enabled: true,
                              onChanged: (text){
                                print(text);
                                if(double.tryParse(text.replaceAll(',', '.')) != null){
                                  currentProduct.amount = double.parse(text.replaceAll(',', '.'));
                                }
                              },
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true, signed: false),
                              clearButtonMode: OverlayVisibilityMode.never,
                              textAlign: TextAlign.center,
                              autocorrect: false,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                currentProduct.amount  =  currentProduct.amount + 1;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(FontAwesomeIcons.plus, color: Colors.green.shade900),
                            ),
                          ),
                        ],
                      ),
                      Text('('+(currentProduct.amount * currentProduct.prezzo_lordo).toStringAsFixed(2)+' €)', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              ),

            ],
          ),
        ),
      );
    });

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: tableRowList,
      ),
    );
  }

  String getNiceNumber(String string) {
    if(string.contains('.00')){
      return string.replaceAll('.00', '');
    }else if(string.contains('.0')){
      return string.replaceAll('.0', '');
    }else {
      return string;
    }
  }

  String getUserDetailsById(
      int fkUserId,
      int fkBranchId,
      Map<int, BundleUserStorageSupplier> currentMapBranchIdBundleSupplierStorageUsers) {

    String currentUserName = '';
    currentMapBranchIdBundleSupplierStorageUsers.forEach((key, value) {
      if(key == fkBranchId){
        value.userModelList.forEach((user) {
          if(user.id == fkUserId){
            currentUserName = user.name + ' ' + user.lastName;
          }
        });
      }
    });
    return currentUserName;
  }

  String buildDateFromMilliseconds(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return dateTime.day.toString() + '/' + dateTime.month.toString() + '/' + dateTime.year.toString();
  }

  @override
  void initState() {
    super.initState();
  }

  String calculateTotal(List<ProductOrderAmountModel> productList) {
    double total = 0.0;

    productList.forEach((element) {
      total = total + (element.amount * element.prezzo_lordo);
    });

    return total.toStringAsFixed(2).replaceAll('.00', '').replaceAll('.0', '');

  }

  buildProductListTotal(bool enableController) {
    List<Widget> tableRowList = [
    ];
    tableRowList.add(

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Totale (€)',
                maxLines: 1,
                softWrap: false,
                style: TextStyle(overflow: TextOverflow.fade,
                    fontWeight: FontWeight.w600,
                    fontSize: getProportionateScreenHeight(30),
                    color: kPrimaryColor),),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.loose(Size(
                  getProportionateScreenWidth(300),
                  getProportionateScreenWidth(60))),
              child: CupertinoTextField(
                decoration: BoxDecoration(
                    border: Border.all(color: enableController ? kPrimaryColor : Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                controller: totalController,
                enabled: enableController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
                clearButtonMode: OverlayVisibilityMode.never,
                textAlign: TextAlign.center,
                autocorrect: false,
              ),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: tableRowList,
      ),
    );
  }
  buildProductListTotalUpdate(bool enableController) {
    List<Widget> tableRowList = [
    ];
    tableRowList.add(

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Totale (€)',
                maxLines: 1,
                softWrap: false,
                style: TextStyle(overflow: TextOverflow.fade,
                    fontWeight: FontWeight.w600,
                    fontSize: getProportionateScreenHeight(30),
                    color: kPrimaryColor),),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.loose(Size(
                  getProportionateScreenWidth(300),
                  getProportionateScreenWidth(60))),
              child: CupertinoTextField(
                controller: controllerUpdate,
                enabled: enableController,
                onChanged: (text){
                  if(text == ''){
                    widget.orderModel.total = 0.0;
                  }else if(double.tryParse(text.replaceAll(',', '.')) != null){
                    widget.orderModel.total = double.tryParse(text.replaceAll(',', '.'));
                  }
                },
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                clearButtonMode: OverlayVisibilityMode.never,
                textAlign: TextAlign.center,
                autocorrect: false,
              ),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: tableRowList,
      ),
    );
  }
}
