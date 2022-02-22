import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/screens/event/component/datepiker/date_picker_widget.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class EventsBodyWidget extends StatefulWidget {
  const EventsBodyWidget({Key key}) : super(key: key);

  @override
  _EventsBodyWidgetState createState() => _EventsBodyWidgetState();
}

class _EventsBodyWidgetState extends State<EventsBodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 1/10,
              child: DatePickerEvents(
                DateTime.now().subtract(Duration(days: 3)),
                initialSelectedDate: DateTime.now(),
                selectionColor: kCustomYellow800,
                selectedTextColor: Colors.white,
                width: getProportionateScreenHeight(50),
                daysCount: 13,
                dayTextStyle: TextStyle(fontSize: getProportionateScreenWidth(8)),
                dateTextStyle: TextStyle(fontSize: 15),
                monthTextStyle: TextStyle(fontSize: 10),
                onDateChange: (date) {
                  setState(() {

                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
