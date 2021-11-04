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

class UnderWorkingOrderPage extends StatefulWidget {
  const UnderWorkingOrderPage({Key key}) : super(key: key);

  @override
  State<UnderWorkingOrderPage> createState() => _UnderWorkingOrderPageState();
}

class _UnderWorkingOrderPageState extends State<UnderWorkingOrderPage> {


  ValueNotifier<List<OrderModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
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

          _kOrders.addAll(getKOrders(dataBundleNotifier.currentOrdersForCurrentBranch));

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder(
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
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(3),

                        ),
                        outsideDaysVisible: false,
                        canMarkersOverflow: true,
                        isTodayHighlighted: false,
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
                    SizedBox(height: getProportionateScreenHeight(12),),
                    ValueListenableBuilder<List<OrderModel>>(
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.shopping_cart_outlined, size: getProportionateScreenHeight(13),color: kBeigeColor,),

                                        Text(' #' + orderList[order].code, style: TextStyle(color: kBeigeColor, fontSize: getProportionateScreenHeight(10)),),
                                      ],
                                    ),
                                    SizedBox(height: getProportionateScreenHeight(10),),

                                    Row(
                                      children: [
                                        Icon(Icons.person, size: getProportionateScreenHeight(20),color: kBeigeColor,),
                                        getSupplierData(dataBundleNotifier, orderList[order].fk_supplier_id),
                                      ]

                                    ),
                                    SizedBox(height: getProportionateScreenHeight(15),),
                                    Row(
                                      children: [
                                        Icon(Icons.category, size: getProportionateScreenHeight(15),color: kBeigeColor,),

                                        Text('   Prodotti x' + orderIdProductListMap[orderList[order].pk_order_id].length.toString(), style: TextStyle(fontSize: getProportionateScreenHeight(13)),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.monetization_on_sharp, size: getProportionateScreenHeight(15),color: kBeigeColor,),
                                        Text('   Prezzo Stimato €' + calculatePriceFromProductList(orderIdProductListMap[orderList[order].pk_order_id]), style: TextStyle(fontSize: getProportionateScreenHeight(13)),),
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
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


      dataBundleNotifier.currentOrdersForCurrentBranch.forEach((element) async {
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

    return total.toString();
  }

  getSupplierData(DataBundleNotifier dataBundleNotifier, int fk_supplier_id) {
    String currentSupplierName;
    dataBundleNotifier.currentListSuppliers.forEach((currentSupplier) {
      print('currentSupplier.pkSupplierId : ' + currentSupplier.pkSupplierId.toString());
      print('fk_supplier_id : ' + fk_supplier_id.toString());
      if(currentSupplier.pkSupplierId == fk_supplier_id){
        currentSupplierName = currentSupplier.nome;
      }
    });
    return Text('  ' + currentSupplierName, style: TextStyle(color: kPinaColor, fontSize: getProportionateScreenHeight(17)),);
  }

}
