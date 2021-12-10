import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vat_calculator/components/vat_data.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

class ColumnRecessedChartWidget extends StatefulWidget {
  ColumnRecessedChartWidget({Key key, this.currentDateTimeRange}) : super(key: key);

  final DateTimeRange currentDateTimeRange;

  @override
  _ColumnRecessedChartWidgetState createState() => _ColumnRecessedChartWidgetState();
}

class _ColumnRecessedChartWidgetState extends State<ColumnRecessedChartWidget> {

  List<CharData> fattureInCloudData = [];

  Widget build(BuildContext context) {
    return Container(
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, _) {
          return Center(
              child: SfCartesianChart(
                  backgroundColor: Colors.white,
                  enableAxisAnimation: true,
                  primaryXAxis: DateTimeAxis(),
                  series: <ChartSeries>[
                    ColumnSeries<CharData, DateTime>(
                        width: 0.1,
                        color: Colors.deepOrange.shade700.withOpacity(0.7),
                        dataSource: dataBundleNotifier.recessedListCharData,
                        xValueMapper: (CharData sales, _) => sales.date,
                        yValueMapper: (CharData sales, _) => sales.value),
                  ]
              ));
        },
      ),
    );
  }





}
