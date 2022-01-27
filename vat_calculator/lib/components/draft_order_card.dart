import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/models/bundle_users_storage_supplier_forbranch.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/components/edit_order_underworking_screen.dart';

import '../constants.dart';
import '../size_config.dart';

class DraftOrderCard extends StatelessWidget {
  const DraftOrderCard({Key key, @required this.order, @required this.orderIdProductListMap, @required this.showExpandedTile}) : super(key: key);

  final OrderModel order;
  final Map<int, List<ProductOrderAmountModel>> orderIdProductListMap;
  final bool showExpandedTile;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return ClipRect(
          child: Banner(
            color: Colors.green.shade800.withOpacity(0.7),
            message: order.status,
            location: BannerLocation.topEnd,
            child: Card(
              color: kPrimaryColor,
              elevation: 5,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderCompletionScreen(orderModel: order,
                    productList: orderIdProductListMap[order.pk_order_id],),),);
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
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(6, 5, 6, 0),
                                child: SvgPicture.asset(
                                  'assets/icons/supplier.svg',
                                  height: getProportionateScreenHeight(39),
                                  color: kCustomYellow800,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dataBundleNotifier.getSupplierName(order.fk_supplier_id),
                                    style: TextStyle(fontSize: getProportionateScreenHeight(17), color: kCustomYellow800, fontWeight: FontWeight.bold),),
                                  Text(
                                    '#' + order.code,
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite, fontWeight: FontWeight.bold),),
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
                                  onPressed: () => {
                                    //launch('sms:${refactorNumber(number)}?body=$message');
                                  }
                              ),
                              IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/icons/ws.svg',
                                    height: getProportionateScreenHeight(25),
                                  ),
                                  onPressed: () => {
                                    //launch('https://api.whatsapp.com/send/?phone=${refactorNumber(number)}&text=$message');
                                  }
                              ),
                              IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/icons/pdf.svg',
                                    height: getProportionateScreenHeight(25),
                                  ),
                                  onPressed: () => {
                                    //launch('https://api.whatsapp.com/send/?phone=${refactorNumber(number)}&text=$message');
                                  }
                              ),
                              SizedBox(width: getProportionateScreenWidth(4),),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: kCustomYellow800,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Prodotti',
                                style: TextStyle(
                                  color: kCustomYellow800,
                                  fontSize: getProportionateScreenHeight(13),),
                              ),
                              Text(orderIdProductListMap[order.pk_order_id] == null ? '0' : orderIdProductListMap[order.pk_order_id].length.toString(),
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
                                    color: kCustomYellow800,
                                    fontSize: getProportionateScreenHeight(10), fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '€ ' +
                                    calculatePriceFromProductList(
                                        orderIdProductListMap[
                                        order.pk_order_id]),
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
                        color: kCustomYellow800,
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
                                    style: TextStyle(fontWeight: FontWeight.bold, color: kCustomYellow800),),
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
                                    style: TextStyle(color: kCustomYellow800),),
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
                                    style: TextStyle(color: kCustomYellow800, fontSize: getProportionateScreenHeight(14)),),
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
                                    style: TextStyle(color: kCustomYellow800, fontSize: getProportionateScreenHeight(14)),),
                                  SizedBox(width: getProportionateScreenWidth(10),),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(20),),
                          const Text('Carrello'),
                          buildProductListWidget(orderIdProductListMap[order.pk_order_id], dataBundleNotifier),
                          SizedBox(height: getProportionateScreenHeight(20),),
                        ],
                      ) : SizedBox(width: 0,),
                      SizedBox(
                        width: getProportionateScreenWidth(400),
                        child: CupertinoButton(
                          color: kCustomYellow800,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderCompletionScreen(orderModel: order,
                              productList: orderIdProductListMap[order.pk_order_id],),),);
                          },
                          child: Text('Completa Ordine'),
                        ),
                      ),
                    ],
                  ),
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
                    Text(element.unita_misura, style: TextStyle(fontSize: getProportionateScreenWidth(8),color: kCustomWhite),),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(FontAwesomeIcons.dotCircle, size: getProportionateScreenWidth(3),color: kCustomYellow800),
                    ),
                    Text(element.prezzo_lordo.toString() + ' €', style: TextStyle(fontSize: getProportionateScreenWidth(8),color: kCustomWhite),),
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
    });

    return Column(
      children: rows,
    );
  }

}
