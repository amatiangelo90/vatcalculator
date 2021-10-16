import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/client_icloud.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_acquisti_api.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fatture_api.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_ndc_api.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/profile/components/profile_menu.dart';
import 'package:vat_calculator/screens/registration_company/registration_company_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class VatCalculatorBody extends StatefulWidget {
  const VatCalculatorBody({Key key}) : super(key: key);

  @override
  _VatCalculatorBodyState createState() => _VatCalculatorBodyState();
}

class _VatCalculatorBodyState extends State<VatCalculatorBody> {
  DateTimeRange _currentDateTimeRange;
  FattureInCloudClient iCloudClient;
  DateTime _currentDateForDateRangePicker;
  double _width;


  @override
  void initState() {
    _currentDateForDateRangePicker = DateTime.now();

    _currentDateTimeRange = DateTimeRange(
      start: _currentDateForDateRangePicker
          .subtract(Duration(days: _currentDateForDateRangePicker.weekday - 1)),
      end: _currentDateForDateRangePicker.add(Duration(
          days: DateTime.daysPerWeek - _currentDateForDateRangePicker.weekday)),
    );
    iCloudClient = FattureInCloudClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;

    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
      return dataBundleNotifier.currentBranch == null ? Padding(
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
                  Navigator.pushNamed(context, RegistrationCompanyScreen.routeName);
                },
              ),
            ),
          ],
        ),
      ) : SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 39,
              child: Column(
                children: [
                  Column(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: kPrimaryColor,
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: const Color(0xFFF5F6F9),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Center(child: Text(dataBundleNotifier.currentBranch.companyName, style: const TextStyle(color: kPinaColor,fontSize: 30),))),
                              ],
                            ),
                            GestureDetector(
                              onTap: (){
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
                                          var height = MediaQuery.of(context).size.height;
                                          var width = MediaQuery.of(context).size.width;
                                          return SizedBox(

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
                                                            Text('  Dettagli Provider',style: TextStyle(
                                                              fontSize: getProportionateScreenWidth(20),
                                                              fontWeight: FontWeight.bold,
                                                              color: const Color(0xFFF5F6F9),
                                                            ),),
                                                            IconButton(icon: const Icon(
                                                              Icons.clear,
                                                              color: Color(0xFFF5F6F9),
                                                            ), onPressed: () { Navigator.pop(context); },),

                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        width: width - 90,
                                                        child: Card(
                                                          color: dataBundleNotifier.currentBranch.providerFatture == 'fatture_in_cloud' ? Colors.blue : Colors.orange,
                                                          semanticContainer: true,
                                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                                          child: Image.asset(
                                                            dataBundleNotifier.currentBranch.providerFatture == 'fatture_in_cloud' ? 'assets/images/fattureincloud.png' : 'assets/images/aruba.png',
                                                            fit: BoxFit.contain,
                                                          ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0),
                                                          ),
                                                          elevation: 5,
                                                          margin: const EdgeInsets.all(10),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          const SizedBox(width: 22),
                                                          Text(dataBundleNotifier.currentBranch.providerFatture == 'fatture_in_cloud' ? 'ApiKey' : 'User',style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: getProportionateScreenWidth(14),
                                                            fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      ProfileMenu(
                                                        text: dataBundleNotifier.currentBranch.apiKeyOrUser,
                                                        icon: '',
                                                        press: () => {
                                                        },
                                                        showArrow: false,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const SizedBox(width: 22),
                                                          Text(dataBundleNotifier.currentBranch.providerFatture == 'fatture_in_cloud' ? 'ApiUid' : 'Password',
                                                            style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: getProportionateScreenWidth(14),
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      ProfileMenu(
                                                        text: dataBundleNotifier.currentBranch.apiUidOrPassword,
                                                        icon: '',
                                                        press: () => {
                                                        },
                                                        showArrow: false,
                                                      ),
                                                      SizedBox(height: 20,),
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
                              child: SizedBox(
                                width: 120,
                                child: Card(
                                  color: dataBundleNotifier.currentBranch.providerFatture == 'fatture_in_cloud' ? Colors.blue : Colors.orange,
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Image.asset(
                                    dataBundleNotifier.currentBranch.providerFatture == 'fatture_in_cloud' ? 'assets/images/fattureincloud.png' : 'assets/images/aruba.png',
                                    fit: BoxFit.contain,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: const EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ProfileMenu(
                        text: 'Intervallo temporale ' + _currentDateTimeRange.start.day.toString() + '/'
                            +  _currentDateTimeRange.start.month.toString()
                            +' - ' +  _currentDateTimeRange.end.day.toString() +'/'
                            +  _currentDateTimeRange.end.month.toString(),
                        icon: "assets/icons/calendar.svg",
                        press: () => {
                          _selectDateRange(context),
                          dataBundleNotifier.setShowIvaButtonToFalse(),
                        },
                        showArrow: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: DefaultButton(
                          text: "Calcola Iva",
                          press: () async {
                            dataBundleNotifier.setShowIvaButtonToTrue();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            dataBundleNotifier.showIvaButtonPressed ? buildIVAPage(dataBundleNotifier) : const SizedBox(width: 0,),
          ],
        ),
      );
    });
  }

  buildIVAPage(DataBundleNotifier dataBundleNotifier) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FutureBuilder(
            initialData: <Widget>[
          Column(
            children: const [
              Center(
                  child: CircularProgressIndicator(
                color: Colors.brown,
              )),
              SizedBox(),
              Center(
                child: Text(
                  'Caricamento dati..',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontFamily: 'LoraFont'),
                ),
              ),
            ],
          )
            ],
            future: getIvaDetailsWidget(dataBundleNotifier),
            builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: ListView(
                primary: false,
                shrinkWrap: true,
                children: snapshot.data,
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
            },
          ),
        ],
      ),
    );
  }

  Future getIvaDetailsWidget(DataBundleNotifier dataBundleNotifier) async {

    List<ResponseAcquistiApi> retrieveListaAcquisti =
        await iCloudClient.retrieveListaAcquisti(
            dataBundleNotifier.currentBranch.apiUidOrPassword,
            dataBundleNotifier.currentBranch.apiKeyOrUser,
            _currentDateTimeRange.start,
            _currentDateTimeRange.end,
            '',
            '',
            _currentDateTimeRange.start.year);

    List<ResponseFattureApi> retrieveListaFatture =
        await iCloudClient.retrieveListaFatture(
            dataBundleNotifier.currentBranch.apiUidOrPassword,
            dataBundleNotifier.currentBranch.apiKeyOrUser,
            _currentDateTimeRange.start,
            _currentDateTimeRange.end,
            '',
            '',
            _currentDateTimeRange.start.year);

    List<ResponseNDCApi> retrieveListaNDC = await iCloudClient.retrieveListaNdc(
        dataBundleNotifier.currentBranch.apiUidOrPassword,
        dataBundleNotifier.currentBranch.apiKeyOrUser,
        _currentDateTimeRange.start,
        _currentDateTimeRange.end,
        '',
        '',
        _currentDateTimeRange.start.year);

    List<Widget> listOut = <Widget>[];

    double totalIvaAcquisti = 0.0;
    double totalIvaFatture = 0.0;
    double totalIvaNdcReceived = 0.0;
    double totalIvaNdcSent = 0.0;

    List<ResponseAcquistiApi> extractedAcquistiFatture = [];
    List<ResponseAcquistiApi> extractedNdc = [];

    retrieveListaAcquisti.forEach((acquisto) {
      if (acquisto.tipo == 'spesa') {
        extractedAcquistiFatture.add(acquisto);
        totalIvaAcquisti =
            totalIvaAcquisti + double.parse(acquisto.importo_iva);
      } else if (acquisto.tipo == 'ndc') {
        extractedNdc.add(acquisto);
        totalIvaNdcReceived =
            totalIvaNdcReceived + double.parse(acquisto.importo_iva);
      }
    });

    retrieveListaFatture.forEach((fattura) {
      totalIvaFatture = totalIvaFatture +
          (double.parse(fattura.importo_totale) -
              double.parse(fattura.importo_netto));
    });

    retrieveListaNDC.forEach((ndc) {
      totalIvaNdcSent = totalIvaNdcSent +
          (double.parse(ndc.importo_totale) - double.parse(ndc.importo_netto));
    });

    if ((totalIvaAcquisti + totalIvaNdcReceived) >=
        (totalIvaFatture + totalIvaNdcSent + calculateVatFromListRecessed(dataBundleNotifier.getRecessedListByRangeDate(_currentDateTimeRange.start, _currentDateTimeRange.end)))) {
      // iva a credito
      listOut.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white12, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Iva a Credito',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '€ ' +
                      ((totalIvaNdcReceived + totalIvaAcquisti) -
                              (totalIvaFatture +
                                  totalIvaNdcSent +
                                  calculateVatFromListRecessed(dataBundleNotifier.getRecessedListByRangeDate(_currentDateTimeRange.start, _currentDateTimeRange.end))))
                          .toStringAsFixed(2),
                  style: const TextStyle(color: Colors.white, fontSize: 40),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          color: kPrimaryColor,
        ),
      ));
    } else {
      listOut.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white12, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 20,
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
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '€ ' +
                      ((totalIvaFatture + totalIvaNdcReceived + calculateVatFromListRecessed(dataBundleNotifier.getRecessedListByRangeDate(_currentDateTimeRange.start, _currentDateTimeRange.end))) - (totalIvaAcquisti + totalIvaNdcSent)).toStringAsFixed(2),
                  style: const TextStyle(color: Colors.white, fontSize: 40),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          color: Colors.deepOrange,
        ),
      ));
    }
    listOut.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    height: _width / 2.3,
                    width: _width / 2.3,
                    color: Colors.white,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white12, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 20,
                      color: Colors.brown,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: const [
                              Text(
                                'Iva',
                                style: TextStyle(color: Colors.white, fontSize: 13),
                              ),Text(
                                'Fatture Acquisti',
                                style: TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('€ ' + totalIvaAcquisti.toStringAsFixed(2),
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 25)),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: _width / 2.3,
                  width: _width / 2.3,
                  color: Colors.white,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white12, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 20,
                    color: Colors.brown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: const [
                            Text(
                              'Iva',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),Text(
                              'Fatture Vendite',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('€ ' + totalIvaFatture.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: _width / 2.3,
                  width: _width / 2.3,
                  color: Colors.white,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white12, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 20,
                    color: Colors.brown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: const [
                            Text(
                              'Iva',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                            Text(
                              'NDC (Emesse)',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('€ ' + totalIvaNdcSent.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22)),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: _width / 2.3,
                  width: _width / 2.3,
                  color: Colors.white,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white12, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 20,
                    color: Colors.brown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Iva',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                            const Text(
                              'NDC (Ricevute)',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('€ ' + totalIvaNdcReceived.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: _width / 2.3,
                  width: _width / 2.3,
                  color: const Color(0xFFF5F6F9),
                  child: const Card(
                    elevation: 0,
                    color: Color(0xFFF5F6F9),
                  ),
                ),
                Container(
                  height: _width / 2.3,
                  width: _width / 2.3,
                  color: const Color(0xFFF5F6F9),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white12, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 20,
                    color: Colors.brown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: const [
                            Text(
                              'Iva',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                            Text(
                              'Incassi',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(calculateVatFromListRecessed(
                            dataBundleNotifier.getRecessedListByRangeDate(_currentDateTimeRange.start, _currentDateTimeRange.end)).toStringAsFixed(2), style: const TextStyle(color: Colors.white, fontSize: 22)),

                        //
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return listOut;
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange dateTimeRange = await showDateRangePicker(
      context: context,
      initialDateRange: _currentDateTimeRange,
      firstDate: DateTime(2018),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: kPrimaryColor,
            ),
          ),
          child: child,
        );
      },
    );

    if (dateTimeRange != null && dateTimeRange != _currentDateTimeRange) {
      setState(() {
        _currentDateTimeRange = dateTimeRange;
      });
    }
  }

  String getNameProvider(String providerFatture) {
    if(providerFatture == 'fatture_in_cloud'){
      return 'Fatture In Cloud';
    }
    if(providerFatture == 'aruba'){
      return 'Aruba';
    }
    return 'Errore ';
  }

  double calculateVatFromListRecessed(List<RecessedModel> recessedListByRangeDate) {
    double totalIva = 0;
    try{
      if(recessedListByRangeDate == null || recessedListByRangeDate.isEmpty){
        return totalIva;
      }else{
        recessedListByRangeDate.forEach((element) {
          print(element.toMap().toString());
          totalIva = totalIva + (element.amount * (element.vat/100));
        });
        return totalIva;
      }
    }catch(e){
      print(e);
      return 0;
    }

  }

}
