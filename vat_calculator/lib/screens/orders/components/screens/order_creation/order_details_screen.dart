import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:csc_picker/dropdown_with_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import '../../../../../swagger/swagger.enums.swagger.dart';
import '../../../../../swagger/swagger.models.swagger.dart';
import 'order_sent_details_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  static String routeName = 'order_details';

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {

        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () async {
                    String messageToSend = OrderUtils.buildWhatsAppMessageFromCurrentOrderList(
                      branchName: dataBundleNotifier.getCurrentBranch().name!,
                      orderId: dataBundleNotifier.getOrderToReview().orderId!.toString(),
                      productList: builRProductFromProductIntoOrder(dataBundleNotifier.getOrderToReview().products!),
                      deliveryDate: dataBundleNotifier.getOrderToReview().deliveryDate!,
                      supplierName: dataBundleNotifier.getSupplierNameById(dataBundleNotifier.getOrderToReview().supplierId!),
                      storageAddress: dataBundleNotifier.getCurrentStorage().address!,
                      storageCity: dataBundleNotifier.getCurrentStorage().city!,
                      storageCap: dataBundleNotifier.getCurrentStorage().cap!,
                      currentUserName: dataBundleNotifier.getUserEntity()!.name! + ' ' + dataBundleNotifier.getUserEntity()!.lastname!,
                    );

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

                    String urlString = 'https://api.whatsapp.com/send/?phone=${refactorNumber(dataBundleNotifier.getCurrentBranch().suppliers
                    !.where((element) => element.supplierId == dataBundleNotifier.getOrderToReview().supplierId!).first.phoneNumber!)}&text=$messageToSend';


                      if(Platform.isIOS){
                        if (await canLaunch(urlString)) {
                          await launch(urlString);
                        }
                      }
                      else{
                      await launch(urlString);
                      }


                  }, icon: SvgPicture.asset(
                    'assets/icons/ws.svg',
                    height: getProportionateScreenHeight(26),
                  ),
                ),
              )
            ],
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => {
                  Navigator.of(context).pop(),
                }),
            iconTheme: const IconThemeData(color: kCustomGrey),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              'Dettaglio Ordine',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(19),
                color: kCustomGrey,
              ),
            ),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: buildProductPage(dataBundleNotifier),
            ),
          ),
        );
      },
    );
  }

  buildProductPage(DataBundleNotifier dataBundleNotifier) {
    List<Widget> list = [];

    list.add( Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Card(
            child: Column(
              children: [
                Text(dataBundleNotifier.getSupplierNameById(dataBundleNotifier.getOrderToReview().supplierId!), style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(25),
                    color: kCustomGrey),),
                const Divider(endIndent: 40, indent: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('  Creato da: ', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(dataBundleNotifier.getOrderToReview().senderUser!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('  In data: ', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(getFormtDateToReadeableItalianDate(dataBundleNotifier.getOrderToReview().creationDate!), style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen),),
                  ],
                ),

                SizedBox(height: 20,),
                Text('Magazzino', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey, fontSize: 10),),
                Text(dataBundleNotifier.getCurrentBranch()!.storages!.where((element) => element.storageId == dataBundleNotifier.getOrderToReview().storageId).first.name!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey, fontSize: 27),),

                Divider(endIndent: 40, indent: 40, height: getProportionateScreenHeight(30),),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('  Da consegnare a: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(dataBundleNotifier.getCurrentBranch().name! + ' ', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('  Da consegnare in data: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(getFormtDateToReadeableItalianDate(dataBundleNotifier.getOrderToReview().deliveryDate!), style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('  In via: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(dataBundleNotifier.getCurrentBranch()!.address!+ ' ', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('  Città: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(dataBundleNotifier.getCurrentBranch().city! + ' ', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('  CAP : ', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(dataBundleNotifier.getCurrentBranch().cap! + ' ', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen),),
                      ],
                    ),
                    Divider(endIndent: 40, indent: 40, height: getProportionateScreenHeight(30),),
                  ],
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    ),);
    list.add(Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Stato Ordine', style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenWidth(15), fontWeight: FontWeight.bold), ),
          ),
          CupertinoButton(
            child: Text(orderEntityOrderStatusToJson(dataBundleNotifier.getOrderToReview().orderStatus!)!, style: TextStyle(color: getColorByOrderStatus(dataBundleNotifier.getOrderToReview().orderStatus!), fontWeight: FontWeight.bold),),
            onPressed: (){

            },
          ),
        ],
      ),
    ));

    list.add(Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Carrello', style: TextStyle(color: kCustomGreen, fontSize: getProportionateScreenWidth(15), fontWeight: FontWeight.bold), ),
          ),
          CupertinoButton(
            child: const Text('', style: TextStyle(color: Colors.black54),),
            onPressed: (){

            },
          ),
        ],
      ),
    ));
    for (var currentProduct in dataBundleNotifier.getOrderToReview()!.products!) {
      TextEditingController controller = TextEditingController(text: currentProduct.amount.toString());

      if(currentProduct.amount != 0){
        list.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: getProportionateScreenWidth(220),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentProduct.productName!, style: TextStyle(color: Colors.black, fontSize: getProportionateScreenWidth(15)),),
                        Text(currentProduct.unitMeasure!, style: TextStyle( fontSize: getProportionateScreenWidth(12))),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints.loose(Size(
                            getProportionateScreenWidth(70),
                            getProportionateScreenWidth(60))),
                        child: CupertinoTextField(
                          controller: controller,
                          enabled: false,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          clearButtonMode: OverlayVisibilityMode.never,
                          textAlign: TextAlign.center,
                          autocorrect: false,
                        ),
                      ),
