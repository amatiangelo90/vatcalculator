import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/swagger/swagger.models.swagger.dart';
import '../../../constants.dart';
import 'event_manager_screen.dart';

class EventsBodyWidget extends StatelessWidget {
  const EventsBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return  SfCalendar(
          allowViewNavigation: true,
          onTap: (CalendarTapDetails as){
            if(as.appointments!.isNotEmpty){
              for (var eventAppointment in as.appointments!) {
                print(eventAppointment.id.toString());
                for (Event event in dataBundleNotifier.getCurrentBranch().events!) {
                  if(event.eventId == eventAppointment.id){
                    dataBundleNotifier.setCurrentEvent(event);
                    Navigator.pushNamed(context, EventManagerScreen.routeName);
                    break;
                  }
                }
              }
            }
          },
          backgroundColor: kCustomWhite,
          todayHighlightColor: kCustomPinkAccent,
          dataSource: _buildDataFromEventList(dataBundleNotifier.getCurrentBranch()),
          view: CalendarView.schedule,
          scheduleViewMonthHeaderBuilder: scheduleViewHeaderBuilder,
          scheduleViewSettings: const ScheduleViewSettings(
              monthHeaderSettings: MonthHeaderSettings(
                  monthFormat: 'MMMM, yyyy',
                  height: 180,
                  textAlign: TextAlign.left,
                  monthTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold))),
        );
      },
    );
  }

  Widget scheduleViewHeaderBuilder(
      BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
    final String monthName = _getMonthName(details.date.month);
    return Stack(
      children: [
        Image(
            image: ExactAssetImage('assets/imagescalendar/' + monthName + '.png'),
            fit: BoxFit.cover,
            width: details.bounds.width,
            height: details.bounds.height),
        Positioned(
          left: 55,
          right: 0,
          top: 20,
          bottom: 0,
          child: Text(
            monthName + ' ' + details.date.year.toString(),
            style: TextStyle(fontSize: 18),
          ),
        )
      ],
    );
  }

  _DataSource _buildDataFromEventList(Branch currentBranch){
    final List<Appointment> appointments = <Appointment>[];

    for (var event in currentBranch.events!) {
      appointments.add(
          Appointment(
          id: event.eventId!,
          startTime: dateFormat.parse(event.dateEvent!).add(Duration(hours: 21)),
          endTime: dateFormat.parse(event.dateEvent!).add(Duration(hours: 23, minutes: 59)),
          subject: event.name!,
          color: Color(int.parse(event.cardColor!)),
          location: event.location!,
          notes: event.dateCreation!,
      ));
    }


    return _DataSource(appointments);
  }
  String _getMonthName(int month) {
    if (month == 01) {
      return 'January';
    } else if (month == 02) {
      return 'February';
    } else if (month == 03) {
      return 'March';
    } else if (month == 04) {
      return 'April';
    } else if (month == 05) {
      return 'May';
    } else if (month == 06) {
      return 'June';
    } else if (month == 07) {
      return 'July';
    } else if (month == 08) {
      return 'August';
    } else if (month == 09) {
      return 'September';
    } else if (month == 10) {
      return 'October';
    } else if (month == 11) {
      return 'November';
    } else {
      return 'December';
    }
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
