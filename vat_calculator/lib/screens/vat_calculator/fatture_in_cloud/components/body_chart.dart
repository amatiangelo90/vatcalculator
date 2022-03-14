import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_acquisti_api.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fatture_api.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_ndc_api.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/recessed_manager/components/recessed_reg_card.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';

class VatFattureInCloudCalculatorBodyChart extends StatefulWidget {
  const VatFattureInCloudCalculatorBodyChart({Key key}) : super(key: key);

  @override
  _VatFattureInCloudCalculatorBodyChartState createState() => _VatFattureInCloudCalculatorBodyChartState();
}

class _VatFattureInCloudCalculatorBodyChartState extends State<VatFattureInCloudCalculatorBodyChart> {

  Map<int, List<ProductOrderAmountModel>> orderIdProductListMap = {};
  String importExpences;

  @override
  void initState() {
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        if (dataBundleNotifier.userDetailsList.isEmpty ||
            dataBundleNotifier.userDetailsList[0].companyList.isEmpty) {
          return Padding(
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
                  child: CreateBranchButton(),
                ),
              ],
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () {
              setState(() {});
              return Future.delayed(const Duration(milliseconds: 500));
            },
            child: Container(
              color: kPrimaryColor,
              child: dataBundleNotifier.currentBranch.providerFatture == ''
                  ? Column(
                children: const [
                  Text(''),
                ],
              )
                  : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dataBundleNotifier.currentDateTimeRangeVatService.start.day.toString() + ' ' +
                          getMonthFromMonthNumber(dataBundleNotifier.currentDateTimeRangeVatService.start.month) +' ' +
                          dataBundleNotifier.currentDateTimeRangeVatService.start.year.toString() + ' - ' +
                          dataBundleNotifier.currentDateTimeRangeVatService.end.day.toString() +' ' +
                          getMonthFromMonthNumber(dataBundleNotifier.currentDateTimeRangeVatService.end.month) +' ' +
                          dataBundleNotifier.currentDateTimeRangeVatService.end.year.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(20)),
                    ),
                  ),
                  Expanded(child: buildChart(dataBundleNotifier),

                  ),

                  buildHeaderDetailsIvaWidget(dataBundleNotifier, MediaQuery.of(context).size.width),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  buildDateRecessedRegistrationWidget(DataBundleNotifier dataBundleNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const RecessedCard(showIndex: false, showHeader: true),
        buildLast5RecessedRegisteredWidget(dataBundleNotifier),
      ],
    );
  }

  buildLast5RecessedRegisteredWidget(DataBundleNotifier dataBundleNotifier) {

    if (dataBundleNotifier
        .getCurrentListRecessed()
        .isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Nessun incasso registrato'),
          )
        ],
      );
    }
    List<Widget> rowChildrenWidget = [];

    int lenght = 0;
    if (dataBundleNotifier
        .getCurrentListRecessed()
        .length > 5) {
      lenght = 5;
    }else{
      lenght = dataBundleNotifier
          .getCurrentListRecessed()
          .length;
    }
    dataBundleNotifier.getCurrentListRecessed().sublist(0, lenght).forEach((
        recessedModel) {

      DateTime currentDateTime = DateTime.fromMillisecondsSinceEpoch(recessedModel.dateTimeRecessed);
      rowChildrenWidget.add(Column(
        children: [
          Stack(
            children: [
              Container(
                height: getProportionateScreenWidth(40),
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle
                ),
                width: getProportionateScreenWidth(50),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(9, 12, 12, 12),
                  child: SvgPicture.asset('assets/icons/euro.svg', color: kCustomOrange,),
                ),
              ),
            ],
          ),
          Text(recessedModel.amountF.toStringAsFixed(2), style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
          Text('IVA ' + recessedModel.vat.toStringAsFixed(2) + '%', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold,fontSize: 5),),
          Text(normalizeCalendarValue(currentDateTime.day)
              + '/' + normalizeCalendarValue(currentDateTime.month)
              .toString()),

        ],
      ));
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: getProportionateScreenWidth(10),),
                  Text('Ultimi 5 incassi registrati', style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12)),),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: rowChildrenWidget.reversed.toList(),
        ),
        SizedBox(height: getProportionateScreenHeight(60),),
      ],
    );
  }

  String normalizeCalendarValue(int day) {
    if(day < 10){
      return '0' + day.toString();
    }else{
      return day.toString();
    }
  }

  double calculateVatFromListRecessed(
      List<RecessedModel> recessedListByRangeDate) {
    double totalIva = 0;
    try {
      if (recessedListByRangeDate == null || recessedListByRangeDate.isEmpty) {
        return totalIva;
      } else {
        recessedListByRangeDate.forEach((element) {
          print(element.toMap().toString());
          totalIva = totalIva + ((element.amountF + element.amountPos) * (element.vat / 100));
        });
        return totalIva;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  buildHeaderDetailsIvaWidget(DataBundleNotifier dataBundleNotifier, double width) {
    List<Widget> listOut = <Widget>[];

    double vatCredit = dataBundleNotifier.totalIvaAcquisti + dataBundleNotifier.totalIvaNdcSent;

    double vatDebit = dataBundleNotifier.totalIvaFatture +
        dataBundleNotifier.totalIvaNdcReceived;

    double currentRecessedVat = 0.0;

    dataBundleNotifier.currentListRecessed.forEach((recessedElement) {
      if(DateTime.fromMillisecondsSinceEpoch(recessedElement.dateTimeRecessed).isBefore(dataBundleNotifier.currentDateTimeRangeVatService.end)
          && DateTime.fromMillisecondsSinceEpoch(recessedElement.dateTimeRecessed).isAfter(dataBundleNotifier.currentDateTimeRangeVatService.start)){
        currentRecessedVat = currentRecessedVat + ((recessedElement.amountF + recessedElement.amountPos) / 100 * recessedElement.vat);
      }
    });

    if (vatCredit >= (vatDebit + currentRecessedVat)) {
      listOut.add(Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.green.withOpacity(0.7), width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Iva a Credito',
                  style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(15)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '€ ' +
                        (vatCredit - (vatDebit + currentRecessedVat))
                            .toStringAsFixed(2),
                    style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(30)),
                  ),
                ),

              ],
            ),
          ),
          color: Colors.green.withOpacity(0.7),
        ),
      ));
    } else {
      listOut.add(Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white12, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Iva a Debito',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '€ ' +
                        ((vatDebit + currentRecessedVat) - vatCredit)
                            .toStringAsFixed(2),
                    style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(30)),
                  ),
                ),
              ],
            ),
          ),
          color: kPinaColor,
        ),
      ));
    }

    return Column(
      children: listOut,
    );
  }

  buildChart(DataBundleNotifier dataBundleNotifier) {


    int days = dataBundleNotifier.currentDateTimeRangeVatService.end.difference(dataBundleNotifier.currentDateTimeRangeVatService.start).inDays;

    List<String> xAxisValues = buildAxisValueList(dataBundleNotifier.currentDateTimeRangeVatService);

    int index = getIndexToRemoveData(dataBundleNotifier.currentDateTimeRangeVatService);


    List<FlSpot> listCreditVat = [];

    double currentValue = 0.0;
    for(int i = 0; i < xAxisValues.length; i++){

      if(i <= index){
        currentValue = currentValue + getAmountForCurrentDateFromAcquistiList(dataBundleNotifier.retrieveListaAcquisti,
            dataBundleNotifier.currentDateTimeRangeVatService.start.add(Duration(days: i)), 'spesa');

        currentValue = currentValue + getAmountForCurrentDateFromNDCList(dataBundleNotifier.retrieveListaNDC,
            dataBundleNotifier.currentDateTimeRangeVatService.start.add(Duration(days: i)));

        listCreditVat.add(FlSpot(double.parse(i.toString()), double.parse(currentValue.toStringAsFixed(2))));
      }

    }



    List<FlSpot> listDebitVat = [];

    double currentDebitValue = 0.0;
    for(int i = 0; i < xAxisValues.length; i++){
      if(i <= index){
        currentDebitValue = currentDebitValue + getAmountForCurrentDateFromAcquistiList(dataBundleNotifier.retrieveListaAcquisti,
            dataBundleNotifier.currentDateTimeRangeVatService.start.add(Duration(days: i)), 'ndc');

        currentDebitValue = currentDebitValue + getAmountForCurrentDateFromListaFatture(dataBundleNotifier.retrieveListaFatture,
            dataBundleNotifier.currentDateTimeRangeVatService.start.add(Duration(days: i)));

        currentDebitValue = currentDebitValue + getAmountForCurrentDateFromRecessedList(dataBundleNotifier.currentListRecessed, dataBundleNotifier.currentDateTimeRangeVatService.start.add(Duration(days: i)));

        listDebitVat.add(FlSpot(double.parse(i.toString()), double.parse(currentDebitValue.toStringAsFixed(2))));
      }
    }

    List<FlSpot> listFake = [];

    for(int i = 0; i < xAxisValues.length; i++){
      listFake.add(FlSpot(double.parse(i.toString()), currentDebitValue > currentValue ? currentDebitValue + (currentDebitValue * 0.25) : currentValue + (currentValue * 0.25)));
    }

    double weight = (days * 41.00);

    return Container(
      color: kPrimaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            height: getProportionateScreenHeight(400),
            width: getProportionateScreenWidth(weight),
            child: Container(
              padding: EdgeInsets.fromLTRB(3, 10, 40, 20),
              width: double.infinity,
              child: LineChart(

                LineChartData(
                    backgroundColor: kPrimaryColor,
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: SideTitles(
                          getTextStyles: (context, value) => TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(10)),
                          showTitles: true,

                      ),

                      topTitles: SideTitles(showTitles: false),
                      bottomTitles: SideTitles(
                          getTextStyles: (context, value) => TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(12) ),
                          showTitles: true,
                          getTitles: (index) {
                            return xAxisValues[index.toInt()];
                          }),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                          show: false,
                          colors: [kPrimaryColor],
                          spots: listFake
                      ),
                      LineChartBarData(
                          colors: [kCustomBlueAccent, kCustomBlueAccent, kCustomBlueAccent],
                          spots: listCreditVat
                      ),
                      LineChartBarData(
                          colors: [Colors.red.shade800.withOpacity(0.9), Colors.red.shade400.withOpacity(0.9), Colors.redAccent.withOpacity(0.9)],
                          spots: listDebitVat
                      ),

                    ]
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }

  List<String> buildAxisValueList(DateTimeRange currentDateTimeRangeVatService) {

    int daysNumber = currentDateTimeRangeVatService.end.difference(currentDateTimeRangeVatService.start).inDays;
    List<String> axisValue = [];

    for(int i = 0; i <= daysNumber; i++){
      axisValue.add(normalizeCalendarValue(currentDateTimeRangeVatService.start.add(Duration(days: i)).day).toString() + '/' + currentDateTimeRangeVatService.start.add(Duration(days: i)).month.toString());
    }
    return axisValue;

  }

  int getIndexToRemoveData(DateTimeRange currentDateTimeRangeVatService) {

    int index = 10000;
    int daysNumber = currentDateTimeRangeVatService.end.difference(currentDateTimeRangeVatService.start).inDays;
    for(int i = 0; i <= daysNumber; i++){
      if(isToday(currentDateTimeRangeVatService.start.add(Duration(days: i)).millisecondsSinceEpoch)){
        index = i;
      }
    }
    return index;

  }

  double getAmountForCurrentDateFromAcquistiList(List<ResponseAcquistiApi> retrieveListaAcquisti, DateTime dateTarget, String tipo) {
    double totalForCurrenDay = 0.0;

    retrieveListaAcquisti.forEach((acquisto) {
      if(acquisto.tipo == tipo && acquisto.data == normalizeCalendarValue(dateTarget.day).toString()+'/'+normalizeCalendarValue(dateTarget.month).toString()+'/'+dateTarget.year.toString()){
        totalForCurrenDay = totalForCurrenDay + double.parse(acquisto.importo_iva);
      }
    });
    return totalForCurrenDay;
  }

  double getAmountForCurrentDateFromNDCList(List<ResponseNDCApi> retrieveListaNDC, DateTime dateTarget) {
    double totalForCurrenDay = 0.0;

    retrieveListaNDC.forEach((ndc) {
      if(ndc.data == normalizeCalendarValue(dateTarget.day).toString()+'/'+normalizeCalendarValue(dateTarget.month).toString()+'/'+dateTarget.year.toString()){
        totalForCurrenDay = totalForCurrenDay + (double.parse(ndc.importo_totale) - double.parse(ndc.importo_netto) );
      }
    });
    return totalForCurrenDay;
  }

  double getAmountForCurrentDateFromListaFatture(List<ResponseFattureApi> retrieveListaFatture, DateTime dateTarget) {
    double totalForCurrenDay = 0.0;

    retrieveListaFatture.forEach((fattura) {
      if(fattura.data == normalizeCalendarValue(dateTarget.day).toString()+'/'+normalizeCalendarValue(dateTarget.month).toString()+'/'+dateTarget.year.toString()){
        totalForCurrenDay = totalForCurrenDay + (double.parse(fattura.importo_totale) - double.parse(fattura.importo_netto) );
      }
    });
    return totalForCurrenDay;
  }

  double getAmountForCurrentDateFromRecessedList(List<RecessedModel> currentListRecessed, DateTime dateTarget) {
    double totalForCurrenDay = 0.0;

    currentListRecessed.forEach((recessed) {
      String date =
          normalizeCalendarValue(DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).day).toString() + '/' +
              normalizeCalendarValue(DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).month).toString() + '/' +
              DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).year.toString();

      if(date == normalizeCalendarValue(dateTarget.day).toString()+'/'+normalizeCalendarValue(dateTarget.month).toString()+'/'+dateTarget.year.toString()){
        totalForCurrenDay = totalForCurrenDay + ((recessed.amountF / 100 * recessed.vat) + (recessed.amountPos / 100 * recessed.vat) );
      }
    });
    return totalForCurrenDay;


  }
}
