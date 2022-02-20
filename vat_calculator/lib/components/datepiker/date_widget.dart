import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/size_config.dart';

import 'gestures/tap.dart';

class DateWidget extends StatelessWidget {
  final double width;
  final DateTime date;
  final TextStyle monthTextStyle, dayTextStyle, dateTextStyle;
  final Color selectionColor;
  final DateSelectionCallback onDateSelected;
  final String locale;

  DateWidget({
    @required this.date,
    @required this.monthTextStyle,
    @required this.dayTextStyle,
    @required this.dateTextStyle,
    @required this.selectionColor,
    this.width,
    this.onDateSelected,
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width * 1/9.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(8.0)),
          color: selectionColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox(
            height: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(getDayFromWeekDayTrim(date.weekday), // WeekDay
                    style: dayTextStyle),
                Text(date.day.toString(), // Date
                    style: dateTextStyle),
                Text(getMonthFromMonthNumber(date.month), // WeekDay
                    style: dayTextStyle),

              ],
            ),
          ),
        ),
      ),
      onTap: () {
        // Check if onDateSelected is not null
        if (onDateSelected != null) {
          // Call the onDateSelected Function
          onDateSelected(this.date);
        }
      },
    );
  }
}