//
                    ],
                  ),
                ],
              ),
            )
        );
      }
    }

    list.add(const SizedBox(
      height: 100,
    ));
    return list;
  }

  Color getColorByOrderStatus(OrderEntityOrderStatus orderStatus) {
    switch(orderStatus){
      case OrderEntityOrderStatus.nonInviato:
        return kCustomBordeaux;
      case OrderEntityOrderStatus.inviato:
        return kCustomGreen;
      default:
        return kCustomGrey;
    }
  }

  List<ROrderProduct> builRProductFromProductIntoOrder(List<ROrderProduct> list) {
    List<ROrderProduct> rOrderProd = [];

    for (ROrderProduct prod in list) {
      rOrderProd.add(ROrderProduct(
        amount: prod.amount,
        productName: prod.productName,
        unitMeasure: prod.unitMeasure,
        price: prod.price,
        orderProductId: 0,
        productId: prod.productId
      ));
    }

    return rOrderProd;
  }
}

class OrderUtils{

  static buildWhatsAppMessageFromCurrentOrderList({
    required List<ROrderProduct> productList,
    required String branchName,
    required String orderId,
    required String supplierName,
    required String storageAddress,
    required String storageCity,
    required String storageCap,
    required String deliveryDate,
    required String currentUserName}) {

    String orderString = 'Ciao $supplierName,%0a%0aOrdine #$orderId%0a%0aCarrello%0a----------------%0a';
    productList.forEach((currentProductOrderAmount) {
      if(currentProductOrderAmount.amount != 0){
        orderString = orderString + currentProductOrderAmount.productName! +
            ' x ' + currentProductOrderAmount.amount.toString() + ' ${currentProductOrderAmount.unitMeasure} %0a';
      }
    });
    orderString = orderString + '----------------';
    orderString = orderString + '%0a%0aDa consegnare $deliveryDate%0aa $storageCity ($storageCap)%0ain via: $storageAddress.';
    orderString = orderString + '%0a%0aCordiali Saluti%0a${currentUserName}%0a%0a$branchName';
    return orderString;
  }
}
