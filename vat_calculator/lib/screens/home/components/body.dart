import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/branch_registration/branch_choice_registration.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return dataBundleNotifier.dataBundleList.isEmpty || dataBundleNotifier.dataBundleList[0].companyList.isEmpty ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sembra che tu non abbia configurato ancora nessuna attività. ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(13),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                child: DefaultButton(
                  text: "Crea Attività",
                  press: () async {
                    Navigator.pushNamed(context, BranchChoiceCreationEnjoy.routeName);
                  },
                ),
              ),
            ],
          ),
        ) : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  width: double.infinity,
                  height: getProportionateScreenHeight(56),
                  child: buildGestureDetectorBranchSelector(context, dataBundleNotifier),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: IconButton(icon: const Icon(
                      Icons.arrow_back_ios,
                      color: kPrimaryColor,
                    ), onPressed: () { dataBundleNotifier.removeOneDayToDate(); },),
                  ),
                  GestureDetector(
                      onTap: (){
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog (
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
                                                color: kPrimaryColor,
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('  Calendario',style: TextStyle(
                                                        fontSize: getProportionateScreenWidth(20),
                                                        fontWeight: FontWeight.bold,
                                                        color: kCustomWhite,
                                                      ),),
                                                      IconButton(icon: const Icon(
                                                        Icons.clear,
                                                        color: kCustomWhite,
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
                      },
                      child: Text(dataBundleNotifier.getCurrentDate(), style: TextStyle(fontSize: 20),)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: IconButton(icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: kPrimaryColor,
                    ), onPressed: () { dataBundleNotifier.addOneDayToDate(); },),
                  ),
                ],
              ),

            ],
          ),
        );
      },
    );
  }

  GestureDetector buildGestureDetectorBranchSelector(BuildContext context,
      DataBundleNotifier dataBundleNotifier) {
    return GestureDetector(
                onTap: () {
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

                            return SizedBox(
                              width: getProportionateScreenWidth(800),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            topLeft: Radius.circular(10.0) ),
                                        color: kPrimaryColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('  Lista Attività',style: TextStyle(
                                            fontSize: getProportionateScreenWidth(17),
                                            color: Colors.white,
                                          ),),
                                          IconButton(icon: const Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                          ), onPressed: () { Navigator.pop(context); },),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: buildListBranches(dataBundleNotifier),
                                    ),
                                    SizedBox(height: getProportionateScreenHeight(10),),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.green.shade700,
                  elevation: 7,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                          child: Text('' + dataBundleNotifier.currentBranch.companyName,
                            style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(15)),),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: getProportionateScreenWidth(18),),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }

  buildListBranches(DataBundleNotifier dataBundleNotifier) {

    List<Widget> branchWidgetList = [];

    dataBundleNotifier.dataBundleList[0].companyList.forEach((currentBranch) {
      branchWidgetList.add(
        GestureDetector(
            child: Container(
                  decoration: BoxDecoration(
                    color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.green.shade700 : Colors.white,
                    border: const Border(
                      bottom: BorderSide(width: 1.0, color: Colors.grey),
                    ),
                 ),
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.format_align_right_rounded, color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.white : kPrimaryColor,),
                    Icon(currentBranch.accessPrivilege == Privileges.EMPLOYEE ? Icons.person : Icons.vpn_key_outlined, color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.white : kPrimaryColor,),
                    Text('   ' + currentBranch.companyName,
                      style: TextStyle(
                      fontSize: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? getProportionateScreenWidth(16) : getProportionateScreenWidth(13),
                        color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.white : Colors.black,
                    ),),
                  ],
                ),
              ),
            ),
            onTap: () async {
              context.loaderOverlay.show();
              Navigator.pop(context);
              await dataBundleNotifier.setCurrentBranch(currentBranch);
              context.loaderOverlay.hide();

            },
        ),
      );
    });
    return branchWidgetList;
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
                  && dataBundleNotifier.currentDateTime.month == currentDate.month) ? Colors.grey : kCustomWhite,
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

