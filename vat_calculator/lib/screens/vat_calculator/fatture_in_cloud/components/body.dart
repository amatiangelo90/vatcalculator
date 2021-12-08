import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/components/chart_widget.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/form_error.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/details_screen/details_fatture_acquisti.dart';
import 'package:vat_calculator/screens/orders/components/edit_order_underworking_screen.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/order_create_screen.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import 'package:vat_calculator/screens/registration_provider/fatture_provider_registration.dart';
import 'package:vat_calculator/screens/vat_calculator/aruba/aruba_home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/fatture_in_cloud_home_screen.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';


class VatFattureInCloudCalculatorBody extends StatefulWidget {
  const VatFattureInCloudCalculatorBody({Key key}) : super(key: key);

  static String routeName = 'vat_fattureincloud_screen';
  @override
  _VatFattureInCloudCalculatorBodyState createState() => _VatFattureInCloudCalculatorBodyState();
}

class _VatFattureInCloudCalculatorBodyState extends State<VatFattureInCloudCalculatorBody> with RestorationMixin {

  Map<int, List<ProductOrderAmountModel>> orderIdProductListMap = {};

  final List<String> errors = [];
  String importExpences;
  TextEditingController recessedController = TextEditingController();
  TextEditingController casualeRecessedController = TextEditingController();
  RestorableInt currentSegmentIva;
  RestorableInt currentSegmentCalculationIvaPeriodChoiceMonthTrim;
  RestorableInt currentSegmentCalculationIvaTrim;


