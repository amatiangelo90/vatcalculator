import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/client_icloud.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_acquisti_api.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fatture_api.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_ndc_api.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/components/custom_surfix_icon.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/form_error.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/details_screen/details_fatture_acquisti.dart';
import 'package:vat_calculator/components/item_menu.dart';
import 'package:vat_calculator/screens/details_screen/details_recessed.dart';
import 'package:vat_calculator/screens/branch_registration/branch_choice_registration.dart';
import 'package:vat_calculator/screens/registration_provider/fatture_provider_registration.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';

class VatFattureInCloudCalculatorBody extends StatefulWidget {
  const VatFattureInCloudCalculatorBody({Key key}) : super(key: key);

  @override
  _VatFattureInCloudCalculatorBodyState createState() =>
      _VatFattureInCloudCalculatorBodyState();
}

class _VatFattureInCloudCalculatorBodyState
    extends State<VatFattureInCloudCalculatorBody> {

  final List<String> errors = [];
  String importExpences;
  final _formExpenceKey = GlobalKey<FormState>();

  TextEditingController recessedController = TextEditingController();
  TextEditingController casualeRecessedController = TextEditingController();


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
      if (dataBundleNotifier.currentBranch == null) {
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
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                child: DefaultButton(
                  text: "Crea Attività",
                  press: () async {
                    Navigator.pushNamed(context, BranchChoiceCreationEnjoy.routeName);
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Card(
                    child: Column(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: kPrimaryColor,
                            padding: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: kCustomWhite,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                            dataBundleNotifier.currentBranch.companyName,
                                            style: const TextStyle(
                                                color: kPrimaryColor, fontSize: 27),
                                          ))),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        content: Builder(
                                          builder: (context) {
                                            var width = MediaQuery.of(context)
                                                .size
                                                .width;
                                            return SizedBox(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                Axis.vertical,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration:
                                                      const BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                            topRight: Radius
                                                                .circular(
                                                                10.0),
                                                            topLeft: Radius
                                                                .circular(
                                                                10.0)),
                                                        color: kPrimaryColor,
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                '  Dettagli Provider',
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  getProportionateScreenWidth(
                                                                      17),
                                                                  color:
                                                                  kCustomWhite,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                icon:
                                                                const Icon(
                                                                  Icons.clear,
                                                                  color:
                                                                  kCustomWhite,
                                                                ),
                                                                onPressed:
                                                                    () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
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
                                                            color:
                                                            Colors.blue,
                                                            semanticContainer:
                                                            true,
                                                            clipBehavior: Clip
                                                                .antiAliasWithSaveLayer,
                                                            child:
                                                            Image.asset(
                                                              'assets/images/fattureincloud.png',
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10.0),
                                                            ),
                                                            elevation: 5,
                                                            margin:
                                                            const EdgeInsets
                                                                .all(10),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                                width: 22),
                                                            Text(
                                                              'ApiKey',
                                                              style:
                                                              TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontSize:
                                                                getProportionateScreenWidth(
                                                                    14),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Card(
                                                          child: Row(
                                                            children: [
                                                              SizedBox(width: getProportionateScreenHeight(20),),
                                                              Text(dataBundleNotifier
                                                                  .currentBranch
                                                                  .apiKeyOrUser, style: TextStyle(color: Colors.blue.shade500, fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                          elevation: 0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                                width: 22),
                                                            Text(
                                                              dataBundleNotifier
                                                                  .currentBranch
                                                                  .providerFatture ==
                                                                  'fatture_in_cloud'
                                                                  ? 'ApiUid'
                                                                  : 'Password',
                                                              style:
                                                              TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontSize:
                                                                getProportionateScreenWidth(
                                                                    14),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Card(
                                                          child: Row(
                                                            children: [
                                                              SizedBox(width: getProportionateScreenHeight(20),),
                                                              Text(dataBundleNotifier
                                                                  .currentBranch
                                                                  .apiUidOrPassword, style: TextStyle(color: Colors.blue.shade500, fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                          elevation: 0,
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        SizedBox(
                                                          width: getProportionateScreenWidth(300),
                                                          child: CupertinoButton(
                                                            child: Text('Elimina Provider'),
                                                            color: Colors.redAccent,
                                                            onPressed: () async {
                                                              Response response = await dataBundleNotifier.getclientServiceInstance()
                                                                  .removeProviderFromBranch(
                                                                    branchModel: dataBundleNotifier.currentBranch,
                                                                  actionModel: ActionModel(
                                                                      date: DateTime.now().millisecondsSinceEpoch,
                                                                      description: 'Ha rimosso il provider per la fatturazione elettronica ${dataBundleNotifier.currentBranch.providerFatture} dall\'attività ${dataBundleNotifier.currentBranch.companyName}',
                                                                      fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                                                      user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                                                    type: ActionType.PROVIDER_DELETE
                                                                  )
                                                              );
                                                              if(response.data > 0){
                                                                print('Provider Rimosso');
                                                                dataBundleNotifier.removeProviderFromCurrentBranch();
                                                              }else{
                                                                print('Errore rimozione provider');
                                                              }
                                                              Navigator.pushNamed(context, RegisterFattureProviderScreen.routeName);
                                                            },
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
                                      ));
                                },
                                child: SizedBox(
                                  width: 120,
                                  child: Card(
                                    color: dataBundleNotifier
                                        .currentBranch.providerFatture ==
                                        'fatture_in_cloud'
                                        ? Colors.blue
                                        : Colors.orange,
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Image.asset(
                                      dataBundleNotifier.currentBranch
                                          .providerFatture ==
                                          'fatture_in_cloud'
                                          ? 'assets/images/fattureincloud.png'
                                          : 'assets/images/aruba.png',
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
                        ItemMenu(
                          text: 'Intervallo temporale ' +
                              _currentDateTimeRange.start.day.toString() +
                              '/' +
                              _currentDateTimeRange.start.month.toString() +
                              ' - ' +
                              _currentDateTimeRange.end.day.toString() +
                              '/' +
                              _currentDateTimeRange.end.month.toString(),
                          icon: "assets/icons/calendar.svg",
                          press: () => {
                            _selectDateRange(context),
                            dataBundleNotifier.setShowIvaButtonToFalse(),
                          },
                          showArrow: false,
                          backgroundColor: kCustomWhite,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: DefaultButton(
                            text: "Calcola Iva",
                            press: () async {
                              dataBundleNotifier.setShowIvaButtonToTrue();
                            },
                            color: Colors.blue,
                          ),
                        ),
                        dataBundleNotifier.showIvaButtonPressed
                            ? buildIVAPage(dataBundleNotifier)
                            : const SizedBox(
                          width: 0,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 2,
                      child: Column(
                        children: [
                          const Text('Registra Incasso'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: IconButton(icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: kPrimaryColor,
                                ), onPressed: () { dataBundleNotifier.previousIva(); },),
                              ),
                              Text('Iva ' + dataBundleNotifier.getIvaList()[dataBundleNotifier.indexIvaList].toString() + '%', style: const TextStyle(fontSize: 20),),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: IconButton(icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: kPrimaryColor,
                                ), onPressed: () { dataBundleNotifier.nextIva(); },),
                              ),
                            ],
                          ),
                          Form(
                            key: _formExpenceKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: buildExpenceImportForField(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: buildCasualeExpenceForField(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: FormError(errors: errors),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: DefaultButton(
                                    text: "Salva Importo",
                                    press: () async {
                                      if (_formExpenceKey.currentState.validate()) {
                                        _formExpenceKey.currentState.save();
                                        KeyboardUtil.hideKeyboard(context);
                                        try{

                                          ClientVatService clientService = dataBundleNotifier.getclientServiceInstance();
                                          await clientService.performSaveRecessed(
                                              double.parse(recessedController.text),
                                              casualeRecessedController.text,
                                              dataBundleNotifier.getIvaList()[dataBundleNotifier.indexIvaList],
                                              dataBundleNotifier.currentDateTime.millisecondsSinceEpoch,
                                              dataBundleNotifier.currentBranch.pkBranchId,
                                              ActionModel(
                                                  date: DateTime.now().millisecondsSinceEpoch,
                                                  description: 'Ha registrato incasso ${recessedController.text} € con casuale [${casualeRecessedController.text}] per attività ${dataBundleNotifier.currentBranch.companyName}',
                                                  fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                                  user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                                type: ActionType.RECESSED_CREATION
                                              )
                                          );

                                          List<RecessedModel> _recessedModelList = await clientService.retrieveRecessedListByBranch(dataBundleNotifier.currentBranch);
                                          dataBundleNotifier.addCurrentRecessedList(_recessedModelList);

                                          recessedController.clear();
                                          casualeRecessedController.clear();

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                              duration: Duration(milliseconds: 2000),
                                              backgroundColor: Colors.green,
                                              content: Text('Importo registrato', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));

                                        }catch(e){
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              duration: const Duration(milliseconds: 6000),
                                              backgroundColor: Colors.red,
                                              content: Text('Abbiamo riscontrato un errore durante l\'operzione. Riprova più tardi. Errore: $e', style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 2,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Ultimi 10 incassi registrati'),
                          ),
                          const SizedBox(height: 15,),
                          Column(
                            children: buildRecessedLastTenDays(dataBundleNotifier),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: DefaultButton(
                              text: "Dettaglio Incassi",
                              press: () async {

                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 2,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Dettaglio settimanale'),
                          ),
                          const SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: IconButton(icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: kPrimaryColor,
                                ), onPressed: () { dataBundleNotifier.subtractWeekToDateTimeRange(); },),
                              ),
                              Text(dataBundleNotifier.currentDateTimeRange.start.day.toString()
                                  + '/' + dataBundleNotifier.currentDateTimeRange.start.month.toString() + ' - ' +
                                  dataBundleNotifier.currentDateTimeRange.end.day.toString()
                                  + '/' + dataBundleNotifier.currentDateTimeRange.end.month.toString(), style: const TextStyle(fontSize: 20),),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: IconButton(icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: kPrimaryColor,
                                ), onPressed: () { dataBundleNotifier.addWeekToDateTimeRange(); },),
                              ),
                            ],
                          ),
                          Column(
                              children: [buildWeekDetailReceed(dataBundleNotifier),]
                          ),

                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: DefaultButton(
                              text: "Dettaglio Incassi",
                              press: () async {
                                Navigator.pushNamed(context, DetailsRecessed.routeName);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),

            ],
          ),
        );
      }
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
                    color: kPinaColor,
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
              ),
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
        (totalIvaFatture +
            totalIvaNdcSent +
            calculateVatFromListRecessed(
                dataBundleNotifier.getRecessedListByRangeDate(
                    _currentDateTimeRange.start, _currentDateTimeRange.end)))) {
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
                                  calculateVatFromListRecessed(
                                      dataBundleNotifier
                                          .getRecessedListByRangeDate(
                                              _currentDateTimeRange.start,
                                              _currentDateTimeRange.end))))
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
                      ((totalIvaFatture +
                                  totalIvaNdcReceived +
                                  calculateVatFromListRecessed(
                                      dataBundleNotifier
                                          .getRecessedListByRangeDate(
                                              _currentDateTimeRange.start,
                                              _currentDateTimeRange.end))) -
                              (totalIvaAcquisti + totalIvaNdcSent))
                          .toStringAsFixed(2),
                  style: const TextStyle(color: Colors.white, fontSize: 40),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          color: kPinaColor,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FattureAcquistiDetailsPage(
                          listResponseAcquisti: extractedAcquistiFatture,
                        ),
                      ),
                    );
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
                      color: kBeigeColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: const [
                              Text(
                                'Iva',
                                style: TextStyle(
                                    color: kCustomBlue, fontSize: 13),
                              ),
                              Text(
                                'Fatture Acquisti',
                                style: TextStyle(
                                    color: kCustomBlue, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('€ ' + totalIvaAcquisti.toStringAsFixed(2),
                              style: const TextStyle(
                                  color: kCustomBlue, fontSize: 25)),
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
                    color: kBeigeColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: const [
                            Text(
                              'Iva',
                              style:
                                  TextStyle(color: kCustomBlue, fontSize: 13),
                            ),
                            Text(
                              'Fatture Vendite',
                              style:
                                  TextStyle(color: kCustomBlue, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('€ ' + totalIvaFatture.toStringAsFixed(2),
                            style: const TextStyle(
                                color: kCustomBlue, fontSize: 22)),
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
                    color: kBeigeColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: const [
                            Text(
                              'Iva',
                              style:
                                  TextStyle(color: kCustomBlue, fontSize: 13),
                            ),
                            Text(
                              'NDC (Emesse)',
                              style:
                                  TextStyle(color: kCustomBlue, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('€ ' + totalIvaNdcSent.toStringAsFixed(2),
                            style: const TextStyle(
                                color: kCustomBlue, fontSize: 22)),
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
                    color: kBeigeColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: const [
                            Text(
                              'Iva',
                              style:
                                  TextStyle(color: kCustomBlue, fontSize: 13),
                            ),
                            Text(
                              'NDC (Ricevute)',
                              style:
                                  TextStyle(color: kCustomBlue, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('€ ' + totalIvaNdcReceived.toStringAsFixed(2),
                            style: const TextStyle(
                                color: kCustomBlue, fontSize: 22)),
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
                  color: kCustomWhite,
                  child: const Card(
                    elevation: 0,
                    color: kCustomWhite,
                  ),
                ),
                Container(
                  height: _width / 2.3,
                  width: _width / 2.3,
                  color: kCustomWhite,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white12, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 20,
                    color: kBeigeColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: const [
                            Text(
                              'Iva',
                              style:
                                  TextStyle(color: kCustomBlue, fontSize: 13),
                            ),
                            Text(
                              'Incassi',
                              style:
                                  TextStyle(color: kCustomBlue, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            calculateVatFromListRecessed(dataBundleNotifier
                                    .getRecessedListByRangeDate(
                                        _currentDateTimeRange.start,
                                        _currentDateTimeRange.end))
                                .toStringAsFixed(2),
                            style: const TextStyle(
                                color: kCustomBlue, fontSize: 22)),

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
        useRootNavigator: false,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: kPinaColor,
              secondary: Colors.white,
              onPrimary: Colors.white,
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
    if (providerFatture == 'fatture_in_cloud') {
      return 'Fatture In Cloud';
    }
    if (providerFatture == 'aruba') {
      return 'Aruba';
    }
    return 'Errore ';
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
          totalIva = totalIva + (element.amount * (element.vat / 100));
        });
        return totalIva;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  void addError({String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  TextFormField buildExpenceImportForField() {

    return TextFormField(
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
      onSaved: (newValue) => importExpences = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kImportNullError);
        }else if (value.isNotEmpty) {
          removeError(error: kInvalidImportNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kImportNullError);
          return "";
        }else if(double.tryParse(value) == null){
          addError(error: kInvalidImportNullError);
          return "";
        }
        return null;
      },
      controller: recessedController,
      decoration: const InputDecoration(
        labelText: "Incasso",
        hintText: "Inserisci importo",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/euro.svg"),
      ),
    );
  }

  TextFormField buildCasualeExpenceForField() {

    return TextFormField(
      textAlign: TextAlign.center,
      onSaved: (newValue) => importExpences = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCasualeExpenceNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kCasualeExpenceNullError);
          return "";
        }
        return null;
      },
      controller: casualeRecessedController,
      decoration: const InputDecoration(

        labelText: "Casuale",
        hintText: "Inserisci casuale",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/receipt.svg"),
      ),
    );
  }

  buildRecessedLastTenDays(DataBundleNotifier dataBundleNotifier) {
    List<Widget> recessedList = [];

    if (dataBundleNotifier
        .getCurrentListRecessed()
        .isEmpty) {
      return recessedList;
    }

    Table table = Table(
      border: TableBorder.symmetric(inside: BorderSide(width: 1, color: kCustomWhite)),
      children: [
        TableRow(children: [
          Column(children: const [
            Text('Importo(€)')
          ]),
          Column(children: const [
            Text('Casuale')
          ]),
          Column(children: const [
            Text('Data')
          ]),
        ]),
      ],
    );

    if (dataBundleNotifier
        .getCurrentListRecessed()
        .length > 9) {
      dataBundleNotifier.getCurrentListRecessed().sublist(0, 10).forEach((
          recessedModel) {
        buildTableRowFromRecessData(table, recessedModel);
      });
    }else {
      dataBundleNotifier.getCurrentListRecessed().sublist(0, dataBundleNotifier
          .getCurrentListRecessed()
          .length).forEach((recessedModel) {
        buildTableRowFromRecessData(table, recessedModel);
      });
    }
    recessedList.add(
        table
    );
    return recessedList;
  }

  void buildTableRowFromRecessData(Table table, RecessedModel recessedModel) {
    table.children.add(
        TableRow(
            children: [
              Column(children: [
                Text(recessedModel.amount.toString())
              ]),
              Column(children: [
                Text(recessedModel.description)
              ]),
              Column(children: [
                Text(DateTime.fromMillisecondsSinceEpoch(recessedModel.dateTimeRecessed).day.toString() + '/' + DateTime.fromMillisecondsSinceEpoch(recessedModel.dateTimeRecessed).month.toString())
              ]),
            ])
    );
  }

  buildWeekDetailReceed(DataBundleNotifier dataBundleNotifier) {
    double total = 0.0;

    dataBundleNotifier.getRecessedListByRangeDate(
        dataBundleNotifier.currentDateTimeRange.start,
        dataBundleNotifier.currentDateTimeRange.end).forEach((recessedItem) {
      total = total + recessedItem.amount;
    });

    return Text(total.toString());

  }
}
