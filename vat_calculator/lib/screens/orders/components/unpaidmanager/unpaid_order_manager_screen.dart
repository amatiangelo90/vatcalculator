import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../../../client/vatservice/model/deposit_order_model.dart';
import '../../../../client/vatservice/model/product_order_amount_model.dart';
import '../../../../components/default_button.dart';
import '../../../../components/light_colors.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';

class UnpaidOrderManagerScreen extends StatefulWidget {
  const UnpaidOrderManagerScreen({Key key, this.orderModel, this.supplierName, this.userName}) : super(key: key);

  final String supplierName;
  final String userName;
  final OrderModel orderModel;

  @override
  State<UnpaidOrderManagerScreen> createState() => _UnpaidOrderManagerScreenState();
}

class _UnpaidOrderManagerScreenState extends State<UnpaidOrderManagerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textDepositController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotification, _){
        return GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 5.0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              automaticallyImplyLeading: true,
              title: const Text(
                'Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.supplierName, style: const TextStyle(
                        fontWeight: FontWeight.w900, color: Colors.white, fontSize: 15),),
                    Text(
                      widget.orderModel.code,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.orderModel.status,
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(12),
                        color: Colors.lightGreenAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Creato da:',
                              style: TextStyle(
                                fontSize: getProportionateScreenHeight(12),
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Chiuso da:',
                              style: TextStyle(
                                fontSize: getProportionateScreenHeight(12),
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Data Ordine:',
                              style: TextStyle(
                                fontSize: getProportionateScreenHeight(12),
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Ricevuto:             ',
                              style: TextStyle(
                                fontSize: getProportionateScreenHeight(12),
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aggiungi creatore',
                              style: TextStyle(
                                fontSize: getProportionateScreenHeight(12),
                                color: LightColors.kLightYellow2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              widget.orderModel.closedby,
                              style: TextStyle(
                                fontSize: getProportionateScreenHeight(12),
                                color: LightColors.kLightYellow2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              widget.orderModel.creation_date,
                              style: TextStyle(
                                fontSize: getProportionateScreenHeight(12),
                                color: LightColors.kLightYellow2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              widget.orderModel.delivery_date,
                              style: TextStyle(
                                fontSize: getProportionateScreenHeight(12),
                                color: LightColors.kLightYellow2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Divider(color: Colors.grey),
                    const Text('Stato Saldo Fattura ', style: TextStyle(
                        fontWeight: FontWeight.w700, color: LightColors.kRed, fontSize: 20),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularPercentIndicator(
                        animation: true,
                        radius: 150.0,
                        percent: calculatePercentagePaid(dataBundleNotification.mapOrderIdDepositOrderList[widget.orderModel.pk_order_id], widget.orderModel.total),
                        lineWidth: 5.0,
                        circularStrokeCap: CircularStrokeCap.round,
                        backgroundColor: Colors.white10,
                        progressColor: Colors.lightGreenAccent,
                        center: Text(
                          '${(calculatePercentagePaid(dataBundleNotification.mapOrderIdDepositOrderList[widget.orderModel.pk_order_id], widget.orderModel.total)*100).round()}%',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(3, 11, 10, 11),
                                  child: Text(
                                    ' € ' + widget.orderModel.total.toString().replaceAll('.00', '') + ' /',
                                    style: const TextStyle(
                                      fontSize: 25.0,
                                      color: LightColors.kLightYellow,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(3, 11, 10, 11),
                                  child: Text(
                                    '€ ' + calculateDepositTotal(dataBundleNotification.mapOrderIdDepositOrderList[widget.orderModel.pk_order_id]).toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.lightGreenAccent,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Text('  Inserisci Acconto ', style: TextStyle(
                        fontWeight: FontWeight.w700, color: LightColors.kGreen, fontSize: 15),),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: textDepositController,
                        cursorColor: Colors.white,
                        style: const TextStyle(fontSize: 18.0,color: Colors.white, fontWeight: FontWeight.w700),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder (
                            borderSide: BorderSide(color: LightColors.kLightYellow, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: LightColors.kLightYellow, width: 1.0),
                          ),
                          labelText: '€',
                          labelStyle: TextStyle(fontSize: 16.0,color: LightColors.kLightYellow),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DefaultButton(
                        text: 'Salva Acconto',
                        press: () async {
                          if(double.tryParse(textDepositController.value.text.replaceAll(',', '.')) != null){

                            if((calculateDepositTotal(dataBundleNotification.mapOrderIdDepositOrderList[widget.orderModel.pk_order_id])
                                + double.parse(textDepositController.value.text.replaceAll(',', '.'))) > widget.orderModel.total){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  duration: Duration(milliseconds: 3000),
                                  backgroundColor: LightColors.kRed,
                                  content: Text('Errore. L\'importo dell\'acconto(o la somme degli importi degli acconti) non può eccedere il totale dell\'ordine.')));
                            }else{
                              await dataBundleNotification.getclientServiceInstance().performInsertDepositOrder(
                                  DepositOrder(pkDepositOrderId: 0,
                                      creationDate: null,
                                      amount: double.parse(textDepositController.value.text.replaceAll(',', '.')),
                                      fkOrderId: widget.orderModel.pk_order_id,
                                      user: dataBundleNotification.userDetailsList[0].firstName + ' ' + dataBundleNotification.userDetailsList[0].lastName)
                              );
                              setState(() {
                                textDepositController.clear();
                              });
                              dataBundleNotification.updateMapOrderIdDepositOrderListByOrderId(widget.orderModel);
                              FocusScope.of(context).requestFocus(FocusNode());
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  duration: Duration(milliseconds: 1600),
                                  backgroundColor: Colors.green,
                                  content: Text('Acconto inserito')));
                            }
                          }else{
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                duration: Duration(milliseconds: 1600),
                                backgroundColor: LightColors.kRed,
                                content: Text('Inserisci un numero corretto')));
                          }

                        },
                        color: LightColors.kGreen,
                      ),
                    ),
                    const Divider(
                      height: 20,
                      color: Colors.grey,
                    ),
                    const Text('Acconti: ', style: TextStyle(
                        fontWeight: FontWeight.w700, color: LightColors.kRed, fontSize: 20),),
                    buildDepositListWidget(dataBundleNotification.mapOrderIdDepositOrderList[widget.orderModel.pk_order_id], dataBundleNotification),
                    const Divider(
                      height: 25,
                      color: Colors.grey,
                    ),
                    const Text('Prodotti Acquistati: ', style: TextStyle(
                        fontWeight: FontWeight.w700, color: LightColors.kRed, fontSize: 20),),
                    FutureBuilder(
                      builder: (context, snap){
                        return snap.data;
                      },
                      initialData:
                        Column(
                          children: const [
                            Center(
                                child: CircularProgressIndicator(
                                  color: kPinaColor,
                                )),
                            SizedBox(),
                            Center(
                              child: Text(
                                'Caricamento dati..',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontFamily: 'LoraFont'),
                              ),
                            ),
                          ],
                        )
                      ,
                      future: buildProductsList(widget.orderModel, dataBundleNotification),
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: 50.0,

                      decoration: BoxDecoration(
                        color: LightColors.kRed,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(

                        onPressed: () {

                        },
                        child: const Center(
                          child: Text(
                            'SEGNA COME PAGATA',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String buildDateFromMilliseconds(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return getDayFromWeekDayTrim(dateTime.weekday) + ' ' + dateTime.day.toString() + ' ' + getMonthFromMonthNumber(dateTime.month) + ' ' + dateTime.year.toString();
  }

  double calculatePercentagePaid(List<DepositOrder> mapOrderIdDepositOrderList, double total) {
    if(total == 0.0 || total == null){
      return 0.0;
    }else{
      double totalPaid = 0.0;

      mapOrderIdDepositOrderList.forEach((element) {
        totalPaid = totalPaid + element.amount;
      });

      return totalPaid/total;
    }

  }

  Future<Column> buildProductsList(OrderModel orderModel, DataBundleNotifier dataBundleNotifier) async {
    List<ProductOrderAmountModel> orderProdList = await dataBundleNotifier
        .getclientServiceInstance()
        .retrieveProductByOrderId(
      orderModel,
    );

    return buildProductListWidget(orderProdList, dataBundleNotifier);

  }

  Column buildProductListWidget(List<ProductOrderAmountModel> productList,
      DataBundleNotifier dataBundleNotifier) {

    List<Row> rows = [];
    productList.forEach((element) {
      if(element.amount > 0){
        TextEditingController controller = TextEditingController(text: element.amount.toString());
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
                    child: Text(element.nome, overflow: TextOverflow.clip, style: TextStyle(fontSize: getProportionateScreenWidth(16),color: kCustomWhite),),
                  ),
                  Row(
                    children: [
                      Text(element.prezzo_lordo.toString() + ' €', style: TextStyle(fontSize: getProportionateScreenWidth(9),color: kCustomWhite),),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(FontAwesomeIcons.dotCircle, size: getProportionateScreenWidth(3),color: kCustomOrange),
                      ),
                      Text(element.unita_misura, style: TextStyle(fontSize: getProportionateScreenWidth(11),color: Colors.lightGreenAccent),),

                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
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

  buildDepositListWidget(List<DepositOrder> depositList, DataBundleNotifier dataBundleNotifier) {
    List<Widget> dismissableDepositList = [];

    depositList.forEach((deposit) {
      TextEditingController _textEditingController = TextEditingController(text: deposit.amount.toStringAsFixed(2).replaceAll('.00', '').replaceAll('.0', ''));
      dismissableDepositList.add(
        Dismissible(
          key: Key(deposit.pkDepositOrderId.toStringAsFixed(2)),
          direction: DismissDirection.endToStart,
          background: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Icon(FontAwesomeIcons.trash, color: Colors.white,),
                  ),
                ],
              ),
              color: Colors.deepOrangeAccent.shade700),
          child: Card(
            color: kPrimaryColor,
            child: ExpansionTile(
              iconColor: LightColors.kRed,
              trailing: Icon(Icons.arrow_circle_down_sharp, color: Colors.white, size: 15),
              initiallyExpanded: false,
              maintainState: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      '€ ' + deposit.amount.toStringAsFixed(2).replaceAll('.00', '').replaceAll('.0', ''),
                      style: TextStyle(fontSize: 14.0,color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(buildDateFromMilliseconds(deposit.creationDate), style: TextStyle(fontWeight: FontWeight.w100, color: Colors.grey, fontSize: getProportionateScreenHeight(12)),),

                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Text(
                        deposit.user.toString(),
                        style: TextStyle(fontSize: 10.0,color: Colors.grey, fontFamily: 'LoraFont'),
                      ),
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(fontSize: 16.0,color: Colors.orange),
                    controller: _textEditingController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder (
                        borderSide: BorderSide(color: Colors.orangeAccent, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orangeAccent, width: 1.0),
                      ),
                      border: OutlineInputBorder(

                      ),
                      labelText: '€',
                      labelStyle: TextStyle(fontSize: 16.0,color: Colors.orange),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey.shade700),
                        shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),),
                        elevation: MaterialStateProperty.resolveWith((states) => 19.0)
                      ),
                      child: const Text('Aggiorna', style: TextStyle(fontSize: 18.0,color: Colors.white, fontFamily: 'LoraFont'),),
                      onPressed: () async {

                        if(double.tryParse(_textEditingController.value.text.replaceAll(',', '.')) != null){

                          if((calculateDepositTotal(dataBundleNotifier.mapOrderIdDepositOrderList[widget.orderModel.pk_order_id])
                          + double.parse(_textEditingController.value.text.replaceAll(',', '.'))) > widget.orderModel.total){
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                          duration: Duration(milliseconds: 3000),
                          backgroundColor: LightColors.kRed,
                          content: Text('Errore. L\'importo dell\'acconto(o la somme degli importi degli acconti) non può eccedere il totale dell\'ordine.')));
                          }else{
                            await dataBundleNotifier.getclientServiceInstance().performUpdateDepositOrder(
                                DepositOrder(pkDepositOrderId: deposit.pkDepositOrderId,
                                    amount: double.parse(_textEditingController.value.text.replaceAll(',', '.')),
                                    fkOrderId: widget.orderModel.pk_order_id)
                            );
                            FocusScope.of(context).requestFocus(FocusNode());
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                duration: Duration(milliseconds: 1600),
                                backgroundColor: Colors.green,
                                content: Text('Acconto aggiornato')));
                            dataBundleNotifier.updateMapOrderIdDepositOrderListByOrderId(widget.orderModel);
                          }

                        }else{
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              duration: Duration(milliseconds: 1600),
                              backgroundColor: LightColors.kRed,
                              content: Text('Inserisci un numero corretto')));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          onDismissed: (direction) async {
            await dataBundleNotifier.getclientServiceInstance().performDeleteDepositOrder(
                DepositOrder(pkDepositOrderId: deposit.pkDepositOrderId,
                    amount: double.parse(_textEditingController.value.text.replaceAll(',', '.')),
                    fkOrderId: widget.orderModel.pk_order_id)
            );
            sleep(Duration(milliseconds: 300));
            FocusScope.of(context).requestFocus(FocusNode());
            dataBundleNotifier.updateMapOrderIdDepositOrderListByOrderId(widget.orderModel);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(
                duration: Duration(milliseconds: 1600),
                backgroundColor: Colors.green,
                content: Text('Acconto eliminato')));
          },
        ),
      );
    });

    return Column(
      children: dismissableDepositList,
    );
  }

  double calculateDepositTotal(List<DepositOrder> depositList) {
    double total = 0.0;
    depositList.forEach((element) {
      total = total + element.amount;
    });
    return total;
  }

}
