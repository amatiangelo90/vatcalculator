import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/screens/orders/components/order_card.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';

import '../datepiker/date_picker_widget.dart';

class UnderWorkingOrderPage extends StatefulWidget {
  const UnderWorkingOrderPage({Key key}) : super(key: key);

  @override
  State<UnderWorkingOrderPage> createState() => _UnderWorkingOrderPageState();
}

class _UnderWorkingOrderPageState extends State<UnderWorkingOrderPage> {


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
          _kOrders.addAll(getKOrders(dataBundleNotifier.currentUnderWorkingOrdersList));
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
            future: buildUnderWorkingOrderList(_selectedEvents, dataBundleNotifier),
            builder: (context, snapshot) {
              final kNow = DateTime.now();
              final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
              final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);

              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    Container(
                      color: kPrimaryColor,
                      child: TableCalendar<OrderModel>(
                        headerStyle: HeaderStyle(
                          formatButtonTextStyle:  const TextStyle(fontSize: 14.0, color: kCustomWhite),
                          titleTextStyle: TextStyle(fontSize: 14.0, color: kCustomBlueAccent),
                          formatButtonDecoration: BoxDecoration(
                            color: kCustomBlueAccent,
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          leftChevronIcon: Icon(
                            Icons.arrow_back_ios,
                            color: kCustomWhite,
                            size: getProportionateScreenHeight(16),
                          ),
                          rightChevronIcon: Icon(
                            Icons.arrow_forward_ios,
                            color: kCustomWhite,
                            size: getProportionateScreenHeight(16),
                          ),
                        ),
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle:  TextStyle(fontSize: 14.0, color: kCustomWhite),
                          weekendStyle:  TextStyle(fontSize: 14.0, color: Colors.redAccent),
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
                          markerSize: 11,
                          selectedTextStyle: const TextStyle(fontSize: 14.0, color: kCustomWhite),
                          defaultTextStyle:  const TextStyle(fontSize: 14.0, color: kCustomWhite),
                          weekendTextStyle:  const TextStyle(fontSize: 14.0, color: Colors.redAccent),

                          selectedDecoration: BoxDecoration(
                            color: kCustomBlueAccent,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: kCustomBlueAccent,
                            shape: BoxShape.circle,
                          ),

                          markerDecoration: BoxDecoration(
                            color: Colors.red,
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
                              return OrderCard(order: orderList[order],
                                showExpandedTile: true,
                                orderIdProductListMap: orderIdProductListMap,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
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

    dataBundleNotifier.currentUnderWorkingOrdersList.forEach((element) async {
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

  String getNiceNumber(String string) {
    if(string.contains('.00')){
      return string.replaceAll('.00', '');
    }else if(string.contains('.0')){
      return string.replaceAll('.0', '');
    }else {
      return string;
    }
  }
}

