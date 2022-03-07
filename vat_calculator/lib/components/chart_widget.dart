import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vat_calculator/components/vat_data.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

class LineChartWidget extends StatefulWidget {

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {

  Widget build(BuildContext context) {
    return Container(
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, _) {
          return Center(
              child: Column(
                children: [
                  SfCartesianChart(
                      backgroundColor: Colors.white,
                      enableAxisAnimation: true,
                      primaryXAxis: DateTimeAxis(),
                      series: <ChartSeries>[
                        LineSeries<CharData, DateTime>(
                          width: 4,
                          color: Colors.green.shade700.withOpacity(0.6),
                            dataSource: dataBundleNotifier.charDataCreditIva,
                            xValueMapper: (CharData sales, _) => sales.date,
                            yValueMapper: (CharData sales, _) => sales.value),

                        LineSeries<CharData, DateTime>(
                            width: 4,
                            color: Colors.redAccent.shade700.withOpacity(0.6),
                            dataSource: dataBundleNotifier.charDataDebitIva,
                            xValueMapper: (CharData sales, _) => sales.date,
                            yValueMapper: (CharData sales, _) => sales.value),
                      ]
                  ),

                ],
              ));
        },
      ),
    );
  }





}
