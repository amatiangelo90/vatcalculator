import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';
import 'package:vat_calculator/swagger/swagger.enums.swagger.dart';
import 'package:vat_calculator/swagger/swagger.models.swagger.dart';
import '../../../constants.dart';
import 'event_manager_screen.dart';

class EventsBodyWidget extends StatelessWidget {
  const EventsBodyWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        final String monthName = _getMonthName(DateTime.now().month);
        final String nextMonthName = _getMonthName(DateTime.now().month + 1);

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              buildImageContainerByMonth('assets/imagescalendar/${monthName}.png', monthName),
              Column(
                children: buildEventListWidgetByMonth(DateTime.now().month, context, dataBundleNotifier),
              ),
              buildImageContainerByMonth('assets/imagescalendar/${nextMonthName}.png', nextMonthName),
            ],
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    if (month == 01) {
      return 'Gennaio';
    } else if (month == 02) {
      return 'Febbraio';
    } else if (month == 03) {
      return 'Marzo';
    } else if (month == 04) {
      return 'Aprile';
    } else if (month == 05) {
      return 'Maggio';
    } else if (month == 06) {
      return 'Giugno';
    } else if (month == 07) {
      return 'Luglio';
    } else if (month == 08) {
      return 'Agosto';
    } else if (month == 09) {
      return 'Settembre';
    } else if (month == 10) {
      return 'Ottobre';
    } else if (month == 11) {
      return 'Novembre';
    } else {
      return 'Dicembre';
    }
  }

  buildImageContainerByMonth(String monthImage, String month) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [

          Container(
            height: getProportionateScreenHeight(150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage(monthImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Text(month, style: TextStyle(fontSize: getProportionateScreenHeight(30), color: Colors.black),),
          ),
        ],
      ),
    );
  }

  buildEventListForCurrentDate(Iterable<Event> events,BuildContext context, DataBundleNotifier dataBundleNotifier) {
    List<Widget> list = [];
    for (var event in events) {
      list.add(Padding(
        padding: const EdgeInsets.only(right: 10),
        child: SizedBox(
          width: getProportionateScreenWidth(600),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            shadowColor: kCustomGrey,
            elevation: 5,
            child: ListTile(
            leading: ClipRect(
              child: SvgPicture.asset(
                'assets/icons/party.svg',
                height: getProportionateScreenHeight(40),
                color: kCustomGrey,
              ),
            ),
            onTap: (){
              dataBundleNotifier.setCurrentEvent(event);
              Navigator.pushNamed(context, EventManagerScreen.routeName);
            },
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(20), color: kCustomGrey)),
                  Text('Location: ' + event.location! , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(14), color: kCustomGrey)),
                  Text(getFormtDateToReadeableItalianDate(event.dateEvent!) , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(14), color: kCustomGrey)),
                  Divider(),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/bartender.svg',
                        color: kCustomGreen,
                        width: getProportionateScreenHeight(17),
                      ),
                      Text(' Postazioni bar x ' , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(13), color: Colors.grey)),
                      Text(event.workstations!.where((element) => element.workstationType == WorkstationWorkstationType.bar).length.toString()! , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(16), color: kCustomGreen)),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/bouvette.svg',
                        color: kCustomBordeaux,
                        width: getProportionateScreenHeight(17),
                      ),
                      Text(' Postazioni champagnerie x ' , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(13), color: Colors.grey)),
                      Text(event.workstations!.where((element) => element.workstationType == WorkstationWorkstationType.champagnerie).length.toString()! , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(16), color: kCustomBordeaux)),
                    ],
                  ),
                  Divider(),
                  Text('Creato da ' + event.createdBy! , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(10), color: Colors.grey)),
                ],
              ),
            ),
          ),
        )),
      ));
    }
    if(list.isEmpty){
      list.add(Text('Non ci sono eventi in programma', style: TextStyle(color: kCustomWhite)));
    }
    return list;
  }

  buildEventListWidgetByMonth(int month, BuildContext context, DataBundleNotifier dataBundleNotifier) {

    DateTime now = DateTime.now();

    DateTimeRange range = DateTimeRange(start: now,
        end: DateTime(now.year, now.month + 1, 0));

    List<Widget> list = [];


    for (int i = 0; i <= range.end.difference(range.start).inDays+1; i++) {
      list.add(Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: range.start.add(Duration(days: i)) == DateTime.now() ? kCustomPinkAccent : kCustomGrey,
                      width: 2.0,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: getProportionateScreenHeight(90),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(getDayFromWeekDay(range.start.add(Duration(days: i)).weekday!) , style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenHeight(10))),
                        Text(range.start.add(Duration(days: i)).day.toString()!, style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenHeight(22))),
                        Text(getMonthFromMonthNumber(range.start.add(Duration(days: i)).month), style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenHeight(10)) ),
                      ],
                    ),
                  )
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Column(
                children: buildEventListForCurrentDate(dataBundleNotifier.getCurrentBranch().events!
                    .where((element) => element.dateEvent == dateFormat.format(DateTime.now().add(Duration(days: i)))),
                    context, dataBundleNotifier),
              ),
            ),
          ),
        ],
      ));
    }

    return list;
  }
}
