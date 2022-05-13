import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_acquisti_api.dart';
import 'package:vat_calculator/size_config.dart';

class ActiveProjectsCard extends StatelessWidget {
  final Color cardColor;
  final double loadingPercent;
  final double loadingPercentIva;
  final String title;
  final List<ResponseAcquistiApi> listFatture;
  final Function function;

  ActiveProjectsCard({
    this.cardColor,
    this.loadingPercent,
    this.loadingPercentIva,
    this.title,
    this.listFatture,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: function,
        child: Container(

          margin: EdgeInsets.symmetric(vertical: 5.0),
          padding: EdgeInsets.all(11.0),
          height: getProportionateScreenHeight(220),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text('Importo Netto ', style: const TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white, fontSize: 10),),
                        CircularPercentIndicator(
                          animation: true,
                          radius: 80.0,
                          percent: loadingPercent,
                          lineWidth: 5.0,
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor: Colors.white10,
                          progressColor: Colors.white,
                          center: Text(
                            '${(loadingPercent*100).round()}%',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                        Text('€ ' + calculateTot(listFatture), style: const TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text('Importo Iva ', style: const TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white, fontSize: 10),),
                        CircularPercentIndicator(
                          animation: true,
                          radius: 80.0,
                          percent: loadingPercentIva,
                          lineWidth: 5.0,
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor: Colors.white10,
                          progressColor: Colors.white,
                          center: Text(
                            '${(loadingPercentIva*100).round()}%',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                        Text('€ ' + calculateIva(listFatture), style: const TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white),),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Fatture presenti: ' + listFatture.length.toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String calculateIva(List<ResponseAcquistiApi> listFatture) {
    double totaleIva = 0.0;

    listFatture.forEach((fattura) {
      totaleIva = totaleIva + double.parse(fattura.importo_iva);
    });

    return totaleIva.toStringAsFixed(2);
  }

  String calculateTot(List<ResponseAcquistiApi> listFatture) {
    double totale = 0.0;

    listFatture.forEach((fattura) {
      totale = totale + double.parse(fattura.importo_netto);
    });

    return totale.toStringAsFixed(2);

  }
}
