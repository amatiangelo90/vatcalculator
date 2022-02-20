import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/components/chart_widget.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/details_screen/details_fatture_acquisti.dart';
import 'package:vat_calculator/screens/vat_calculator/recessed_manager/recessed_card.dart';
import 'package:vat_calculator/screens/vat_calculator/recessed_manager/recessed_screen.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';

class VatFattureInCloudCalculatorBody extends StatefulWidget {
  const VatFattureInCloudCalculatorBody({Key key}) : super(key: key);

  static String routeName = 'fattureincloud_screen';
  @override
  _VatFattureInCloudCalculatorBodyState createState() => _VatFattureInCloudCalculatorBodyState();
}

class _VatFattureInCloudCalculatorBodyState extends State<VatFattureInCloudCalculatorBody> with RestorationMixin {

  Map<int, List<ProductOrderAmountModel>> orderIdProductListMap = {};
  String importExpences;

  RestorableInt currentSegmentCalculationIvaPeriodChoiceMonthTrim;
  RestorableInt currentSegmentCalculationIvaTrim;


  @override
  void initState() {

    currentSegmentCalculationIvaPeriodChoiceMonthTrim = RestorableInt(0);
    DateTime currentDate = DateTime.now();
    setcurrentSegmentCalculationIvaTrim(currentDate.month);
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
      });
    });
  }

  setcurrentSegmentCalculationIvaTrim(int month){
    print('Current Month ' + month.toString());
    setState((){
      switch(month){
        case 1:
          currentSegmentCalculationIvaTrim = RestorableInt(0);
          break;
        case 2:
          currentSegmentCalculationIvaTrim = RestorableInt(0);
          break;
        case 3:
          currentSegmentCalculationIvaTrim = RestorableInt(0);
          break;
        case 4:
          currentSegmentCalculationIvaTrim = RestorableInt(1);
          break;
        case 5:
          currentSegmentCalculationIvaTrim = RestorableInt(1);
          break;
        case 6:
          currentSegmentCalculationIvaTrim = RestorableInt(1);
          break;
        case 7:
          currentSegmentCalculationIvaTrim = RestorableInt(2);
          break;
        case 8:
          currentSegmentCalculationIvaTrim = RestorableInt(2);
          break;
        case 9:
          currentSegmentCalculationIvaTrim = RestorableInt(2);
          break;
        case 10:
          currentSegmentCalculationIvaTrim = RestorableInt(3);
          break;
        case 11:
          currentSegmentCalculationIvaTrim = RestorableInt(3);
          break;
        case 12:
          currentSegmentCalculationIvaTrim = RestorableInt(3);
          break;
      }
    });
  }

  @override
  String get restorationId => 'cupertino_segmented_control';


  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(currentSegmentCalculationIvaPeriodChoiceMonthTrim, 'current_segment_iva');
    registerForRestoration(currentSegmentCalculationIvaTrim, 'current_segment_iva_trim');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        if (dataBundleNotifier.dataBundleList.isEmpty ||
            dataBundleNotifier.dataBundleList[0].companyList.isEmpty) {
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
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  dataBundleNotifier.currentBranch.providerFatture == ''
                      ? Column(
                    children: [
                      Text(''),
                    ],
                  )
                      : Column(
                    children: [

                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: CupertinoSlidingSegmentedControl<int>(
                            children: dataBundleNotifier.ivaListTrimMonthChoiceCupertino,
                            onValueChanged: (index) {
                              setState(() {
                                currentSegmentCalculationIvaPeriodChoiceMonthTrim.value = index;
                              });
                              dataBundleNotifier.setIvaListTrimMonthChoiceCupertinoIndex(index);
                            },
                            groupValue: currentSegmentCalculationIvaPeriodChoiceMonthTrim.value,
                          ),
                        ),
                      ),
                      dataBundleNotifier.ivaListTrimMonthChoiceCupertinoIndex ==
                          0 ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: IconButton(icon: Icon(
                              Icons.arrow_back_ios,
                              size: getProportionateScreenWidth(15),
                              color: kPrimaryColor,
                            ), onPressed: () {
                              dataBundleNotifier.subtractMonth();
                            },),
                          ),
                          Text(getMonthFromMonthNumber(
                              dataBundleNotifier.currentDate.month)
                              .toUpperCase() + ' - ' +
                              dataBundleNotifier.currentDate.year.toString()),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: IconButton(icon: Icon(
                              Icons.arrow_forward_ios,
                              size: getProportionateScreenWidth(15),
                              color: kPrimaryColor,
                            ), onPressed: () {
                              dataBundleNotifier.addMonth();
                            },),
                          ),
                        ],
                      ) :
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: CupertinoSlidingSegmentedControl<int>(
                                children: dataBundleNotifier
                                    .ivaListPeriodCupertino,
                                onValueChanged: (index) {
                                  setState(() {
                                    currentSegmentCalculationIvaTrim.value = index;
                                  });
                                  dataBundleNotifier.switchTrimAndCalculateIvaGraph(index);
                                },
                                groupValue: currentSegmentCalculationIvaTrim.value,
                              ),
                            ),
                          ),
                          Text(dataBundleNotifier.currentYear.toString()),
                        ],
                      ),
                      buildHeaderDetailsIvaWidget(dataBundleNotifier, MediaQuery.of(context).size.width),
                      buildDetailsIvaWidget(dataBundleNotifier, MediaQuery.of(context).size.width),
                      LineChartWidget(currentDateTimeRange: dataBundleNotifier
                          .currentDateTimeRange),

                    ],
                  ),
                  buildDateRecessedRegistrationWidget(dataBundleNotifier),

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
        RecessedCard(),
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
                  child: SvgPicture.asset('assets/icons/euro.svg', color: kCustomYellow800,),
                ),
              ),
            ],
          ),
          Text(recessedModel.amount.toStringAsFixed(2), style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
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
              CupertinoButton(
                onPressed: (){
                  Navigator.pushNamed(context, RecessedManagerScreen.routeName);
                },
                child: Row(
                  children: [
                    Text('Dettaglio Incassi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12), color: Colors.grey),),
                    Icon(Icons.arrow_forward_ios, size: getProportionateScreenWidth(15), color: Colors.grey),
                  ],
                ),
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
          totalIva = totalIva + (element.amount * (element.vat / 100));
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
      if(DateTime.fromMillisecondsSinceEpoch(recessedElement.dateTimeRecessed).isBefore(dataBundleNotifier.currentDateTimeRange.end)
          && DateTime.fromMillisecondsSinceEpoch(recessedElement.dateTimeRecessed).isAfter(dataBundleNotifier.currentDateTimeRange.start)){
        currentRecessedVat = currentRecessedVat + ((recessedElement.amount / 100) * recessedElement.vat);
      }
    });

    if (vatCredit >= (vatDebit + currentRecessedVat)) {
      // iva a credito
      listOut.add(Padding(
        padding: const EdgeInsets.all(10.0),
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
                Text(
                  '€ ' +
                      (vatCredit - (vatDebit + currentRecessedVat))
                          .toStringAsFixed(2),
                  style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(25)),
                ),
              ],
            ),
          ),
          color: Colors.green.withOpacity(0.7),
        ),
      ));
    } else {
      listOut.add(Padding(
        padding: const EdgeInsets.all(10.0),
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
                Text(
                  '€ ' +
                      ((vatDebit + currentRecessedVat) - vatCredit)
                          .toStringAsFixed(2),
                  style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(25)),
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
  buildDetailsIvaWidget(DataBundleNotifier dataBundleNotifier, double width) {
    List<Widget> listOut = <Widget>[];
    listOut.add(
      Divider(),
    );
    listOut.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FattureAcquistiDetailsPage(
                    listResponseAcquisti: dataBundleNotifier.extractedAcquistiFatture,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'Iva',
                      style: TextStyle(
                          color: kCustomBlue, fontSize: getProportionateScreenWidth(8)),
                    ),
                    Text(
                      'Fatture Acquisti',
                      style: TextStyle(
                          color: kCustomBlue, fontSize: getProportionateScreenWidth(8)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('€ ' + dataBundleNotifier.totalIvaAcquisti.toStringAsFixed(2),
                    style: TextStyle(
                        color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(11)),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Iva',
                    style:
                    TextStyle(color: kCustomBlue, fontSize: getProportionateScreenWidth(8)),
                  ),
                  Text(
                    'NDC (Emesse)',
                    style:
                    TextStyle(color: kCustomBlue, fontSize: getProportionateScreenWidth(8)),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text('€ ' + dataBundleNotifier.totalIvaNdcSent.toStringAsFixed(2),
                  style: TextStyle(
                      color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(11))),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Iva',
                    style:
                    TextStyle(color: kCustomBlue, fontSize: getProportionateScreenWidth(8)),
                  ),
                  Text(
                    'Fatture Vendite',
                    style:
                    TextStyle(color: kCustomBlue, fontSize: getProportionateScreenWidth(8)),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text('€ ' + dataBundleNotifier.totalIvaFatture.toStringAsFixed(2),
                style: TextStyle(
                    color: kPinaColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(11)),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Iva',
                    style:
                    TextStyle(color: kCustomBlue, fontSize: getProportionateScreenWidth(8)),
                  ),
                  Text(
                    'NDC (Ricevute)',
                    style:
                    TextStyle(color: kCustomBlue, fontSize: getProportionateScreenWidth(8)),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text('€ ' + dataBundleNotifier.totalIvaNdcReceived.toStringAsFixed(2),
                  style: TextStyle(
                      color: kPinaColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(11))),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Iva',
                    style:
                    TextStyle(color: kCustomBlue, fontSize: getProportionateScreenWidth(8)),
                  ),
                  Text(
                    'Incassi',
                    style:
                    TextStyle(color: kCustomBlue, fontSize: getProportionateScreenWidth(8)),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  calculateVatFromListRecessed(dataBundleNotifier
                      .getRecessedListByRangeDate(
                      dataBundleNotifier.currentDateTimeRange.start,
                      dataBundleNotifier.currentDateTimeRange.end))
                      .toStringAsFixed(2),
                  style: TextStyle(
                      color: kPinaColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(11))),

              //
            ],
          ),
        ],
      ),
    );
    listOut.add(
      Divider(),
    );
    return Column(
      children: listOut,
    );
  }
}
