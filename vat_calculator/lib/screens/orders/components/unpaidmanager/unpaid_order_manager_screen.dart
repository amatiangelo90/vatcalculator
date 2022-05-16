import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../../../client/vatservice/model/deposit_order_model.dart';
import '../../../../client/vatservice/model/product_order_amount_model.dart';
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
                              buildDateFromMilliseconds(widget.orderModel.creation_date),
                              style: TextStyle(
                                fontSize: getProportionateScreenHeight(12),
                                color: LightColors.kLightYellow2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              buildDateFromMilliseconds(widget.orderModel.delivery_date),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('', style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white, fontSize: 10),),
                        const Text('', style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white, fontSize: 10),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('Stato Saldo Fattura ', style: TextStyle(
                                fontWeight: FontWeight.w700, color: Colors.white, fontSize: 10),),
                            SizedBox(height: 10),
                            CircularPercentIndicator(
                              animation: true,
                              radius: 100.0,
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(3, 11, 10, 11),
                              child: Text(
                                ' € ' + widget.orderModel.total.toString().replaceAll('.00', ''),
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          buildListDeposit(dataBundleNotification.mapOrderIdDepositOrderList[widget.orderModel.pk_order_id]),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          buildListDepositDates(dataBundleNotification.mapOrderIdDepositOrderList[widget.orderModel.pk_order_id]),
                        ),
                      ],
                    ),
                    Divider(
                      height: 14,
                    ),
                    buildDepositListWidget(dataBundleNotification.mapOrderIdDepositOrderList[widget.orderModel.pk_order_id]),
                    Divider(),
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
                    SizedBox(height: 150),
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

  buildListDeposit(List<DepositOrder> depositList) {
    List<Widget> listOut = [];

    depositList.forEach((element) {
      listOut.add(
        Text(' - € ' + element.amount.toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: getProportionateScreenHeight(12)),),
      );
    });

    return listOut;
  }

  buildListDepositDates(List<DepositOrder> depositList) {
    List<Widget> listOut = [];

    depositList.forEach((element) {
      listOut.add(
        Text(buildDateFromMilliseconds(element.creationDate), style: TextStyle(fontWeight: FontWeight.w100, color: Colors.grey, fontSize: getProportionateScreenHeight(12)),),
      );
    });

    return listOut;
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

  buildDepositListWidget(List<DepositOrder> depositList) {
    List<Widget> dismissableDepositList = [];

    depositList.forEach((deposit) {
      TextEditingController _textEditingController = TextEditingController(text: deposit.amount.toStringAsFixed(2));
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
                      '€ ' + deposit.amount.toString(),
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
                    child: RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.blueGrey.shade700,
                      elevation: 19.0,
                      child: Text('Aggiorna', style: TextStyle(fontSize: 18.0,color: Colors.white, fontFamily: 'LoraFont'),),
                      onPressed: () async {

                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                            duration: Duration(milliseconds: 500),
                            backgroundColor: Colors.green,
                            content: Text('Aggiornamento eseguito')));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          confirmDismiss: (direction) async {

          },
          onDismissed: (direction) async {

          },
        ),
      );
    });

    return Column(
      children: dismissableDepositList,
    );
  }

}
