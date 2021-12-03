import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vat_calculator/components/vat_data.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/registration_provider/fatture_provider_registration.dart';
import 'package:vat_calculator/screens/vat_calculator/aruba/aruba_home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/fatture_in_cloud_home_screen.dart';
import 'package:vat_calculator/size_config.dart';

import '../constants.dart';

class LineChartWidget extends StatefulWidget {
  LineChartWidget({Key key, this.currentDateTimeRange}) : super(key: key);

  final DateTimeRange currentDateTimeRange;

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {

  List<VatData> fattureInCloudData = [];

  Widget build(BuildContext context) {
    return Container(
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, _) {
          return Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: getProportionateScreenWidth(10),),
                        Text('Situazione Iva', style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12)),),
                      ],
                    ),
                    CupertinoButton(
                      onPressed: (){
                        dataBundleNotifier.setShowIvaButtonToFalse();
                        switch(dataBundleNotifier.currentBranch.providerFatture){
                          case 'fatture_in_cloud':
                            Navigator.pushNamed(context, FattureInCloudCalculatorScreen.routeName);
                            break;
                          case 'aruba':
                            Navigator.pushNamed(context, ArubaCalculatorScreen.routeName);
                            break;
                          case '':
                            Navigator.pushNamed(context, RegisterFattureProviderScreen.routeName);
                            break;
                        }
                      },
                      child: Row(
                        children: [
                          Text('Dettagli', style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12), color: Colors.grey),),
                          Icon(Icons.arrow_forward_ios, size: getProportionateScreenWidth(15), color: Colors.grey),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.green.shade700.withOpacity(0.6),
                        ),
                        Text('Iva Credito'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.redAccent.withOpacity(0.6),
                        ),
                        Text('Iva Debito'),
                      ],
                    ),
                  ],
                ),
              ),
              SfCartesianChart(
                  backgroundColor: Colors.white,
                  enableAxisAnimation: true,
                  primaryXAxis: DateTimeAxis(),
                  series: <ChartSeries>[
                    LineSeries<VatData, DateTime>(
                      width: 3,
                      color: Colors.green.shade700.withOpacity(0.6),
                        dataSource: dataBundleNotifier.charDataCreditIva,
                        xValueMapper: (VatData sales, _) => sales.date,
                        yValueMapper: (VatData sales, _) => sales.vatValue),

                    LineSeries<VatData, DateTime>(
                      width: 3,
                      color: Colors.redAccent.shade700.withOpacity(0.6),
                        dataSource: dataBundleNotifier.charDataDebitIva,
                        xValueMapper: (VatData sales, _) => sales.date,
                        yValueMapper: (VatData sales, _) => sales.vatValue),
                  ]),
            ],
          ));
        },
      ),
    );
  }





}
