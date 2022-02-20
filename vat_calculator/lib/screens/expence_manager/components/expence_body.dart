import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/expence_model.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'expence_reg_card.dart';

class ExpenceBodyWidget extends StatefulWidget {
  const ExpenceBodyWidget({Key key}) : super(key: key);

  @override
  _ExpenceBodyWidgetState createState() => _ExpenceBodyWidgetState();
}

class _ExpenceBodyWidgetState extends State<ExpenceBodyWidget> {

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Container(
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
      Map<String, List<ExpenceModel>> notFiscalMap = {};
      Map<String, List<ExpenceModel>> fiscalMap = {};
      retrieveExpencesListByBranch.forEach((exepence) {
        if(dataBundleNotifier.currentWeek.start.isBefore(DateTime.fromMillisecondsSinceEpoch(exepence.dateTimeExpence)) &&
            dataBundleNotifier.currentWeek.end.isAfter(DateTime.fromMillisecondsSinceEpoch(exepence.dateTimeExpence).subtract(const Duration(days: 1)))){

          if(exepence.fiscal == 'Y'){
            if(fiscalMap.containsKey(_buildDateKeyFromDate(DateTime.fromMillisecondsSinceEpoch(exepence.dateTimeExpence)))){
              fiscalMap[_buildDateKeyFromDate(DateTime.fromMillisecondsSinceEpoch(exepence.dateTimeExpence))].add(exepence);
            }else{
              fiscalMap[_buildDateKeyFromDate(DateTime.fromMillisecondsSinceEpoch(exepence.dateTimeExpence))] = [exepence];
            }
          }else if(exepence.fiscal == 'N'){
            if(notFiscalMap.containsKey(_buildDateKeyFromDate(DateTime.fromMillisecondsSinceEpoch(exepence.dateTimeExpence)))){
              notFiscalMap[_buildDateKeyFromDate(DateTime.fromMillisecondsSinceEpoch(exepence.dateTimeExpence))].add(exepence);
            }else{
              notFiscalMap[_buildDateKeyFromDate(DateTime.fromMillisecondsSinceEpoch(exepence.dateTimeExpence))] = [exepence];
            }
          }else{
            print('Error - not manageable expence type');
          }
        }
      });

      print(notFiscalMap.toString());
      print(fiscalMap.toString());


      List<TableRow> tableRows = [const TableRow(children: [
        TableCell(child: Text('Data')),
        TableCell(
          child: Text('Fiscali'),
        ),
        TableCell(child: Text('Dettagli')),
        TableCell(child: Text('NonFiscale')),
        TableCell(child: Text('Dettagli')),
      ]),
      ];


      int lenghtNotFiscal = notFiscalMap.length;
      int lenghtFiscal = fiscalMap.length;


      notFiscalMap.forEach((key, value) {
        value.forEach((expence) {
          tableRows.add(
            TableRow(children: [
              TableCell(child: Text(key)),
              TableCell(
                child: Text(expence.amount.toString()),
              ),
              TableCell(child: Text(expence.description)),
              TableCell(child: Text('NonFiscale')),
              TableCell(child: Text('Dettagli')),
            ]),
          );
        });

      });

      return Table(

        children: tableRows,
      );
    }catch(e){
      print(e);
    }
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
}