  @override
  void initState() {
    super.initState();
    currentSegmentIva = RestorableInt(0);
    currentSegmentCalculationIvaPeriodChoiceMonthTrim = RestorableInt(0);
    DateTime currentDate = DateTime.now();

    switch(currentDate.month){
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



    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
      });
    });

  }

  @override
  String get restorationId => 'cupertino_segmented_control';


  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(currentSegmentIva, 'current_segment');
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
              dataBundleNotifier.setCurrentBranch(
                  dataBundleNotifier.currentBranch);
              setState(() {});
              return Future.delayed(Duration(milliseconds: 500));
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
                            children: dataBundleNotifier
                                .ivaListTrimMonthChoiceCupertino,
                            onValueChanged: (index) {
                              setState(() {
                                currentSegmentCalculationIvaPeriodChoiceMonthTrim
                                    .value = index;
                              });
                              dataBundleNotifier
                                  .setIvaListTrimMonthChoiceCupertinoIndex(
                                  index);
                            },
                            groupValue: currentSegmentCalculationIvaPeriodChoiceMonthTrim
                                .value,
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
                                    currentSegmentCalculationIvaTrim.value =
                                        index;
                                  });
                                  dataBundleNotifier
                                      .switchTrimAndCalculateIvaGraph(index);
                                },
                                groupValue: currentSegmentCalculationIvaTrim
                                    .value,
                              ),
                            ),
                          ),
                          Text(dataBundleNotifier.currentYear.toString()),
                        ],
                      ),
                      LineChartWidget(currentDateTimeRange: dataBundleNotifier
                          .currentDateTimeRange),
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
                    ],
                  ),
                  buildDetailsIvaWidget(dataBundleNotifier, MediaQuery.of(context).size.width),
                  buildDateRecessedRegistrationWidget(dataBundleNotifier),

                ],
              ),
            ),
          );
        }
      },
    );
  }

  buildDateList(DataBundleNotifier dataBundleNotifier, BuildContext context) {
    List<Widget> branchWidgetList = [];
    List<DateTime> dateTimeList = [
      DateTime.now().subtract(const Duration(days: 9)),
      DateTime.now().subtract(const Duration(days: 8)),
      DateTime.now().subtract(const Duration(days: 7)),
      DateTime.now().subtract(const Duration(days: 6)),
      DateTime.now().subtract(const Duration(days: 5)),
      DateTime.now().subtract(const Duration(days: 4)),
      DateTime.now().subtract(const Duration(days: 3)),
      DateTime.now().subtract(const Duration(days: 2)),
      DateTime.now().subtract(const Duration(days: 1)),
      DateTime.now(),
      DateTime.now().add(const Duration(days: 1)),
      DateTime.now().add(const Duration(days: 2)),
      DateTime.now().add(const Duration(days: 3)),
      DateTime.now().add(const Duration(days: 4)),
      DateTime.now().add(const Duration(days: 5)),
      DateTime.now().add(const Duration(days: 6)),
      DateTime.now().add(const Duration(days: 7)),
      DateTime.now().add(const Duration(days: 8)),
      DateTime.now().add(const Duration(days: 9)),
      DateTime.now().add(const Duration(days: 10)),
      DateTime.now().add(const Duration(days: 11)),
    ];

    dateTimeList.forEach((currentDate) {
      branchWidgetList.add(
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: (dataBundleNotifier.currentDateTime.day == currentDate.day
                  &&
                  dataBundleNotifier.currentDateTime.month == currentDate.month)
                  ? Colors.grey
                  : kCustomWhite,
              border: const Border(
                bottom: BorderSide(width: 1.0, color: Colors.blueGrey),

              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  currentDate.day == DateTime
                      .now()
                      .day ?
                  Text('  OGGI',
                    style: TextStyle(
                      fontSize: (dataBundleNotifier.currentDateTime.day ==
                          currentDate.day
                          && dataBundleNotifier.currentDateTime.month ==
                              currentDate.month) ? getProportionateScreenWidth(
                          16) : getProportionateScreenWidth(13),
                      color: (dataBundleNotifier.currentDateTime.day ==
                          currentDate.day
                          && dataBundleNotifier.currentDateTime.month ==
                              currentDate.month) ? Colors.white : Colors.black,
                    ),) :
                  Text('  ' + currentDate.day.toString() + '.' +
                      currentDate.month.toString() + ' ' +
                      getNameDayFromWeekDay(currentDate.weekday),
                    style: TextStyle(
                      fontSize: (dataBundleNotifier.currentDateTime.day ==
                          currentDate.day
                          && dataBundleNotifier.currentDateTime.month ==
                              currentDate.month) ? getProportionateScreenWidth(
                          16) : getProportionateScreenWidth(13),
                      color: (dataBundleNotifier.currentDateTime.day ==
                          currentDate.day
                          && dataBundleNotifier.currentDateTime.month ==
                              currentDate.month) ? Colors.white : Colors.black,
                    ),),
                ],
              ),
            ),
          ),
          onTap: () {
            dataBundleNotifier.setCurrentDateTime(currentDate);
            Navigator.pop(context);
          },
        ),
      );
    });
    return branchWidgetList;
  }

  buildDateRecessedRegistrationWidget(DataBundleNotifier dataBundleNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 2,
            child: Column(
              children: [
                Text('Registra Incasso'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: IconButton(icon: Icon(
                        Icons.arrow_back_ios,
                        size: getProportionateScreenWidth(15),
                        color: kPrimaryColor,
                      ), onPressed: () { dataBundleNotifier.removeOneDayToDate(); },),
                    ),
                    GestureDetector(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog (
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
                                      height: height - 250,
                                      width: width - 90,
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
                                                      Text('  Calendario',style: TextStyle(
                                                        fontSize: getProportionateScreenWidth(20),
                                                        fontWeight: FontWeight.bold,
                                                        color: kCustomWhite,
                                                      ),),
                                                      IconButton(icon: const Icon(
                                                        Icons.clear,
                                                        color: kCustomWhite,
                                                      ), onPressed: () { Navigator.pop(context); },),

                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Column(
                                                        children: buildDateList(dataBundleNotifier, context),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // buildDateList(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                          );
                        },
                        child: Text(dataBundleNotifier.getCurrentDate(), style: TextStyle(fontSize: 15),)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: IconButton(icon: Icon(
                        Icons.arrow_forward_ios,
                        size: getProportionateScreenWidth(15),
                        color: kPrimaryColor,
                      ), onPressed: () { dataBundleNotifier.addOneDayToDate(); },),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 30,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: CupertinoSlidingSegmentedControl<int>(
                          children: dataBundleNotifier.ivaListCupertino,
                          onValueChanged: (index){
                            setState(() {
                              currentSegmentIva.value = index;
                            });
                            dataBundleNotifier.setIndexIvaListValue(index);
                          },
                          groupValue: currentSegmentIva.value,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(width: 28,),
                        Text('Importo'),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 75,
                      child: CupertinoTextField(
                        controller: recessedController,
                        onChanged: (text) {

                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        clearButtonMode: OverlayVisibilityMode.never,
                        textAlign: TextAlign.center,
                        autocorrect: false,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(width: 28,),
                        Text('Casuale'),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 75,
                      child: CupertinoTextField(
                        controller: casualeRecessedController,
                        onChanged: (text) {

                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        clearButtonMode: OverlayVisibilityMode.never,
                        textAlign: TextAlign.center,
                        autocorrect: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: FormError(errors: errors),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: DefaultButton(
                        text: "Salva Incasso",
                        press: () async {
                          KeyboardUtil.hideKeyboard(context);
                          try{
                            if(recessedController.text == ''){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  duration: const Duration(milliseconds: 2000),
                                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                                  content: const Text('Inserire importo', style: TextStyle(color: Colors.white),)));
                            }else if(double.tryParse(recessedController.text) == null){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  duration: const Duration(milliseconds: 2000),
                                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                                  content: const Text('Inserire un importo corretto', style: TextStyle(color: Colors.white),)));
                            }else if(casualeRecessedController.text == ''){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  duration: const Duration(milliseconds: 2000),
                                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                                  content: const Text('Inserire casuale', style: TextStyle(color: Colors.white),)));
                            }else{
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
                              dataBundleNotifier.recalculateGraph();
                              recessedController.clear();
                              casualeRecessedController.clear();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  duration: Duration(milliseconds: 2000),
                                  backgroundColor: Colors.green.shade700.withOpacity(0.8),
                                  content: Text('Importo registrato', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                            }
                          }catch(e){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                duration: const Duration(milliseconds: 6000),
                                backgroundColor: Colors.red,
                                content: Text('Abbiamo riscontrato un errore durante l\'operzione. Riprova più tardi. Errore: $e', style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                          }
                        },
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),

        buildLas5RecessedRegisteredWidget(dataBundleNotifier),
      ],
    );
  }

  buildLas5RecessedRegisteredWidget(DataBundleNotifier dataBundleNotifier) {

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Container(
                  height: getProportionateScreenWidth(40),
                  decoration: BoxDecoration(
                      color: Colors.green.shade700.withOpacity(0.5),
                      shape: BoxShape.circle
                  ),
                  width: getProportionateScreenWidth(50),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset('assets/icons/euro.svg', color: Colors.green.shade900,),
                  ),
                ),
              ],
            ),
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
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Ultimi 5 incassi registrati'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: rowChildrenWidget.reversed.toList(),),
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

  buildDetailsIvaWidget(DataBundleNotifier dataBundleNotifier, double width) {
    List<Widget> listOut = <Widget>[];

    if ((dataBundleNotifier.totalIvaAcquisti + dataBundleNotifier.totalIvaNdcReceived) >=
        (dataBundleNotifier.totalIvaFatture +
            dataBundleNotifier.totalIvaNdcSent +
            calculateVatFromListRecessed(
                dataBundleNotifier.getRecessedListByRangeDate(
                    dataBundleNotifier.currentDateTimeRange.start, dataBundleNotifier.currentDateTimeRange.end)))) {
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
                      ((dataBundleNotifier.totalIvaNdcReceived + dataBundleNotifier.totalIvaAcquisti) -
                          (dataBundleNotifier.totalIvaFatture +
                              dataBundleNotifier.totalIvaNdcSent +
                              calculateVatFromListRecessed(
                                  dataBundleNotifier
                                      .getRecessedListByRangeDate(
                                      dataBundleNotifier.currentDateTimeRange.start,
                                      dataBundleNotifier.currentDateTimeRange.end))))
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
                      ((dataBundleNotifier.totalIvaFatture +
                          dataBundleNotifier.totalIvaNdcReceived +
                          calculateVatFromListRecessed(
                              dataBundleNotifier
                                  .getRecessedListByRangeDate(
                                  dataBundleNotifier.currentDateTimeRange.start,
                                  dataBundleNotifier.currentDateTimeRange.end))) -
                          (dataBundleNotifier.totalIvaAcquisti + dataBundleNotifier.totalIvaNdcSent))
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
                          listResponseAcquisti: dataBundleNotifier.extractedAcquistiFatture,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: width / 2.3,
                    width: width / 2.3,
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
                          Text('€ ' + dataBundleNotifier.totalIvaAcquisti.toStringAsFixed(2),
                              style: const TextStyle(
                                  color: kCustomBlue, fontSize: 25)),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: width / 2.3,
                  width: width / 2.3,
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
                        Text('€ ' + dataBundleNotifier.totalIvaFatture.toStringAsFixed(2),
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
                  height: width / 2.3,
                  width: width / 2.3,
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
                        Text('€ ' + dataBundleNotifier.totalIvaNdcSent.toStringAsFixed(2),
                            style: const TextStyle(
                                color: kCustomBlue, fontSize: 22)),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: width / 2.3,
                  width: width / 2.3,
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
                        Text('€ ' + dataBundleNotifier.totalIvaNdcReceived.toStringAsFixed(2),
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
                  height: width / 2.3,
                  width: width / 2.3,
                  color: kCustomWhite,
                  child: const Card(
                    elevation: 0,
                    color: kCustomWhite,
                  ),
                ),
                Container(
                  height: width / 2.3,
                  width: width / 2.3,
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
                                dataBundleNotifier.currentDateTimeRange.start,
                                dataBundleNotifier.currentDateTimeRange.end))
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

    return Column(
      children: listOut,
    );
  }
}

