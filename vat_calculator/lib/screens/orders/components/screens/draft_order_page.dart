import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';

import '../../orders_screen.dart';
import '../edit_order_draft_screen.dart';

class DraftOrderPage extends StatefulWidget {
  const DraftOrderPage({Key key}) : super(key: key);

  @override
  State<DraftOrderPage> createState() => _DraftOrderPageState();
}

class _DraftOrderPageState extends State<DraftOrderPage> {

  ValueNotifier<List<OrderModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;

  LinkedHashMap<DateTime, List<OrderModel>> _kOrders = LinkedHashMap();

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  Map<int, List<ProductOrderAmountModel>> orderIdProductListMap = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));

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

          _kOrders.addAll(getKOrders(dataBundleNotifier.currentDraftOrdersList));

          return FutureBuilder(
            initialData: <Widget>[
              const Center(
                  child: CircularProgressIndicator(
                    color: kPinaColor,
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
            future: buildDraftOrderList(_selectedEvents, dataBundleNotifier),
            builder: (context, snapshot) {
              final kNow = DateTime.now();
              final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
              final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);

              return Column(
                children: [
                  SizedBox(height: 3,),
                  Text('Calendario per ordini in stato \'Bozza\''),
                  TableCalendar<OrderModel>(
                    headerStyle: const HeaderStyle(
                      formatButtonTextStyle:  TextStyle(fontSize: 14.0, color: kPrimaryColor),
                      titleTextStyle:  TextStyle(fontSize: 14.0, color: kPrimaryColor),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle:  TextStyle(fontSize: 14.0, color: kPrimaryColor),
                      weekendStyle:  TextStyle(fontSize: 14.0, color: kPrimaryColor),

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
                      defaultTextStyle:  const TextStyle(fontSize: 14.0, color: kPrimaryColor),
                      weekendTextStyle:  const TextStyle(fontSize: 14.0, color: kPinaColor),

                      selectedDecoration: const BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: Colors.orange,
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
                  Divider(
                    color: kBeigeColor,
                    height: getProportionateScreenHeight(20),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<List<OrderModel>>(
                      valueListenable: _selectedEvents,
                      builder: (context, orderList, _) {
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

                              // ${orderList[order].code}
                              child: Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 4,),
                                      Row(
                                        children: [
                                          SizedBox(width: 3,),
                                          Icon(Icons.shopping_cart_outlined, size: getProportionateScreenHeight(13),color: kPrimaryColor,),
                                          Text(' #' + orderList[order].code, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(10)),),
                                        ],
                                      ),
                                      SizedBox(height: getProportionateScreenHeight(10),),

                                      Row(
                                          children: [
                                            Icon(Icons.person, size: getProportionateScreenHeight(20),color: kPrimaryColor,),
                                            dataBundleNotifier.getSupplierData(orderList[order].fk_supplier_id),
                                          ]
                                      ),
                                      SizedBox(height: getProportionateScreenHeight(15),),
                                      Row(
                                        children: [
                                          Icon(Icons.category, size: getProportionateScreenHeight(15),color: kPrimaryColor,),
                                          Text('   Prodotti', style: TextStyle(fontSize: getProportionateScreenHeight(13)),),
                                          Text(' x ' + orderIdProductListMap[orderList[order].pk_order_id].length.toString(), style: TextStyle(color: kPinaColor ,fontSize: getProportionateScreenHeight(14)),),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.monetization_on_sharp, size: getProportionateScreenHeight(15),color: kPrimaryColor,),
                                          Text('   Prezzo Stimato ', style: TextStyle(fontSize: getProportionateScreenHeight(13)),),
                                          Text('€ ' + calculatePriceFromProductList(orderIdProductListMap[orderList[order].pk_order_id]), style: TextStyle(color: kPinaColor, fontSize: getProportionateScreenHeight(14)),),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today_outlined, size: getProportionateScreenHeight(15),color: kPrimaryColor,),
                                          Text('   Effettuato in data: ', style: TextStyle(fontSize: getProportionateScreenHeight(13)),),
                                          Text(getStringDateFromDateTime(DateTime.fromMillisecondsSinceEpoch(orderList[order].creation_date)), style: TextStyle(color: kPinaColor, fontSize: getProportionateScreenHeight(14)),),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        child: CupertinoButton(
                                            child: Text('Modifica ed Inoltra', style: TextStyle(fontSize: getProportionateScreenHeight(13)),),
                                            pressedOpacity: 0.9,
                                            color: Colors.blueAccent,
                                            onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditDraftOrderScreen(orderModel: orderList[order], productList: orderIdProductListMap[orderList[order].pk_order_id], ),),);

                                            }),
                                      ),
                                      const SizedBox(height: 3,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        child: CupertinoButton(
                                            child: Text('Elimina', style: TextStyle(fontSize: getProportionateScreenHeight(13)),),
                                            pressedOpacity: 0.9,
                                            color: kPinaColor,
                                            onPressed: () async {
                                              await dataBundleNotifier.getclientServiceInstance().deleteOrder(
                                                  orderList[order]
                                              );

                                              dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const OrdersScreen(
                                                    initialIndex: 1,
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      Divider(endIndent: 20,indent: 20,),
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
      if(map1.containsKey(buildDateKeyFromDate(Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(element.creation_date))))){
        map1[buildDateKeyFromDate(Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(element.creation_date)))].add(element);
      }else{
        List<OrderModel> listToAdd = [element];
        map1[buildDateKeyFromDate(Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(element.creation_date)))] = listToAdd;
      }
    });
    return map1;
  }

  DateTime buildDateKeyFromDate(Timestamp date) {

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
    return DateTime.utc(dateTime.year, dateTime.month, dateTime.day, 0 ,0 ,0 ,0, 0);
  }

  Future<List<Widget>> buildDraftOrderList(ValueNotifier<List<OrderModel>> selectedEvents,
      DataBundleNotifier dataBundleNotifier) async {


    dataBundleNotifier.currentDraftOrdersList.forEach((element) async {
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

}
