import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
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
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundlerNotifier, _){
        return InkWell(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 1/6,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                  color: selectionColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(getDayFromWeekDayTrim(date.weekday), // WeekDay
                        style: dayTextStyle),
                    Text(date.day.toString(), // Date
                        style: dateTextStyle),
                    Text(getMonthFromMonthNumber(date.month), // WeekDay
                        style: dayTextStyle),
                    isToday(date.millisecondsSinceEpoch) ? Text('OGGI', // WeekDay
                        style: TextStyle(color: Colors.greenAccent, fontSize: getProportionateScreenWidth(10))) : Text(' ', style: dayTextStyle),
                  ],
                ),
              ),
              dataBundlerNotifier.retrieveEventsNumberForCurrentDate(date) > 0 ? Positioned(
                top: 0.0,
                right: 2.0,
                child: Stack(
                  children: <Widget>[
                    Icon(
                      Icons.brightness_1,
                      size: getProportionateScreenWidth(19),
                      color: Colors.red.shade700,
                    ),
                    Positioned(
                      right: dataBundlerNotifier.retrieveEventsNumberForCurrentDate(date) > 9 ? 4.5 : 7.5,
                      top: 4.0,
                      child: Center(
                        child: Text(
                          '' + dataBundlerNotifier.retrieveEventsNumberForCurrentDate(date).toString(),
                          style: const TextStyle(
                              fontSize: 8.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ) : const SizedBox(height: 0,)
            ],
          ),
          onTap: () {
            if (onDateSelected != null) {
              onDateSelected(this.date);
            }
          },
        );
      },
    );
  }
}
