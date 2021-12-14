import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/components/screens/orders_utils.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import 'package:vat_calculator/size_config.dart';

class EditDraftOrderScreen extends StatefulWidget {
  const EditDraftOrderScreen({
    Key key,
    this.orderModel,
    this.productList,
  }) : super(key: key);

  final OrderModel orderModel;
  final List<ProductOrderAmountModel> productList;

  @override
  State<EditDraftOrderScreen> createState() => _EditDraftOrderScreenState();
}

class _EditDraftOrderScreenState extends State<EditDraftOrderScreen> {
  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2020),
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
        builder: (context, dataBundleNotifier, child) {
      return LoaderOverlay(
        useDefaultLoading: false,
        overlayOpacity: 0.9,
        overlayWidget: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: getProportionateScreenHeight(130),
                width: getProportionateScreenWidth(250),
                child: Card(
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(15),
                          ),
                          SpinKitRing(
                            lineWidth: 3,
                            color: kPrimaryColor,
                            size: getProportionateScreenHeight(50),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(4),
                          ),
                          const Text('Invio ordine in corso..'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        child: Scaffold(
          bottomSheet: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CupertinoButton(
                  child: Text(
                    'Invia',
                    style: const TextStyle(color: Colors.green),
                  ),
                  onPressed: () async {
                    if (currentDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(milliseconds: 5000),
                          backgroundColor: Colors.red,
                          content: Text(
                            'Selezionare la data di consegna ordine',
                            style: TextStyle(
                                fontFamily: 'LoraFont', color: Colors.white),
                          )));
                    } else {
                      print('Invio mail');

                      String currentSupplierEmail = '';
                      String currentSupplierName = '';
                      dataBundleNotifier.currentListSuppliers
                          .forEach((supplier) {
                        if (supplier.pkSupplierId ==
                            widget.orderModel.fk_supplier_id) {
                          currentSupplierEmail = supplier.mail;
                          currentSupplierName = supplier.nome;
                        }
                      });

                      Response sendEmailResponse = await dataBundleNotifier.getEmailServiceInstance().sendEmail(
                              supplierName: currentSupplierName,
                              branchName: dataBundleNotifier.currentBranch.companyName,
                              message: OrderUtils.buildMessageFromCurrentOrder(widget.productList),
                              orderCode: widget.orderModel.code,
                              supplierEmail: currentSupplierEmail,
                              userEmail: dataBundleNotifier.dataBundleList[0].email,
                              userName: dataBundleNotifier.dataBundleList[0].firstName,
                              addressBranch: dataBundleNotifier.currentBranch.address + ' ' + dataBundleNotifier.currentBranch.city + ' ' + dataBundleNotifier.currentBranch.cap.toString(),
                              deliveryDate: getDayFromWeekDay(currentDate.weekday) + ' ' + currentDate.day.toString() + '/' + currentDate.month.toString() + '/' + currentDate.year.toString());

                      if (sendEmailResponse.data == 'OK') {
                        await dataBundleNotifier
                            .getclientServiceInstance()
                            .updateOrderStatus(
                                orderModel: OrderModel(
                                    pk_order_id: widget.orderModel.pk_order_id,
                                    status: OrderState.SENT,
                                    delivery_date:
                                        currentDate.millisecondsSinceEpoch,
                                    closedby: dataBundleNotifier
                                        .retrieveNameLastNameCurrentUser()),
                                actionModel: ActionModel(
                                    date: DateTime.now().millisecondsSinceEpoch,
                                    description:
                                        'Ha inviato l\'ordine #${widget.orderModel.code} '
                                        'al fornitore ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)}. ',
                                    fkBranchId: dataBundleNotifier
                                        .currentBranch.pkBranchId,
                                    user: dataBundleNotifier
                                        .retrieveNameLastNameCurrentUser(),
                                    type: ActionType.SENT_ORDER));
                        dataBundleNotifier
                            .setCurrentBranch(dataBundleNotifier.currentBranch);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrdersScreen(),
                          ),
                        );
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  content: Builder(
                                    builder: (context) {
                                      var height =
                                          MediaQuery.of(context).size.height;
                                      var width =
                                          MediaQuery.of(context).size.width;
                                      return SizedBox(
                                        height: height - 250,
                                        width: width - 90,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10.0)),
                                                  color: kPrimaryColor,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '  Errore invio ordine',
                                                          style: TextStyle(
                                                            fontSize:
                                                                getProportionateScreenWidth(
                                                                    20),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: kCustomWhite,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.clear,
                                                            color: kCustomWhite,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // buildDateList(),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ));
                      }
                    }
                  }),
              CupertinoButton(
                  child: const Text(
                    'Cancella Bozza',
                    style: TextStyle(color: kPinaColor),
                  ),
                  onPressed: () async {
                    await dataBundleNotifier
                        .getclientServiceInstance()
                        .deleteOrder(
                            orderModel: widget.orderModel,
                            actionModel: ActionModel(
                                date: DateTime.now().millisecondsSinceEpoch,
                                description:
                                    'Ha elininato l\'ordine #${widget.orderModel.code} '
                                    'per il fornitore ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)}. ',
                                fkBranchId:
                                    dataBundleNotifier.currentBranch.pkBranchId,
                                user: dataBundleNotifier
                                    .retrieveNameLastNameCurrentUser(),
                                type: ActionType.ORDER_DELETE));

                    dataBundleNotifier
                        .setCurrentBranch(dataBundleNotifier.currentBranch);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrdersScreen(),
                      ),
                    );
                  }),
            ],
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: kPrimaryColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: kBeigeColor,
            centerTitle: true,
            automaticallyImplyLeading: true,
            title: const Text(
              'Completa Bozza Ordine',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 8, 100),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.45,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Card(
                          child: Column(
                            children: [
                              Text(
                                '#' + widget.orderModel.code,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    CupertinoButton(
                                      child:
                                          const Text('Seleziona data consegna'),
                                      color: Colors.blueAccent,
                                      onPressed: () => _selectDate(context),
                                    ),
                                    const Text('Data consegna'),
                                    currentDate == null
                                        ? Text(''
                                            'Nessuna Data selezionata')
                                        : Text('Data consegna : ' +
                                            currentDate.toString()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text('Carrello',
                          style: TextStyle(
                              color: kPinaColor,
                              fontSize: getProportionateScreenHeight(20),
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  buildProductListWidget(
                      widget.productList, dataBundleNotifier),
                  const Divider(
                    height: 40,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  buildProductListWidget(List<ProductOrderAmountModel> productList,
      DataBundleNotifier dataBundleNotifier) {
    List<Row> rows = [];
    productList.forEach((element) {
      TextEditingController controller =
          TextEditingController(text: element.amount.toString());
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(200),
                  child: Text(
                    element.nome,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      element.unita_misura,
                      style:
                          TextStyle(fontSize: getProportionateScreenWidth(8)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        FontAwesomeIcons.dotCircle,
                        size: getProportionateScreenWidth(3),
                      ),
                    ),
                    Text(
                      element.prezzo_lordo.toString() + ' €',
                      style:
                          TextStyle(fontSize: getProportionateScreenWidth(8)),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (element.amount <= 0) {
                      } else {
                        element.amount--;
                      }
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.minus,
                      color: kPinaColor,
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(
                      getProportionateScreenWidth(70),
                      getProportionateScreenWidth(60))),
                  child: CupertinoTextField(
                    controller: controller,
                    onChanged: (text) {
                      if (double.tryParse(text) != null) {
                        element.amount = double.parse(text);
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text(
                              'Immettere un valore numerico corretto per ' +
                                  element.nome),
                        ));
                      }
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    clearButtonMode: OverlayVisibilityMode.never,
                    textAlign: TextAlign.center,
                    autocorrect: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      element.amount = element.amount + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.plus,
                        color: Colors.green.shade900),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });

    return Column(
      children: rows,
    );
  }

  String getNiceNumber(String string) {
    if (string.contains('.00')) {
      return string.replaceAll('.00', '');
    } else if (string.contains('.0')) {
      return string.replaceAll('.0', '');
    } else {
      return string;
    }
  }
}
