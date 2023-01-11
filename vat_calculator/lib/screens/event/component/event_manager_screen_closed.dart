import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';
import 'package:vat_calculator/swagger/swagger.models.swagger.dart';

import '../../../swagger/swagger.enums.swagger.dart';
import 'event_manager_screen.dart';

class EventManagerScreenClosed extends StatelessWidget {
  const EventManagerScreenClosed({Key? key}) : super(key: key);

  static String routeName = 'event_manager_screen_closed';


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Scaffold(
          appBar: AppBar(
            title: Text('Archivio Eventi', style: TextStyle(fontSize: getProportionateScreenWidth(20), color: kCustomGrey),),
          ),
          body: buildClosedEventListWidget(dataBundleNotifier, context),
        );
      },
    );
  }

  buildClosedEventListWidget(DataBundleNotifier dataBundleNotifier, BuildContext context) {
    List<Widget> list = [];
    for (var event in dataBundleNotifier.getListEventClosed()) {
      list.add(Padding(
        padding: const EdgeInsets.only(right: 10),
        child: SizedBox(
            width: getProportionateScreenWidth(600),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),

              shadowColor: kCustomGreen,
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
                title: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          event.eventStatus == EventEventStatus.aperto ? 'assets/icons/open_tabel.svg' : 'assets/icons/close_tabel.svg',
                          height: getProportionateScreenHeight(60),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(20), color: kCustomGrey)),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Location point.svg',
                                color: kCustomGrey,
                                width: getProportionateScreenHeight(11),
                              ),
                              Text(' ' + event.location! , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(14), color: kCustomGrey)),
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/calendar.svg',
                                color: kCustomGrey,
                                width: getProportionateScreenHeight(11),
                              ),
                              Text(' ' + getFormtDateToReadeableItalianDate(event.dateEvent!) , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(14), color: kCustomGrey)),
                            ],
                          ),
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
                  ],
                ),
              ),
            )),
      ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: list,
      ),
    );
  }
}
