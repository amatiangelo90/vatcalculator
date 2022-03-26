import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/event/component/datepiker/date_picker_widget.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'event_card.dart';

class EventsBodyWidget extends StatefulWidget {
  const EventsBodyWidget({Key key}) : super(key: key);

  @override
  _EventsBodyWidgetState createState() => _EventsBodyWidgetState();
}

class _EventsBodyWidgetState extends State<EventsBodyWidget> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: buildEventsWidgetByCurrentDate(dataBundleNotifier, dateTime),
              ),
            ),
            Container(
              color: kPrimaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 1/10,
                  child: DatePickerEvents(
                    DateTime.now().subtract(Duration(days: 4)),
                    initialSelectedDate: DateTime.now(),
                    selectionColor: kCustomOrange,
                    selectedTextColor: Colors.white,
                    width: getProportionateScreenHeight(50),
                    daysCount: 13,
                    dayTextStyle: TextStyle(fontSize: getProportionateScreenWidth(8)),
                    dateTextStyle: TextStyle(fontSize: 15),
                    monthTextStyle: TextStyle(fontSize: 10),
                    onDateChange: (date) {
                      setState(() {
                        dateTime = date;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  buildEventsWidgetByCurrentDate(DataBundleNotifier dataBundleNotifier, DateTime dateTime) {
    List<Widget> eventList = [
      SizedBox(height: getProportionateScreenHeight(100),)
    ];

    dataBundleNotifier.eventModelList.forEach((eventItem) {
      print(DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).toString());
      if(DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).day == dateTime.day &&
          DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).month == dateTime.month &&
          DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).year == dateTime.year){
        eventList.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: EventCard(
            eventModel: eventItem,
            showButton: true,
            showArrow: false,
          ),
        ),);
      }
    });
    eventList.add(SizedBox(height: getProportionateScreenHeight(100),));
    return eventList;
  }
}
