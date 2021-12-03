import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/bundle_users_storage_supplier_forbranch.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';

class ActionsDetailsScreen extends StatefulWidget {
  const ActionsDetailsScreen({Key key}) : super(key: key);

  static String routeName = 'actions_details';

  @override
  State<ActionsDetailsScreen> createState() => _ActionsDetailsScreenState();
}

class _ActionsDetailsScreenState extends State<ActionsDetailsScreen> {


  ValueNotifier<List<ActionModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  final LinkedHashMap<DateTime, List<ActionModel>> _kActions = LinkedHashMap();

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay));
  }

  List<ActionModel> _getEventsForDay(DateTime day){
    return _kActions[day] ?? [];
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
          final kNow = DateTime.now();
          final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
          final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);

          _kActions.addAll(getKOrders(dataBundleNotifier.currentBranchActionsList));
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kCustomWhite,
              title: const Text('Azioni Eseguite'),
              centerTitle: true,
              titleTextStyle: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(15)),
              leading: GestureDetector(
                child: const Icon(Icons.arrow_back_ios),
                onTap: (){
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Column(
              children: [
                Container(
                  color: kCustomWhite,
                  child: TableCalendar<ActionModel>(
                    headerStyle: HeaderStyle(
                      formatButtonTextStyle:  const TextStyle(fontSize: 14.0, color: kCustomWhite),
                      titleTextStyle:  const TextStyle(fontSize: 14.0, color: kPrimaryColor),
                      formatButtonDecoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      leftChevronIcon: Icon(
                        Icons.arrow_back_ios,
                        color: kPrimaryColor,
                        size: getProportionateScreenHeight(16),
                      ),
                      rightChevronIcon: Icon(
                        Icons.arrow_forward_ios,
                        color: kPrimaryColor,
                        size: getProportionateScreenHeight(16),
                      ),
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
                      weekendTextStyle:  const TextStyle(fontSize: 14.0, color: Colors.redAccent),

                      selectedDecoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: kPrimaryColor,
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
                  height: 16,
                  decoration: const BoxDecoration(
                    color: kCustomWhite,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<List<ActionModel>>(
                    valueListenable: _selectedEvents,
                    builder: (context, actionsList, child) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: actionsList.length,
                        itemBuilder: (context, action) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 0.0,
                              vertical: 1.0,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.white,
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        ActionType.getIconWidget(actionsList[action].type) ?? const Text('ICONA'),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('  ' + actionsList[action].user, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(15), fontWeight: FontWeight.bold),),
                                            Text(
                                                '  ' + DateTime.fromMillisecondsSinceEpoch(actionsList[action].date).day.toString() + '/' +
                                                    DateTime.fromMillisecondsSinceEpoch(actionsList[action].date).month.toString() + '/' +
                                                    DateTime.fromMillisecondsSinceEpoch(actionsList[action].date).year.toString() + '  ' +
                                                    DateTime.fromMillisecondsSinceEpoch(actionsList[action].date).hour.toString() + ':' +
                                                    (DateTime.fromMillisecondsSinceEpoch(actionsList[action].date).minute > 9
                                                        ? DateTime.fromMillisecondsSinceEpoch(actionsList[action].date).minute.toString()
                                                        : '0' + DateTime.fromMillisecondsSinceEpoch(actionsList[action].date).minute.toString())

                                                , style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(getProportionateScreenWidth(58), 0, getProportionateScreenWidth(10), 2),
                                      child: Text(actionsList[action].description, textAlign: TextAlign.start, overflow: TextOverflow.visible, style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Divider(height: 1, indent: getProportionateScreenWidth(58),),
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
            ),
          );
        }
    );
  }

  LinkedHashMap<DateTime, List<ActionModel>> getKOrders(List<ActionModel> eventsList) {

    var linkedHashMap = LinkedHashMap<DateTime, List<ActionModel>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(buildListEvent(eventsList));
    return linkedHashMap;
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Map<DateTime, List<ActionModel>> buildListEvent(List<ActionModel> eventsList) {
    Map<DateTime, List<ActionModel>> map1 = Map();
    eventsList.forEach((element) {
      if(map1.containsKey(buildDateKeyFromDate(Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(element.date))))){
        map1[buildDateKeyFromDate(Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(element.date)))].add(element);
      }else{
        List<ActionModel> listToAdd = [element];
        map1[buildDateKeyFromDate(Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(element.date)))] = listToAdd;
      }
    });
    return map1;
  }

  DateTime buildDateKeyFromDate(Timestamp date) {

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
    return DateTime.utc(dateTime.year, dateTime.month, dateTime.day, 0 ,0 ,0 ,0, 0);
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
