import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/bundle_users_storage_supplier_forbranch.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';

class ArchiviedOrderPage extends StatefulWidget {
  const ArchiviedOrderPage({Key key}) : super(key: key);

  static String routeName = 'archive_order';
  @override
  State<ArchiviedOrderPage> createState() => _ArchiviedOrderPageState();
}

class _ArchiviedOrderPageState extends State<ArchiviedOrderPage> {


  ValueNotifier<List<OrderModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  final LinkedHashMap<DateTime, List<OrderModel>> _kOrders = LinkedHashMap();

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  Map<int, List<ProductOrderAmountModel>> orderIdProductListMap = {};

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay));
  }

  List<OrderModel> _getEventsForDay(DateTime day){
    return _kOrders[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay,
      DateTime focusedDay) {

    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child){
          _kOrders.addAll(getKOrders(dataBundleNotifier.currentArchiviedWorkingOrdersList));
          return Scaffold(
            backgroundColor: kPrimaryColor,
            appBar: AppBar(
              elevation: 5,
              backgroundColor: kPrimaryColor,
              title: Text('Archivio Ordini', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(17))),
              centerTitle: true,
              titleTextStyle: TextStyle(color: kCustomGreenAccent, fontSize: getProportionateScreenWidth(15)),
              leading: GestureDetector( 
                child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onTap: (){
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: FutureBuilder(
              initialData: <Widget>[
                const Center(
                    child: CircularProgressIndicator(
                      color: kCustomGreenAccent,
                    )),
                const SizedBox(),
                Column(
                  children: const [
                    Center(
                      child: Text(
                        'Caricamento Ordini..',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: kPrimaryColor,
                            fontFamily: 'LoraFont'),
                      ),
                    ),
                  ],
                ),
              ],
              future: buildUnderWorkingOrderList(_selectedEvents, dataBundleNotifier),
              builder: (context, snapshot) {
                final kNow = DateTime.now();
                final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
                final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);

                return Column(
                  children: [
                    Container(
                      color: kPrimaryColor,
                      child: TableCalendar<OrderModel>(
                        headerStyle: HeaderStyle(
                          formatButtonTextStyle:  const TextStyle(fontSize: 14.0, color: kCustomWhite),
                          titleTextStyle:  const TextStyle(fontSize: 14.0, color: kCustomGreenAccent),
                          formatButtonDecoration: BoxDecoration(
                            color: kCustomGreenAccent,
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          leftChevronIcon: Icon(
                            Icons.arrow_back_ios,
                            color: kCustomGreenAccent,
                            size: getProportionateScreenHeight(16),
                          ),
                          rightChevronIcon: Icon(
                            Icons.arrow_forward_ios,
                            color: kCustomGreenAccent,
                            size: getProportionateScreenHeight(16),
                          ),
                        ),
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle:  TextStyle(fontSize: 14.0, color: kCustomGreenAccent),
                          weekendStyle:  TextStyle(fontSize: 14.0, color: kCustomGreenAccent),

                        ),

                        firstDay: kFirstDay,
                        lastDay: kLastDay,
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        calendarFormat: _calendarFormat,
                        rangeSelectionMode: _rangeSelectionMode,
                        eventLoader: _getEventsForDay,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarStyle: CalendarStyle(
                          markerSize: 10,
                          selectedTextStyle: const TextStyle(fontSize: 14.0, color: kCustomWhite),
                          defaultTextStyle:  const TextStyle(fontSize: 14.0, color: Colors.white),
                          weekendTextStyle:  const TextStyle(fontSize: 14.0, color: Colors.redAccent),

                          selectedDecoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          markerDecoration: BoxDecoration(
                            color: kPinaColor,
                            borderRadius: BorderRadius.circular(3),

                          ),
                          outsideDaysVisible: false,
                          canMarkersOverflow: true,
                          isTodayHighlighted: true,
                        ),
                        onDaySelected: _onDaySelected,
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                      ),
                    ),
                    Container(
                      height: 15,
                      decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                      ),
                    ),
                    Expanded(
                      child: ValueListenableBuilder<List<OrderModel>>(
                        valueListenable: _selectedEvents,
                        builder: (context, orderList, child) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: orderList.length,
                            itemBuilder: (context, order) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 0.0,
                                  vertical: 4.0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.white,
                                    elevation: 14,
                                    child: orderIdProductListMap[orderList[order].pk_order_id] == null
                                        ? const SizedBox(
                                      width: 0,
                                    )
                                        : Column(
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('  ' + dataBundleNotifier.getSupplierName(orderList[order].fk_supplier_id),
                                              style: TextStyle(fontSize: getProportionateScreenHeight(20), color: Colors.red.shade700, fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '   #' + orderList[order].code,
                                              style: TextStyle(
                                                  fontSize: getProportionateScreenHeight(12)),
                                            ), ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '    ' + orderList[order].status,
                                              style: TextStyle(
                                                  fontSize: getProportionateScreenHeight(12)),
                                            ), ],
                                        ),
                                        Divider(
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Prodotti',
                                                  style: TextStyle(
                                                      fontSize: getProportionateScreenHeight(16), fontWeight: FontWeight.bold),
                                                ),
                                                Text(orderIdProductListMap[
                                                orderList[order].pk_order_id]
                                                    .length
                                                    .toString(),
                                                  style: TextStyle(
                                                      color: kPinaColor,
                                                      fontSize: getProportionateScreenHeight(16)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Tot. ',
                                                  style: TextStyle(
                                                      fontSize: getProportionateScreenHeight(16), fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  '€ ' +
                                                      calculatePriceFromProductList(
                                                          orderIdProductListMap[
                                                          orderList[order].pk_order_id]),
                                                  style: TextStyle(
                                                      color: kPinaColor,
                                                      fontSize: getProportionateScreenHeight(16)),
                                                ),
                                              ],
                                            ),

                                          ],
                                        ),

                                        ExpansionTile(
                                          title: Text(
                                            'Mostra Dettagli',
                                            style: TextStyle(
                                                fontSize: getProportionateScreenHeight(13)),
                                          ),
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(width: getProportionateScreenWidth(10),),
                                                    const Text('Creato da: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(getUserDetailsById(orderList[order].fk_user_id, orderList[order].fk_branch_id,
                                                        dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers),
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
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
                                                    const Text('Aggiornato da: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(orderList[order].closedby,
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
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
                                                    const Text('Stato: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(orderList[order].status,
                                                      style: TextStyle(color: Colors.green.shade900),),
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
                                                    Text('Effettuato: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(getStringDateFromDateTime(DateTime.fromMillisecondsSinceEpoch(orderList[order].creation_date)),
                                                      style: TextStyle(color: Colors.green.shade900, fontSize: getProportionateScreenHeight(14)),),
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
                                                    Text('Consegnato: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(getStringDateFromDateTime(DateTime.fromMillisecondsSinceEpoch(orderList[order].delivery_date)),
                                                      style: TextStyle(color: Colors.green.shade900, fontSize: getProportionateScreenHeight(14)),),
                                                    SizedBox(width: getProportionateScreenWidth(10),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: getProportionateScreenHeight(20),),
                                            Text('Carrello'),
                                            buildProductListWidget(orderIdProductListMap[orderList[order].pk_order_id], dataBundleNotifier),
                                            SizedBox(height: getProportionateScreenHeight(20),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
    );
  }

  LinkedHashMap<DateTime, List<OrderModel>> getKOrders(List<OrderModel> eventsList) {

    var linkedHashMap = LinkedHashMap<DateTime, List<OrderModel>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(buildListEvent(eventsList));
    return linkedHashMap;
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Map<DateTime, List<OrderModel>> buildListEvent(List<OrderModel> eventsList) {
    Map<DateTime, List<OrderModel>> map1 = Map();
    eventsList.forEach((element) {
      if(map1.containsKey(buildDateKeyFromDate(Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(element.delivery_date))))){
        map1[buildDateKeyFromDate(Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(element.delivery_date)))].add(element);
      }else{
        List<OrderModel> listToAdd = [element];
        map1[buildDateKeyFromDate(Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(element.delivery_date)))] = listToAdd;
      }
    });
    return map1;
  }

  DateTime buildDateKeyFromDate(Timestamp date) {

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
    return DateTime.utc(dateTime.year, dateTime.month, dateTime.day, 0 ,0 ,0 ,0, 0);
  }

  Future<List<Widget>> buildUnderWorkingOrderList(ValueNotifier<List<OrderModel>> selectedEvents,
      DataBundleNotifier dataBundleNotifier) async {

    dataBundleNotifier.currentArchiviedWorkingOrdersList.forEach((element) async {
      List<ProductOrderAmountModel> list = await dataBundleNotifier.getclientServiceInstance().retrieveProductByOrderId(
        OrderModel(pk_order_id: element.pk_order_id,),
      );
      orderIdProductListMap[element.pk_order_id] = list;
    });
    return [];
  }

  String calculatePriceFromProductList(List<ProductOrderAmountModel> orderIdProductListMap) {
    double total = 0.0;

    orderIdProductListMap.forEach((currentProduct) {
      total = total + (currentProduct.amount * currentProduct.prezzo_lordo);
    });

    return total.toStringAsFixed(2);
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
                  child: Text(element.nome, overflow: TextOverflow.clip, style: TextStyle(fontSize: getProportionateScreenWidth(16)),),
                ),
                Row(
                  children: [
                    Text(element.unita_misura, style: TextStyle(fontSize: getProportionateScreenWidth(8)),),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(FontAwesomeIcons.dotCircle, size: getProportionateScreenWidth(3),),
                    ),
                    Text(element.prezzo_lordo.toString() + ' €', style: TextStyle(fontSize: getProportionateScreenWidth(8)),),
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
}
