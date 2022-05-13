import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/models/bundle_users_storage_supplier_forbranch.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/components/edit_order_underworking_screen.dart';
import 'package:vat_calculator/screens/orders/components/screens/orders_utils.dart';
import '../../../client/pdf/pdf_service.dart';
import '../../../client/vatservice/model/utils/order_state.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({Key key, @required this.order, @required this.orderIdProductList, @required this.showExpandedTile}) : super(key: key);

  final OrderModel order;
  final List<ProductOrderAmountModel> orderIdProductList;
  final bool showExpandedTile;

  @override
  Widget build(BuildContext context) {

    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return SizedBox(
          width: MediaQuery.of(context).size.width - 2,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: kPrimaryColor,
            elevation: 5,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderCompletionScreen(orderModel: order,
                  productList: orderIdProductList,),),);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 6, 0),
                                  child: ClipRect(
                                    child: SvgPicture.asset(
                                      'assets/icons/receipt.svg',
                                      height: getProportionateScreenHeight(40),
                                      color: kCustomBlue,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(dataBundleNotifier.getSupplierName(order.fk_supplier_id),
                                      style: TextStyle(fontSize: getProportionateScreenHeight(13), color: Colors.white, overflow: TextOverflow.clip,fontWeight: FontWeight.bold),),
                                    Text(
                                      '#' + order.code,
                                      style: TextStyle(fontSize: getProportionateScreenHeight(11), color: Colors.white, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ],
                            ),

                          ],

                        ),

                        Row(
                          children: [
                            IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/textmessage.svg',
                                  height: getProportionateScreenHeight(25),
                                ),
                                onPressed: () {
                                  String message = OrderUtils.buildMessageFromCurrentOrderListFromDraft(
                                      branchName: dataBundleNotifier.currentBranch.companyName,
                                      orderId: order.code,
                                      orderProductList: orderIdProductList,
                                      deliveryDate: getDayFromWeekDay(DateTime.fromMillisecondsSinceEpoch(order.delivery_date).weekday) + ' ' + DateTime.fromMillisecondsSinceEpoch(order.delivery_date).day.toString() + '/' + DateTime.fromMillisecondsSinceEpoch(order.delivery_date).month.toString() + '/' + DateTime.fromMillisecondsSinceEpoch(order.delivery_date).year.toString(),
                                      supplierName: dataBundleNotifier.getSupplierName(order.fk_supplier_id),
                                      currentUserName: dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName,
                                      storageAddress: dataBundleNotifier.getStorageModelById(order.fk_storage_id).address,
                                      storageCap: dataBundleNotifier.getStorageModelById(order.fk_storage_id).cap,
                                      storageCity: dataBundleNotifier.getStorageModelById(order.fk_storage_id).city);

                                  print('Message to send vrvrve: ' + message);
                                  SupplierModel supplierNumber = dataBundleNotifier.getSupplierFromList(order.fk_supplier_id);

                                  message = message.replaceAll('#', '');
                                  message = message.replaceAll('<br>', '\n');
                                  message = message.replaceAll('</h4>', '');
                                  message = message.replaceAll('<h4>', '');

                                  launch('sms:${refactorNumber(supplierNumber.tel)}?body=$message');
                                }
                            ),
                            IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/ws.svg',
                                  height: getProportionateScreenHeight(25),
                                ),
                                onPressed: () async {
                                  String message = OrderUtils.buildMessageFromCurrentOrderListFromDraft(
                                      branchName: dataBundleNotifier.currentBranch.companyName,
                                      orderId: order.code,
                                      orderProductList: orderIdProductList,
                                      deliveryDate: getDayFromWeekDay(DateTime.fromMillisecondsSinceEpoch(order.delivery_date).weekday) + ' ' + DateTime.fromMillisecondsSinceEpoch(order.delivery_date).day.toString() + '/' + DateTime.fromMillisecondsSinceEpoch(order.delivery_date).month.toString() + '/' + DateTime.fromMillisecondsSinceEpoch(order.delivery_date).year.toString(),
                                      supplierName: dataBundleNotifier.getSupplierName(order.fk_supplier_id),
                                      currentUserName: dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName,
                                      storageAddress: dataBundleNotifier.getStorageModelById(order.fk_storage_id).address,
                                      storageCap: dataBundleNotifier.getStorageModelById(order.fk_storage_id).cap,
                                      storageCity: dataBundleNotifier.getStorageModelById(order.fk_storage_id).city);

                                  SupplierModel supplierNumber = dataBundleNotifier.getSupplierFromList(order.fk_supplier_id);

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

                                  print(message);
                                  String urlString = 'https://api.whatsapp.com/send/?phone=${refactorNumber(supplierNumber.tel)}&text=$message';
                                  if(Platform.isIOS){
                                    if (await canLaunch(urlString)) {
                                      await launch(urlString);
                                    } else {
                                      Scaffold.of(context).showSnackBar(SnackBar(
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
                            IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/pdf.svg',
                                  height: getProportionateScreenHeight(25),
                                ),
                                onPressed: () {
                                  PdfService pdfService = PdfService();
                                  pdfService.generatePdfOrderAndOpenOnDevide(
                                      order,
                                      orderIdProductList,
                                  dataBundleNotifier.currentBranch);
                                }
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '  Data Consegna: ',
                          style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                        Text(
                          DateTime.fromMillisecondsSinceEpoch(order.delivery_date).day.toString() + '/' +
                          DateTime.fromMillisecondsSinceEpoch(order.delivery_date).month.toString() + '/' +
                          DateTime.fromMillisecondsSinceEpoch(order.delivery_date).year.toString(),
                          style: TextStyle(fontSize: getProportionateScreenHeight(13), color: Colors.white, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '  Stato: ',
                          style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                        Text(
                          order.status,
                          style: TextStyle(fontSize: getProportionateScreenHeight(13), color: OrderState.getStatusOrderColor(order.status), fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Prodotti',
                              style: TextStyle(
                                color: kCustomWhite,
                                fontSize: getProportionateScreenHeight(13),),
                            ),
                            Text(orderIdProductList == null ? '0' : orderIdProductList.length.toString(),
                              style: TextStyle(
                                  color: kCustomWhite,
                                  fontSize: getProportionateScreenHeight(15),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Prezzo Stimato',
                              style: TextStyle(
                                  color: kCustomWhite,
                                  fontSize: getProportionateScreenHeight(10), fontWeight: FontWeight.bold),
                            ),
                            Text(
                              dataBundleNotifier.currentBranch.accessPrivilege == Privileges.EMPLOYEE ? ' *** ' : '€ ' +
                                  calculatePriceFromProductList(
                                      orderIdProductList),
                              style: TextStyle(
                                  color: kCustomWhite,
                                  fontSize: getProportionateScreenHeight(15),
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Divider(
                      color: Colors.white,
                    ),
                    showExpandedTile ? ExpansionTile(
                      textColor: kCustomWhite,
                      collapsedIconColor: kCustomWhite,
                      iconColor: kCustomWhite,

                      title: Text(
                        'Mostra Dettagli',
                        style: TextStyle(
                            color: kCustomWhite,
                            fontSize: getProportionateScreenHeight(13)),
                      ),
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: getProportionateScreenWidth(10),),
                                const Text('Creato da: ', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomWhite),),
                              ],
                            ),
                            Row(
                              children: [
                                Text(getUserDetailsById(order.fk_user_id, order.fk_branch_id,
                                    dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers),
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
                                SizedBox(width: getProportionateScreenWidth(10),),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: getProportionateScreenWidth(10),),
                                const Text('Stato: ', style: TextStyle(fontWeight: FontWeight.bold ,color: kCustomWhite),),
                              ],
                            ),
                            Row(
                              children: [
                                Text(order.status,
                                  style: TextStyle(color: Colors.green),),
                                SizedBox(width: getProportionateScreenWidth(10),),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: getProportionateScreenWidth(10),),
                                Text('Effettuato: ', style: const TextStyle(fontWeight: FontWeight.bold,color: kCustomWhite),),
                              ],
                            ),
                            Row(
                              children: [
                                Text(getStringDateFromDateTime(DateTime.fromMillisecondsSinceEpoch(order.creation_date)),
                                  style: TextStyle(color: Colors.green, fontSize: getProportionateScreenHeight(14)),),
                                SizedBox(width: getProportionateScreenWidth(10),),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: getProportionateScreenWidth(10),),
                                const Text('Consegna: ', style: TextStyle(fontWeight: FontWeight.bold,color: kCustomWhite),),
                              ],
                            ),
                            Row(
                              children: [
                                Text(getStringDateFromDateTime(DateTime.fromMillisecondsSinceEpoch(order.delivery_date)),
                                  style: TextStyle(color: Colors.green, fontSize: getProportionateScreenHeight(14)),),
                                SizedBox(width: getProportionateScreenWidth(10),),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(20),),
                        const Text('Carrello'),
                        buildProductListWidget(orderIdProductList, dataBundleNotifier),
                        SizedBox(height: getProportionateScreenHeight(20),),
                      ],
                    ) : SizedBox(width: 0,),
                    SizedBox(
                      width: getProportionateScreenWidth(400),
                      child: CupertinoButton(
                        color: kCustomBlue,
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderCompletionScreen(orderModel: order,
                            productList: orderIdProductList,),),);
                        },
                        child: Text('Completa Ordine'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String calculatePriceFromProductList(List<ProductOrderAmountModel> orderIdProductListMap) {
    double total = 0.0;

    if(orderIdProductListMap != null && orderIdProductListMap.isNotEmpty){
      orderIdProductListMap.forEach((currentProduct) {
        total = total + (currentProduct.amount * currentProduct.prezzo_lordo);
      });
    }
    return total.toStringAsFixed(2);
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

  buildProductListWidget(List<ProductOrderAmountModel> productList,
      DataBundleNotifier dataBundleNotifier) {

    List<Row> rows = [];
    productList.forEach((element) {
      if(element.amount > 0){
        TextEditingController controller = TextEditingController(text: element.amount.toString());
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: getProportionateScreenWidth(200),
                    child: Text(element.nome, overflow: TextOverflow.clip, style: TextStyle(fontSize: getProportionateScreenWidth(16),color: kCustomWhite),),
                  ),
                  Row(
                    children: [
                      Text(element.prezzo_lordo.toString() + ' €', style: TextStyle(fontSize: getProportionateScreenWidth(9),color: kCustomWhite),),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(FontAwesomeIcons.dotCircle, size: getProportionateScreenWidth(3),color: kCustomOrange),
                      ),
                      Text(element.unita_misura, style: TextStyle(fontSize: getProportionateScreenWidth(11),color: Colors.green),),

                    ],
                  ),
                ],
              ),
              ConstrainedBox(
                constraints: BoxConstraints.loose(Size(getProportionateScreenWidth(70), getProportionateScreenWidth(60))),
                child: CupertinoTextField(
                  enabled: false,
                  controller: controller,
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  clearButtonMode: OverlayVisibilityMode.never,
                  textAlign: TextAlign.center,
                  autocorrect: false,
                ),
              ),
            ],
          ),
        );
      }
    });

    return Column(
      children: rows,
    );
  }

}
