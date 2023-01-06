import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:csc_picker/dropdown_with_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import '../../../../../swagger/swagger.enums.swagger.dart';
import '../../../../../swagger/swagger.models.swagger.dart';
import 'order_sent_details_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({Key? key, required this.currentSupplier}) : super(key: key);

  static String routeName = 'orderconfirmationscreen';

  final Supplier currentSupplier;

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {

  String _selectedStorage = 'Seleziona Magazzino';
  Storage currentStorageModel = Storage(storageId: 0, name: '', creationDate: '', address: '', city: '', cap: '0');

  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {

        return LoaderOverlay(
          useDefaultLoading: false,
          overlayOpacity: 0.9,
          overlayWidget: const LoaderOverlayWidget(message: 'Invio ordine in corso...',),
          child: Scaffold(
            bottomSheet: Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
              child: DefaultButton(
                text: ''
                    'Conferma ed Invia',
                press: () async {

                  print('Performing send order ...');
                  if(_selectedStorage == 'Seleziona Magazzino'){
                    context.loaderOverlay.hide();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        backgroundColor: Colors.redAccent.withOpacity(0.8),
                        duration: const Duration(milliseconds: 800),
                        content: const Text('Selezionare il magazzino')));
                  }else if(currentStorageModel.storageId == 0){
                    context.loaderOverlay.hide();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        backgroundColor: Colors.redAccent.withOpacity(0.8),
                        duration: const Duration(milliseconds: 800),
                        content: const Text('Selezionare il magazzino')));
                  } else{

                    context.loaderOverlay.show();
                    try{
                      Response sendOrderReponse = await dataBundleNotifier.getSwaggerClient().apiV1AppOrderSendPost(
                          orderEntity: OrderEntity(
                            branchId: dataBundleNotifier.getCurrentBranch().branchId!.toInt(),
                            supplierId: widget.currentSupplier.supplierId!.toInt(),
                            creationDate: dateFormat.format(DateTime.now()),
                            deliveryDate: dateFormat.format(currentDate),
                            details: '',
                            closedBy: '',
                            products: dataBundleNotifier.basket,
                            code: '',
                            total: dataBundleNotifier.calculateTotalFromBasket()!,
                            senderUser: dataBundleNotifier.getUserEntity()!.name! + ' ' + dataBundleNotifier.getUserEntity()!.lastname!,
                            storageId: currentStorageModel.storageId!.toInt(),
                          )
                      );

                      if(sendOrderReponse.isSuccessful){

                        OrderEntity orderSaved = sendOrderReponse.body;

                        print(orderSaved.orderStatus.toString());
                        if(orderSaved.orderStatus == OrderEntityOrderStatus.inviato){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderSentDetailsScreen(
                                  orderSent: orderSaved,
                                  mail: widget.currentSupplier.email!,
                                  message: OrderUtils.buildWhatsAppMessageFromCurrentOrderList(
                                    branchName: dataBundleNotifier.getCurrentBranch().name!,
                                    orderId: orderSaved.orderId.toString(),
                                    productList: dataBundleNotifier.basket,
                                    deliveryDate: getDayFromWeekDay(currentDate.weekday) + ' ' + currentDate.day.toString() + '/' + currentDate.month.toString() + '/' + currentDate.year.toString(),
                                    supplierName: widget.currentSupplier.name!,
                                    storageAddress: currentStorageModel.address!,
                                    storageCity: currentStorageModel.city!,
                                    storageCap: currentStorageModel.cap!,
                                    currentUserName: dataBundleNotifier.getUserEntity()!.name! + ' ' + dataBundleNotifier.getUserEntity()!.lastname!,
                                  ),
                                  orderStatus: orderSaved.orderStatus!,
                                  orderStatusMessage: orderSaved.errorMessage == null ? '' : orderSaved.errorMessage!,
                                  number: widget.currentSupplier.phoneNumber!,
                                  supplierName: widget.currentSupplier.name!,
                                ),
                              ));

                          dataBundleNotifier.refreshCurrentBranchData();
                        }else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderSentDetailsScreen(
                                  orderSent: orderSaved,
                                  mail: widget.currentSupplier.email!,
                                  message: OrderUtils.buildWhatsAppMessageFromCurrentOrderList(
                                    branchName: dataBundleNotifier.getCurrentBranch().name!,
                                    orderId: orderSaved.orderId.toString(),
                                    productList: dataBundleNotifier.basket,
                                    deliveryDate: getDayFromWeekDay(currentDate.weekday) + ' ' + currentDate.day.toString() + '/' + currentDate.month.toString() + '/' + currentDate.year.toString(),
                                    supplierName: widget.currentSupplier.name!,
                                    storageAddress: currentStorageModel.address!,
                                    storageCity: currentStorageModel.city!,
                                    storageCap: currentStorageModel.cap!,
                                    currentUserName: dataBundleNotifier.getUserEntity()!.name! + ' ' + dataBundleNotifier.getUserEntity()!.lastname!,
                                  ),
                                  orderStatus: orderSaved.orderStatus!,
                                  orderStatusMessage: orderSaved.errorMessage!,
                                  number: widget.currentSupplier.phoneNumber!,
                                  supplierName: widget.currentSupplier.name!,
                                ),
                              ));
                          dataBundleNotifier.refreshCurrentBranchData();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent.withOpacity(0.8),
                              duration: const Duration(milliseconds: 2800),
                              content: Text('Impossibile inviare ordine. Errore : ' + orderSaved.errorMessage!.toString())));
                        }
                      }else{
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                            backgroundColor: Colors.redAccent.withOpacity(0.8),
                            duration: const Duration(milliseconds: 2800),
                            content: Text('Impossibile inviare ordine. Errore : ' + sendOrderReponse.error!.toString())));
                            print(sendOrderReponse.error.toString());
                  }
                  }catch(e){
                  print(e.toString());
                  }finally{
                  context.loaderOverlay.hide();
                  }

                }
                },
                color: kCustomGreen, textColor: Colors.white,
              ),
            ),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                  }),
              iconTheme: const IconThemeData(color: kCustomGrey),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Conferma Ordine',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(19),
                  color: kCustomGrey,
                ),
              ),
              elevation: 0,
            ),
            body: Column(
              children: buildProductPage(dataBundleNotifier, widget.currentSupplier),
            ),
          ),
        );
      },
    );
  }

  buildProductPage(DataBundleNotifier dataBundleNotifier, Supplier supplier) {
    List<Widget> list = [];

    list.add( Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Card(
            child: Column(
              children: [
                Text(widget.currentSupplier.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(25),
                    color: kCustomGrey),),
                const Divider(endIndent: 40, indent: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('  Creato da: ', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(dataBundleNotifier.getUserEntity()!.name! + ' ' + dataBundleNotifier.getUserEntity()!.lastname! + '  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('  In data: ', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(buildDateFromMilliseconds(DateTime.now().millisecondsSinceEpoch)
                        + '  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Selezionare il magazzino a cui consegnare l\'ordine: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900.withOpacity(0.6), fontSize: 7),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: DropdownWithSearch(
                      title: 'Seleziona Magazzino',
                      placeHolder: 'Ricerca Magazzino',
                      disabled: false,
                      items: dataBundleNotifier.getCurrentBranch().storages!.map((Storage storageModel) {
                        return storageModel!.name!;
                      }).toList(),
                      selected: _selectedStorage,
                      onChanged: (storage) {
                        setCurrentStorage(dataBundleNotifier.getCurrentBranch().storages!.where((element) => element.name == storage).first);
                      }, label: '',
                    ),
                  ),
                ),
                Divider(endIndent: 40, indent: 40, height: getProportionateScreenHeight(30),),
                _selectedStorage == 'Seleziona Magazzino' ? const SizedBox(height: 0,) : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('  Da consegnare a: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(dataBundleNotifier.getCurrentBranch().name! + ' ', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('  In via: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(dataBundleNotifier.getCurrentBranch()!.address!+ ' ', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('  Città: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(dataBundleNotifier.getCurrentBranch().city! + ' ', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('  CAP : ', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(dataBundleNotifier.getCurrentBranch().cap! + ' ', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey),),
                      ],
                    ),
                    Divider(endIndent: 40, indent: 40, height: getProportionateScreenHeight(30),),
                  ],
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      currentDate == null ? SizedBox(
                        width: getProportionateScreenHeight(350),
                        child: CupertinoButton(
                          child:
                          const Text('Seleziona data consegna'),
                          color: kCustomGrey,
                          onPressed: () => _selectDate(context),
                        ),
                      ) : SizedBox(height: 0,),
                      currentDate == null
                          ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(''),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CupertinoButton(
                            child:
                            Text(buildDateFromMilliseconds(currentDate.millisecondsSinceEpoch), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                            color: kCustomGrey,
                            onPressed: () => _selectDate(context),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Una volta confermato l\'ordine verrà inviata una mail a ${widget.currentSupplier.email}.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, ),),
                      ),
                    ],
                  ),
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
            child: Text('Carrello', style: TextStyle(color: kCustomGreen, fontSize: getProportionateScreenWidth(15), fontWeight: FontWeight.bold), ),
          ),
          CupertinoButton(
            child: const Text('Modifica', style: TextStyle(color: Colors.black54),),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ));
    for (var currentProduct in dataBundleNotifier.basket) {
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

    return list;
  }

  void setCurrentStorage(Storage storage) {
    setState(() {
      _selectedStorage = storage.name!;
      currentStorageModel = storage;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              backgroundColor: Colors.black,
              dialogBackgroundColor: Colors.black,
              colorScheme: const ColorScheme.dark(
                onSurface: Colors.white,
                primary: Colors.white,
                secondary: kCustomGrey,
                onSecondary: kCustomGrey,
                background: kCustomGrey,
                onBackground: kCustomGrey,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.white, // button// text color
                ),
              ),
            ),
            child: child!,
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

  String buildDateFromMilliseconds(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return getDayFromWeekDay(dateTime.weekday) + ' ' + dateTime.day.toString() + ' ' + getMonthFromMonthNumber(dateTime.month) + ' ' + dateTime.year.toString();
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
