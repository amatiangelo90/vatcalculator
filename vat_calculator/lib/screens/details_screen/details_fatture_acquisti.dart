import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_acquisti_api.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../components/fatt_suppl_details_card.dart';
import '../../components/light_colors.dart';
import '../../components/top_container.dart';
import '../../size_config.dart';
import 'details_fatture_acquisti_single_supplier.dart';

class FattureAcquistiDetailsPage extends StatefulWidget {


  static String routeName = 'fatture_acquisti_details_page';

  @override
  State<FattureAcquistiDetailsPage> createState() =>
      _FattureAcquistiDetailsPageState();

  const FattureAcquistiDetailsPage({Key key}) : super(key: key);
}

class _FattureAcquistiDetailsPageState
    extends State<FattureAcquistiDetailsPage> {

  DateTimeRange _currentDateTimeRange;
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: const Text('  Dettaglio Fatture Acquisti',style: TextStyle(
                fontSize: 15.0,
                color: kCustomWhite,
                fontWeight: FontWeight.w800,
              ),),
              actions: [
                IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/calendar.svg",
                      color: Colors.white,
                      width: getProportionateScreenWidth(25),
                    ),
                    onPressed: () {
                      _selectDateTimeRange(context, dataBundleNotifier);
                    }),
              ],
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
              children: [
                TopContainer(
                  height: 200,
                  width: width,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        dataBundleNotifier.fattureInCloudCompanyInfo != null ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(dataBundleNotifier.fattureInCloudCompanyInfo.nome, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: getProportionateScreenHeight(15)),),
                        ) : Text(''),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              CircularPercentIndicator(
                                radius: 90.0,
                                lineWidth: 5.0,
                                animation: true,
                                percent: 1,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Colors.lightBlueAccent,
                                backgroundColor: kPrimaryColor,
                                center: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 35.0,
                                  child: ClipOval(

                                    child: Image.asset(
                                        'assets/images/fattureincloud.png',
                                      ),
                                  ),
                                ),
                              ),
                              Text(''),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    dataBundleNotifier.currentDateTimeRangeVatService.start.day.toString() + ' ' +
                                        getMonthFromMonthNumber(dataBundleNotifier.currentDateTimeRangeVatService.start.month) +' ' +
                                        dataBundleNotifier.currentDateTimeRangeVatService.start.year.toString() + ' - ' +
                                        dataBundleNotifier.currentDateTimeRangeVatService.end.day.toString() +' ' +
                                        getMonthFromMonthNumber(dataBundleNotifier.currentDateTimeRangeVatService.end.month) +' ' +
                                        dataBundleNotifier.currentDateTimeRangeVatService.end.year.toString(), style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),),
                                  Container(
                                    child: Text(
                                      'Periodo di riferimento',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: getProportionateScreenHeight(40),
                    width: getProportionateScreenWidth(500),
                    child: CupertinoTextField(
                      textInputAction: TextInputAction.next,
                      restorationId: 'Ricerca per nome fornitore',
                      keyboardType: TextInputType.text,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      placeholder: 'Ricerca per nome fornitore',
                      onChanged: (currentText) {
                        dataBundleNotifier.filterextractedAcquistiFattureByText(currentText);
                      },
                    ),
                  ),
                ),
                dataBundleNotifier.extractedAcquistiFatture.isNotEmpty ? buildSupplierWidgets(dataBundleNotifier.extractedAcquistiFatture)
                    : const Center(child: Text('Non sono presenti fatture per il periodo indicato')),
              ],
            ),
            )
        );
      },
    );
  }

  Future<void> _selectDateTimeRange(BuildContext context, DataBundleNotifier dataBundleNotifier) async {
    DateTimeRange dateTimeRange = await showDateRangePicker(
      context: context,
      initialDateRange: _currentDateTimeRange,
      firstDate: DateTime(DateTime.now().year -1, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: kCustomGreenAccent,
            ),
          ),
          child: child,
        );
      },
    );

    if (dateTimeRange != null && dateTimeRange != _currentDateTimeRange){
      dataBundleNotifier.setCurrentDateTimeRange(dateTimeRange);
    }
  }

  buildSupplierWidgets(List<ResponseAcquistiApi> extractedAcquistiFatture) {
    Set<String> suppliers = Set();
    extractedAcquistiFatture.forEach((fattura) {
      suppliers.add(fattura.nome);
    });

    List<FatturazioneDetailsSupplierCard> supplierCardList = [];

    Map<String, List<ResponseAcquistiApi>> mapRecpSuppliersFatture = {};
    suppliers.forEach((supplierName) {
      mapRecpSuppliersFatture[supplierName] = extractListFattureBySupplierName(extractedAcquistiFatture, supplierName);
    });

    suppliers.forEach((supplierName) {
      supplierCardList.add(FatturazioneDetailsSupplierCard(
        cardColor: LightColors.getRandomColor(),
        loadingPercent: calculatePercentageNetOnTotalFromFattureList(mapRecpSuppliersFatture[supplierName]),
        loadingPercentIva: calculatePercentageIvaOnTotalFromFattureList(mapRecpSuppliersFatture[supplierName]),
        title: supplierName,
        listFatture: mapRecpSuppliersFatture[supplierName],
        function: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsFattureAcquistiSingleSupplier(currentListFattureAcquisti: mapRecpSuppliersFatture[supplierName]),
            ),
          );
        }
      ),);
    });

    List<Widget> resultWidgetList = [];

    for(int i = 0; i < supplierCardList.length; i++){

      resultWidgetList.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 1),
            child: Row(
              children: <Widget>[
                supplierCardList[i],
              ],
            ),
          ),
      );
    }

    return Column(
      children: resultWidgetList,
    );

  }

  double calculatePercentageIvaOnTotalFromFattureList(List<ResponseAcquistiApi> listFatture) {
    double totalFatture = 0.0;
    double totalIva = 0.0;

    listFatture.forEach((element) {
      totalFatture = totalFatture + double.parse(element.importo_totale);
      totalIva = totalIva + double.parse(element.importo_iva);
    });
    double percentage = totalIva / (totalIva + totalFatture);

    return percentage;
  }

  double calculatePercentageNetOnTotalFromFattureList(List<ResponseAcquistiApi> listFatture) {
    double totalFatture = 0.0;
    double totalIva = 0.0;

    listFatture.forEach((element) {
      totalFatture = totalFatture + double.parse(element.importo_totale);
      totalIva = totalIva + double.parse(element.importo_iva);
    });
    double percentage = totalFatture / (totalIva + totalFatture);

    return percentage;
  }

  List<ResponseAcquistiApi> extractListFattureBySupplierName(List<ResponseAcquistiApi> extractedAcquistiFatture, String supplierName) {
    List<ResponseAcquistiApi> responseList = [];
    extractedAcquistiFatture.forEach((element) {
      if(element.nome == supplierName){
        responseList.add(element);
      }
    });
    return responseList;
  }

}
