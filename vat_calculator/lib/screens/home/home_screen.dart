import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {

  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: Row(
              children: [
                Text(
                  "Ciao ${dataBundleNotifier.dataBundleList[0].firstName}",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(20),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            elevation: 5,
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: IconButton(icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.white,
                ),
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(
                                    Radius.circular(10.0))),
                            content: Builder(
                              builder: (context) {
                                var height = MediaQuery.of(context).size.height;
                                var width = MediaQuery.of(context).size.width;
                                return SizedBox(
                                  height: height - 250,
                                  width: width - 90,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                topLeft: Radius.circular(10.0) ),
                                            color: Colors.deepOrange,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('  Calendario',style: TextStyle(
                                                    fontSize: getProportionateScreenWidth(20),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),),
                                                  IconButton(icon: const Icon(
                                                    Icons.clear,
                                                    color: Colors.white,
                                                  ), onPressed: () { Navigator.pop(context); },),

                                                ],
                                              ),
                                              Column(
                                                children: [

                                                  Column(
                                                    children: buildDateList(dataBundleNotifier, context),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // buildDateList(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                      );
                    }),
              ),
              const SizedBox(width: 8,),
            ],
          ),
          body: const Body(),
          bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.home),
        );
      },
    );
  }

  buildDateList(DataBundleNotifier dataBundleNotifier, BuildContext context) {
    List<Widget> branchWidgetList = [];
    List<DateTime> dateTimeList = [
      DateTime.now().subtract(const Duration(days: 9)),
      DateTime.now().subtract(const Duration(days: 8)),
      DateTime.now().subtract(const Duration(days: 7)),
      DateTime.now().subtract(const Duration(days: 6)),
      DateTime.now().subtract(const Duration(days: 5)),
      DateTime.now().subtract(const Duration(days: 4)),
      DateTime.now().subtract(const Duration(days: 3)),
      DateTime.now().subtract(const Duration(days: 2)),
      DateTime.now().subtract(const Duration(days: 1)),
      DateTime.now(),
      DateTime.now().add(const Duration(days: 1)),
      DateTime.now().add(const Duration(days: 2)),
      DateTime.now().add(const Duration(days: 3)),
      DateTime.now().add(const Duration(days: 4)),
      DateTime.now().add(const Duration(days: 5)),
      DateTime.now().add(const Duration(days: 6)),
      DateTime.now().add(const Duration(days: 7)),
      DateTime.now().add(const Duration(days: 8)),
      DateTime.now().add(const Duration(days: 9)),
      DateTime.now().add(const Duration(days: 10)),
      DateTime.now().add(const Duration(days: 11)),
    ];

    dateTimeList.forEach((currentDate) {
      branchWidgetList.add(
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: (dataBundleNotifier.currentDateTime.day == currentDate.day
                  && dataBundleNotifier.currentDateTime.month == currentDate.month) ? Colors.grey : Colors.white,
              border: const Border(
                bottom: BorderSide(width: 1.0, color: Colors.blueGrey),

              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  currentDate.day == DateTime.now().day ?
                  Text('  OGGI',
                    style: TextStyle(
                      fontSize: (dataBundleNotifier.currentDateTime.day == currentDate.day
                          && dataBundleNotifier.currentDateTime.month == currentDate.month) ? getProportionateScreenWidth(16) : getProportionateScreenWidth(13),
                      color: (dataBundleNotifier.currentDateTime.day == currentDate.day
                          && dataBundleNotifier.currentDateTime.month == currentDate.month) ? Colors.white : Colors.black,
                    ),) :
                  Text('  '  + currentDate.day.toString() + '.' + currentDate.month.toString() + ' ' + getNameDayFromWeekDay(currentDate.weekday),
                    style: TextStyle(
                      fontSize: (dataBundleNotifier.currentDateTime.day == currentDate.day
                          && dataBundleNotifier.currentDateTime.month == currentDate.month) ? getProportionateScreenWidth(16) : getProportionateScreenWidth(13),
                      color: (dataBundleNotifier.currentDateTime.day == currentDate.day
                          && dataBundleNotifier.currentDateTime.month == currentDate.month) ? Colors.white : Colors.black,
                    ),),
                ],
              ),
            ),
          ),
          onTap: () {
            dataBundleNotifier.setCurrentDateTime(currentDate);
            Navigator.pop(context);
          },
        ),
      );
    });
    return branchWidgetList;
  }
}