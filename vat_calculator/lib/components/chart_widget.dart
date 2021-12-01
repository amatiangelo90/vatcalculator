import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vat_calculator/client/fattureICloud/client_icloud.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_acquisti_api.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fatture_api.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_ndc_api.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';

import '../constants.dart';

class LineChartWidget extends StatefulWidget {
  LineChartWidget({Key key, this.currentDateTimeRange}) : super(key: key);

  final DateTimeRange currentDateTimeRange;

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<SalesData> charDataCreditIva = [];

  List<SalesData> fattureInCloudData = [];

  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(300),
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, _) {
          return Center(
              child: Column(
            children: [
              FutureBuilder(
                  initialData: <Widget>[
                    const Center(
                        child: CircularProgressIndicator(
                      color: kPinaColor,
                    )),
                    const SizedBox(),
                    Column(
                      children: const [
                        Center(
                          child: Text(
                            'Caricamento Ordini..',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: kPrimaryColor,
                                fontFamily: 'LoraFont'),
                          ),
                        ),
                      ],
                    ),
                  ],
                  future: retrieveDataToDrawChart(
                      dataBundleNotifier,
                      widget.currentDateTimeRange),
                  builder: (context, snapshot) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [],
                      ),
                    );
                  }),
              SfCartesianChart(
                  backgroundColor: Colors.white,
                  enableAxisAnimation: true,
                  primaryXAxis: DateTimeAxis(),
                  series: <ChartSeries>[
                    // Renders line chart
                    LineSeries<SalesData, DateTime>(
                        dataSource: charDataCreditIva,
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales),
                  ]),
            ],
          ));
        },
      ),
    );
  }

  Future<List<Widget>> retrieveDataToDrawChart(
      DataBundleNotifier dataBundleNotifier,
      DateTimeRange currentDateTimeRange) async {
    FattureInCloudClient iCloudClient = FattureInCloudClient();
    List<ResponseAcquistiApi> retrieveListaAcquisti =
        await iCloudClient.retrieveListaAcquisti(
            dataBundleNotifier.currentBranch.apiUidOrPassword,
            dataBundleNotifier.currentBranch.apiKeyOrUser,
            currentDateTimeRange.start,
            currentDateTimeRange.end,
            '',
            '',
            currentDateTimeRange.start.year);

    List<ResponseFattureApi> retrieveListaFatture =
        await iCloudClient.retrieveListaFatture(
            dataBundleNotifier.currentBranch.apiUidOrPassword,
            dataBundleNotifier.currentBranch.apiKeyOrUser,
            currentDateTimeRange.start,
            currentDateTimeRange.end,
            '',
            '',
            currentDateTimeRange.start.year);

    List<ResponseNDCApi> retrieveListaNDC = await iCloudClient.retrieveListaNdc(
        dataBundleNotifier.currentBranch.apiUidOrPassword,
        dataBundleNotifier.currentBranch.apiKeyOrUser,
        currentDateTimeRange.start,
        currentDateTimeRange.end,
        '',
        '',
        currentDateTimeRange.start.year);

    double totalIvaAcquisti = 0.0;
    double totalIvaFatture = 0.0;
    double totalIvaNdcReceived = 0.0;
    double totalIvaNdcSent = 0.0;

    Map<String, double> resultCreditIvaMap =
        initializeMap(currentDateTimeRange);
    Map<String, double> resultDebitIvaMap = initializeMap(currentDateTimeRange);

    List<ResponseAcquistiApi> extractedAcquistiFatture = [];
    List<ResponseAcquistiApi> extractedNdc = [];

    retrieveListaAcquisti.forEach((acquisto) {
      if (acquisto.tipo == 'spesa') {
        if (resultCreditIvaMap.containsKey(acquisto.data)) {
          resultCreditIvaMap[acquisto.data] =
              resultCreditIvaMap[acquisto.data] +
                  double.parse(acquisto.importo_iva);
        } else {
          resultCreditIvaMap[acquisto.data] =
              double.parse(acquisto.importo_iva);
        }

        extractedAcquistiFatture.add(acquisto);
        totalIvaAcquisti =
            totalIvaAcquisti + double.parse(acquisto.importo_iva);
      } else if (acquisto.tipo == 'ndc') {
        extractedNdc.add(acquisto);
        totalIvaNdcReceived =
            totalIvaNdcReceived + double.parse(acquisto.importo_iva);

        if (resultDebitIvaMap.containsKey(acquisto.data)) {
          resultDebitIvaMap[acquisto.data] = resultDebitIvaMap[acquisto.data] +
              double.parse(acquisto.importo_iva);
        } else {
          resultDebitIvaMap[acquisto.data] = double.parse(acquisto.importo_iva);
        }
      }
    });

    retrieveListaFatture.forEach((fattura) {
      totalIvaFatture = totalIvaFatture +
          (double.parse(fattura.importo_totale) -
              double.parse(fattura.importo_netto));
      if (resultDebitIvaMap.containsKey(fattura.data)) {
        resultDebitIvaMap[fattura.data] = resultDebitIvaMap[fattura.data] +
            (double.parse(fattura.importo_totale) -
                double.parse(fattura.importo_netto));
      } else {
        resultDebitIvaMap[fattura.data] =
            (double.parse(fattura.importo_totale) -
                double.parse(fattura.importo_netto));
      }
    });

    retrieveListaNDC.forEach((ndc) {
      totalIvaNdcSent = totalIvaNdcSent +
          (double.parse(ndc.importo_totale) - double.parse(ndc.importo_netto));

      if (resultCreditIvaMap.containsKey(ndc.data)) {
        resultCreditIvaMap[ndc.data] = resultCreditIvaMap[ndc.data] +
            (double.parse(ndc.importo_totale) -
                double.parse(ndc.importo_netto));
      } else {
        resultCreditIvaMap[ndc.data] = (double.parse(ndc.importo_totale) -
            double.parse(ndc.importo_netto));
      }
    });

    print(resultCreditIvaMap.toString());
    print(resultDebitIvaMap.toString());


    charDataCreditIva = [
      SalesData(
          currentDateTimeRange.end.subtract(const Duration(days: 6)),
          resultCreditIvaMap[currentDateTimeRange.end
                  .subtract(const Duration(days: 6))
                  .day
                  .toString() +
              '/' +
              currentDateTimeRange.end
                  .subtract(const Duration(days: 6))
                  .month
                  .toString() +
              '/' +
              currentDateTimeRange.end
                  .subtract(const Duration(days: 6))
                  .year
                  .toString()]),
      SalesData(
          currentDateTimeRange.end.subtract(const Duration(days: 5)),
          resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 5))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 5))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 5))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 6))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 6))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 6))
                      .year
                      .toString()]),
      SalesData(
          currentDateTimeRange.end.subtract(const Duration(days: 4)),
          resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 4))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 4))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 4))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 5))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 5))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 5))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 6))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 6))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 6))
                      .year
                      .toString()]),
      SalesData(
          currentDateTimeRange.end.subtract(const Duration(days: 3)),
          resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 3))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 3))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 3))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 4))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 4))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 4))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 5))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 5))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 5))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 6))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 6))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 6))
                      .year
                      .toString()]),
      SalesData(
          currentDateTimeRange.end.subtract(const Duration(days: 2)),
          resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 2))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 2))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 2))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 3))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 3))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 3))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 4))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 4))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 4))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 5))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 5))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 5))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end
                      .subtract(const Duration(days: 6))
                      .day
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 6))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 6))
                      .year
                      .toString()]),
      SalesData(
          currentDateTimeRange.end.subtract(const Duration(days: 1)),
          resultCreditIvaMap[currentDateTimeRange.end.subtract(const Duration(days: 1)).day.toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 1))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 1))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end.subtract(const Duration(days: 2)).day.toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 2))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 2))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end.subtract(const Duration(days: 3)).day.toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 3))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 3))
                      .year
                      .toString()] +
              resultCreditIvaMap[
                  currentDateTimeRange.end.subtract(const Duration(days: 4)).day.toString() +
                      '/' +
                      currentDateTimeRange.end
                          .subtract(const Duration(days: 4))
                          .month
                          .toString() +
                      '/' +
                      currentDateTimeRange.end
                          .subtract(const Duration(days: 4))
                          .year
                          .toString()] +
              resultCreditIvaMap[
                  currentDateTimeRange.end.subtract(const Duration(days: 5)).day.toString() +
                      '/' +
                      currentDateTimeRange.end
                          .subtract(const Duration(days: 5))
                          .month
                          .toString() +
                      '/' +
                      currentDateTimeRange.end
                          .subtract(const Duration(days: 5))
                          .year
                          .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end.subtract(const Duration(days: 6)).day.toString() +
                  '/' +
                  currentDateTimeRange.end.subtract(const Duration(days: 6)).month.toString() +
                  '/' +
                  currentDateTimeRange.end.subtract(const Duration(days: 6)).year.toString()]),
      SalesData(
          currentDateTimeRange.end.subtract(const Duration(days: 0)),
              resultCreditIvaMap[
                currentDateTimeRange.end.subtract(
                    const Duration(days: 0)).day.toString() + '/' +
                    currentDateTimeRange.end.subtract(const Duration(days: 0)).month.toString() + '/' +
                    currentDateTimeRange.end.subtract(const Duration(days: 0)).year.toString()] +

              resultCreditIvaMap[currentDateTimeRange.end.subtract(const Duration(days: 1)).day.toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 1))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 1))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end.subtract(const Duration(days: 2)).day.toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 2))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 2))
                      .year
                      .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end.subtract(const Duration(days: 3)).day.toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 3))
                      .month
                      .toString() +
                  '/' +
                  currentDateTimeRange.end
                      .subtract(const Duration(days: 3))
                      .year
                      .toString()] +
              resultCreditIvaMap[
                  currentDateTimeRange.end.subtract(const Duration(days: 4)).day.toString() +
                      '/' +
                      currentDateTimeRange.end
                          .subtract(const Duration(days: 4))
                          .month
                          .toString() +
                      '/' +
                      currentDateTimeRange.end
                          .subtract(const Duration(days: 4))
                          .year
                          .toString()] +
              resultCreditIvaMap[
                  currentDateTimeRange.end.subtract(const Duration(days: 5)).day.toString() +
                      '/' +
                      currentDateTimeRange.end
                          .subtract(const Duration(days: 5))
                          .month
                          .toString() +
                      '/' +
                      currentDateTimeRange.end
                          .subtract(const Duration(days: 5))
                          .year
                          .toString()] +
              resultCreditIvaMap[currentDateTimeRange.end.subtract(const Duration(days: 6)).day.toString() +
                  '/' +
                  currentDateTimeRange.end.subtract(const Duration(days: 6)).month.toString() +
                  '/' +
                  currentDateTimeRange.end.subtract(const Duration(days: 6)).year.toString()]),
    ];

    charDataCreditIva.forEach((element) {
      print(element.year.toString() + ' - ' + element.sales.toString());
    });
    print('finish');

    return [];
  }

  Map<String, double> initializeMap(DateTimeRange currentDateTimeRange) {
    Map<String, double> mapToReturn = {};

    mapToReturn[currentDateTimeRange.end
            .subtract(Duration(days: 6))
            .day
            .toString() +
        '/' +
        currentDateTimeRange.end.subtract(Duration(days: 6)).month.toString() +
        '/' +
        currentDateTimeRange.end
            .subtract(Duration(days: 6))
            .year
            .toString()] = 0;
    mapToReturn[currentDateTimeRange.end
            .subtract(Duration(days: 5))
            .day
            .toString() +
        '/' +
        currentDateTimeRange.end.subtract(Duration(days: 5)).month.toString() +
        '/' +
        currentDateTimeRange.end
            .subtract(Duration(days: 5))
            .year
            .toString()] = 0;
    mapToReturn[currentDateTimeRange.end
            .subtract(Duration(days: 4))
            .day
            .toString() +
        '/' +
        currentDateTimeRange.end.subtract(Duration(days: 4)).month.toString() +
        '/' +
        currentDateTimeRange.end
            .subtract(Duration(days: 4))
            .year
            .toString()] = 0;
    mapToReturn[currentDateTimeRange.end
            .subtract(Duration(days: 3))
            .day
            .toString() +
        '/' +
        currentDateTimeRange.end.subtract(Duration(days: 3)).month.toString() +
        '/' +
        currentDateTimeRange.end
            .subtract(Duration(days: 3))
            .year
            .toString()] = 0;
    mapToReturn[currentDateTimeRange.end
            .subtract(Duration(days: 2))
            .day
            .toString() +
        '/' +
        currentDateTimeRange.end.subtract(Duration(days: 2)).month.toString() +
        '/' +
        currentDateTimeRange.end
            .subtract(Duration(days: 2))
            .year
            .toString()] = 0;
    mapToReturn[currentDateTimeRange.end
            .subtract(Duration(days: 1))
            .day
            .toString() +
        '/' +
        currentDateTimeRange.end.subtract(Duration(days: 1)).month.toString() +
        '/' +
        currentDateTimeRange.end
            .subtract(Duration(days: 1))
            .year
            .toString()] = 0;
    mapToReturn[currentDateTimeRange.end
            .subtract(Duration(days: 0))
            .day
            .toString() +
        '/' +
        currentDateTimeRange.end.subtract(Duration(days: 0)).month.toString() +
        '/' +
        currentDateTimeRange.end
            .subtract(Duration(days: 0))
            .year
            .toString()] = 0;

    return mapToReturn;
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}
