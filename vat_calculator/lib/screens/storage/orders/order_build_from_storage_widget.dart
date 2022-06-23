import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/components/order_card.dart';

import '../../../client/vatservice/model/order_model.dart';
import '../../../client/vatservice/model/product_order_amount_model.dart';
import '../../../client/vatservice/model/utils/order_state.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../orders/components/screens/orders_utils.dart';

class OrderWidgetForStorage extends StatefulWidget {
  const OrderWidgetForStorage({@required this.supplierId, @required this.orderedMapBySuppliers});

  final int supplierId;
  final List<StorageProductModel> orderedMapBySuppliers;

  @override
  State<OrderWidgetForStorage> createState() => _OrderWidgetForStorageState();
}

class _OrderWidgetForStorageState extends State<OrderWidgetForStorage> {

  DateTime currentDate;
  bool orderSent = false;

  OrderModel currentOrderModelAfterSend;
  List<ProductOrderAmountModel> currentProductList = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              backgroundColor: Colors.black,
              dialogBackgroundColor: Colors.black,
              colorScheme: const ColorScheme.dark(
                onSurface: Colors.white,
                primary: Colors.white,
                secondary: kPrimaryColor,
                onSecondary: kPrimaryColor,
                background: kPrimaryColor,
                onBackground: kPrimaryColor,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.white, // button// text color
                ),
              ),
            ),
            child: child,
          );
        },

        helpText: "Seleziona data consegna",
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return builtIt( widget.supplierId, widget.orderedMapBySuppliers, dataBundleNotifier);
      },
    );
  }

  builtIt(int key, List<StorageProductModel> orderedMapBySuppliers, DataBundleNotifier dataBundleNotifier) {
    List<Widget> widgets = [
    ];
    widgets.add(Padding(
      padding: const EdgeInsets.all(18.0),
      child: Text(dataBundleNotifier.retrieveSupplierById(key), style: TextStyle(fontSize: getProportionateScreenHeight(25), color: kPrimaryColor, fontWeight: FontWeight.w700)),
    ));
    orderSent ? SizedBox(height: 0,) : orderedMapBySuppliers.forEach((element) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(right: 25, left: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(' - ' +element.productName.toString(), style: TextStyle(fontSize: getProportionateScreenHeight(20), color: kPrimaryColor, fontWeight: FontWeight.w700)),
            Row(
              children: [
                Text(element.unitMeasure.toString() + ' x ', style: TextStyle(fontSize: getProportionateScreenHeight(10), color: kPrimaryColor, fontWeight: FontWeight.w600)),
                Text(element.extra.toString(), style: TextStyle(fontSize: getProportionateScreenHeight(18), color: kPrimaryColor)),
              ],
            ),
          ],
        ),
      ));
    });
    if(orderSent){
      widgets.add(OrderCard(order: currentOrderModelAfterSend, orderIdProductList: currentProductList, showExpandedTile: false),);
    }else{
      widgets.add(currentDate == null ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: getProportionateScreenWidth(500),
          child: CupertinoButton(
            child:
            const Text('Seleziona data consegna'),
            color: kPrimaryColor,
            onPressed: () => _selectDate(context),
          ),
        ),
      ) : Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: getProportionateScreenWidth(500),
              child: CupertinoButton(
                child:
                Text(dateFormat.format(currentDate), style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: getProportionateScreenWidth(20))),
                color: kCustomPinkAccent,
                onPressed: () => _selectDate(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SizedBox(
                width: getProportionateScreenWidth(500),
                child: CupertinoButton(
                  child:
                  Text('Invia Ordine', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: getProportionateScreenWidth(20))),
                  color: kPrimaryColor,
                  onPressed: () async {
                    SupplierModel supplier = dataBundleNotifier.retrieveSupplierFromSupplierListById(widget.supplierId);
                    String code = DateTime.now().microsecondsSinceEpoch.toString().substring(3,16);

                    OrderModel order = OrderModel(
                        code: code,
                        details: 'Ordine eseguito da ' + dataBundleNotifier.userDetailsList[0].firstName + ' ' +
                            dataBundleNotifier.userDetailsList[0].lastName + ' per ' +
                            dataBundleNotifier.currentBranch.companyName + '. Da consegnare in ${dataBundleNotifier.currentStorage.address} a ${dataBundleNotifier.currentStorage.city} CAP: ${dataBundleNotifier.currentStorage.cap.toString()}.',
                        total: 0.0,
                        status: OrderState.SENT,
                        creation_date: dateFormat.format(DateTime.now()),
                        delivery_date: dateFormat.format(currentDate),
                        fk_branch_id: dataBundleNotifier.currentBranch.pkBranchId,
                        fk_storage_id: dataBundleNotifier.currentStorage.pkStorageId,
                        fk_user_id: dataBundleNotifier.userDetailsList[0].id,
                        pk_order_id: 0,
                        fk_supplier_id: widget.supplierId,
                        paid: 'false'
                    );
                    Response performSaveOrderId = await dataBundleNotifier.getclientServiceInstance().performSaveOrder(
                      orderModel: order
                    );

                    if(performSaveOrderId.statusCode == 200 && performSaveOrderId.data != 0){

                      Response sendEmailResponse = await dataBundleNotifier.getEmailServiceInstance().sendEmailServiceApi(
                          supplierName: supplier.nome,
                          branchName: dataBundleNotifier.currentBranch.companyName,
                          message: OrderUtils.buildMessageFromCurrentOrderList(
                            branchName: dataBundleNotifier.currentBranch.companyName,
                            orderId: code,
                            productList: dataBundleNotifier.currentProductModelListForSupplierDuplicated,
                            deliveryDate: getDayFromWeekDay(currentDate.weekday) + ' ' + currentDate.day.toString() + '/' + currentDate.month.toString() + '/' + currentDate.year.toString(),
                            supplierName: supplier.nome,
                            currentUserName: dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName,
                            storageAddress: dataBundleNotifier.currentStorage.address,
                            storageCap: dataBundleNotifier.currentStorage.cap,
                            storageCity: dataBundleNotifier.currentStorage.city,
                          ),
                          orderCode: code,
                          supplierEmail: supplier.mail,
                          userEmail: dataBundleNotifier.userDetailsList[0].email,
                          userName: dataBundleNotifier.userDetailsList[0].firstName,
                          addressBranch: dataBundleNotifier.currentStorage.address,
                          addressBranchCap: dataBundleNotifier.currentStorage.cap,
                          addressBranchCity: dataBundleNotifier.currentStorage.city,
                          branchNumber: dataBundleNotifier.userDetailsList[0].phone,
                          deliveryDate: getDayFromWeekDay(currentDate.weekday) + ' ' + currentDate.day.toString() + '/' + currentDate.month.toString() + '/' + currentDate.year.toString());

                      if (sendEmailResponse.statusCode == 200) {

                        print('Save product for order with id: ' + performSaveOrderId.toString());
                        if(performSaveOrderId != null){
                          orderedMapBySuppliers.forEach((element) async {
                            if(element.extra != 0){
                              await dataBundleNotifier.getclientServiceInstance().performSaveProductIntoOrder(
                                  element.extra,
                                  element.fkProductId,
                                  performSaveOrderId.data
                              );
                              setState((){
                                currentProductList.add(ProductOrderAmountModel(pkProductId: element.fkProductId,
                                    amount: element.extra,
                                    nome: element.productName,
                                    fkOrderId: performSaveOrderId.data,
                                    fkSupplierId: widget.supplierId,
                                    prezzo_lordo: element.price,
                                    unita_misura: element.unitMeasure
                                ));
                              });
                            }
                          });
                        }
                        if(performSaveOrderId != null){

                          String eventDatePretty = '${getDayFromWeekDay(currentDate.weekday)} ${currentDate.day.toString()} ${getMonthFromMonthNumber(currentDate.month)} ${currentDate.year.toString()}';
                          dataBundleNotifier.getclientMessagingFirebase().sendNotificationToTopic('branch-${dataBundleNotifier.currentBranch.pkBranchId.toString()}',
                              'Ordine per fornitore ${supplier.nome} da ricevere $eventDatePretty '
                                  'in via ${dataBundleNotifier.currentStorage.address} (${dataBundleNotifier.currentStorage.city})',
                              '${dataBundleNotifier.userDetailsList[0].firstName} ha creato un nuovo ordine', '');

                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              backgroundColor: Colors.green.withOpacity(0.8),
                              duration: Duration(milliseconds: 800),
                              content: Text('Ordine inviato correttamente tramite mail.')));

                          dataBundleNotifier.setTo0ExtraFieldAfterOrderPerform(widget.supplierId);

                          print('Retrieve product by order id: ' +performSaveOrderId.data.toString() );


                          setState((){
                            orderSent = true;
                            order.pk_order_id = performSaveOrderId.data;
                            currentOrderModelAfterSend = order;
                          });
                        }
                      }else{
                        dataBundleNotifier.getclientServiceInstance().deleteOrder(orderModel: OrderModel(pk_order_id: performSaveOrderId.data),actionModel:  null);
                      }
                    }
                  },
                ),
              ),
            ),

          ],
        ),
      ),);
    }

    widgets.add(const Divider(color: Colors.grey, height: 50, indent: 10, endIndent: 10,));
    return Column(
      children: widgets,
    );
  }
}
