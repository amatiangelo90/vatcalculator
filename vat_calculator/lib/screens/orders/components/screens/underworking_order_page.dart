import 'dart:collection';
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

class UnderWorkingOrderPage extends StatefulWidget {
  const UnderWorkingOrderPage({Key? key}) : super(key: key);

  @override
  State<UnderWorkingOrderPage> createState() => _UnderWorkingOrderPageState();
}

class _UnderWorkingOrderPageState extends State<UnderWorkingOrderPage> {


  late ValueNotifier<List<OrderModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  final LinkedHashMap<DateTime, List<OrderModel>> _kOrders = LinkedHashMap();

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Map<int, List<ProductOrderAmountModel>> orderIdProductListMap = {};

  @override
  void initState() {
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay));
    super.initState();
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
                          titleTextStyle: TextStyle(fontSize: 14.0, color: Colors.white),
                          formatButtonDecoration: BoxDecoration(
                            color: kCustomBlue,
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
                          weekendStyle:  TextStyle(fontSize: 14.0, color: kCustomPinkAccent),
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
                          weekendTextStyle:  const TextStyle(fontSize: 14.0, color: kCustomPinkAccent),

                          selectedDecoration: const BoxDecoration(
                            color: kCustomBlue,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),

                          markerDecoration: BoxDecoration(
                            color: kCustomPinkAccent,
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
                      color: kPrimaryColor,

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
                                orderIdProductList: orderIdProductListMap[orderList[order].pk_order_id]!,
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

    return map1;
  }



  Future<List<Widget>> buildUnderWorkingOrderList(ValueNotifier<List<OrderModel>> selectedEvents,
      DataBundleNotifier dataBundleNotifier) async {

    dataBundleNotifier.currentUnderWorkingOrdersList.forEach((element) async {
      List<ProductOrderAmountModel> list = await dataBundleNotifier.getclientServiceInstance().retrieveProductByOrderId(
        OrderModel(pk_order_id: element.pk_order_id, code: '', closedby: '', delivery_date: '',
          paid: '', status: '', total: 0, fk_user_id: 0, fk_supplier_id: 0, fk_storage_id: 0, fk_branch_id: 0, details: '', creation_date: ''),
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
    }else {
      return string;
    }
  }
}

