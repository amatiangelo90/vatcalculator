import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/expence_model.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';
import 'expence_reg_card.dart';

class ExpenceBodyWidget extends StatefulWidget {
  const ExpenceBodyWidget({Key key}) : super(key: key);

  @override
  _ExpenceBodyWidgetState createState() => _ExpenceBodyWidgetState();
}

class _ExpenceBodyWidgetState extends State<ExpenceBodyWidget> {

  double width;
  double height;

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Container(
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                ExpenceCard(),
                Text(dataBundleNotifier.currentWeek.start.day.toString() + ' ' + getMonthFromMonthNumber(dataBundleNotifier.currentWeek.start.month)
                    + ' - ' +  dataBundleNotifier.currentWeek.end.day.toString() + ' ' + getMonthFromMonthNumber(dataBundleNotifier.currentWeek.end.month)),
                FutureBuilder(
                  future: _retrieveExpencesByBranchIdAndRangeDate(
                    dataBundleNotifier),
                  builder:(context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: snapshot.data,
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _retrieveExpencesByBranchIdAndRangeDate(DataBundleNotifier dataBundleNotifier) async {
    List<ExpenceModel> retrieveExpencesListByBranch
      = dataBundleNotifier.getCurrentListExpences();

    try{
      Map<String, List<ExpenceModel>> expenceMap = {};
      retrieveExpencesListByBranch.forEach((exepence) {
        if(dataBundleNotifier.currentWeek.start.isBefore(DateTime.fromMillisecondsSinceEpoch(exepence.dateTimeExpence).add(Duration(days: 1))) &&
            dataBundleNotifier.currentWeek.end.isAfter(DateTime.fromMillisecondsSinceEpoch(exepence.dateTimeExpence).subtract(const Duration(days: 1)))){

          if(expenceMap.containsKey(_buildDateKeyFromDate(DateTime.fromMillisecondsSinceEpoch(exepence.dateTimeExpence)))){
            expenceMap[_buildDateKeyFromDate(DateTime.fromMillisecondsSinceEpoch(exepence.dateTimeExpence))].add(exepence);
          }else{
            expenceMap[_buildDateKeyFromDate(DateTime.fromMillisecondsSinceEpoch(exepence.dateTimeExpence))] = [exepence];
          }
        }
      });

      List<DateTime> listDate = calculateDaysInterval(dataBundleNotifier.currentWeek.start, dataBundleNotifier.currentWeek.end);

      List<Widget> listWidget = [];

      listDate.forEach((element) {
        listWidget.add(buildSome(element, expenceMap));
      });

      return Container(
        color: kCustomWhite,
        child: Column(
          children: listWidget,
        ),
      );
    }catch(e){
      print(e);
    }
  }

  List<DateTime> calculateDaysInterval(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  _buildDateKeyFromDate(DateTime date){
    return _normalizeDayValue(date.day) + '/' + _normalizeDayValue(date.month);
  }

  String _normalizeDayValue(int day) {
    if(day < 10){
      return '0' + day.toString();
    }else{
      return day.toString();
    }
  }

  Widget buildSome(DateTime dateTime, Map<String, List<ExpenceModel>> expenceMap) {
    List<Widget> fiscalDataListWidget = buildWidgetListExpence(dateTime, expenceMap, 'Y');
    List<Widget> notFiscalDataListWidget = buildWidgetListExpence(dateTime, expenceMap, 'N');

    Column column = Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kPrimaryColor,
          ),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Daniele', textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenWidth(8),fontWeight: FontWeight.w100, color: Colors.greenAccent),),
              Text(_buildDateKeyFromDate(dateTime), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomYellow800),),
              Text('Mattia', textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenWidth(8),fontWeight: FontWeight.w100, color: Colors.lightBlueAccent),),

            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: fiscalDataListWidget,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: notFiscalDataListWidget,
            ),
          ],
        ),
      ],
    );
    return column;

  }

  List<Widget> buildWidgetListExpence(DateTime date, Map<String, List<ExpenceModel>> expenceMap, String fiscal) {

    List<Widget> list = [];

    expenceMap.forEach((key, value) {
      value.forEach((expence) {
        if(_buildDateKeyFromDate(date) == key && expence.fiscal == fiscal){
          list.add(SizedBox(
            width: width * 1/2.12,
            height: height * 1/15,
            child: GestureDetector(
              onTap: (){
                TextEditingController _amountContoller = TextEditingController(text: expence.amount.toString());
                TextEditingController _descriptionContoller = TextEditingController(text: expence.description);
                TextEditingController _fiscalContoller = TextEditingController(text: expence.fiscal);

                showDialog(
                    context: context,
                    builder: (_) => AlertDialog (
                      actions: [
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceAround,
                          children: [

                          ],
                        ),
                      ],
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
                            height: getProportionateScreenHeight(400),
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
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: getProportionateScreenWidth(15),
                                              fontWeight: FontWeight.bold,
                                              color: kCustomWhite,
                                            )),
                                        IconButton(icon: const Icon(
                                          Icons.clear,
                                          color: kPrimaryColor,
                                        ), onPressed: () { Navigator.pop(context); },),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text('Importo'),
                                      SizedBox(
                                        height: 50,
                                        width: 130,
                                        child: TextField(
                                        controller: _amountContoller,
                                        decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Amount Name',
                                        ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                elevation: 0,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: fiscal == 'Y' ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: fiscal == 'Y' ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(expence.amount.toString(), style: TextStyle(fontSize: getProportionateScreenWidth(17),fontWeight: FontWeight.bold),),
                        Text(expence.description, style: TextStyle(fontSize: getProportionateScreenWidth(10),fontWeight: FontWeight.bold),),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ));
        }
      });
    });
    if(list.isEmpty){
      list.add(SizedBox(
        width: width * 1/2.12,
        height: height * 1/16,
        child: Card(
          elevation: 0,
          color: kCustomWhite,
          child: Row(
            mainAxisAlignment: fiscal == 'Y' ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: fiscal == 'Y' ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: fiscal == 'Y' ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text('', style: TextStyle(fontSize: getProportionateScreenWidth(17),fontWeight: FontWeight.bold),),
                ],
              ),

            ],
          ),
        ),
      ));
    }
    return list;
  }

}
