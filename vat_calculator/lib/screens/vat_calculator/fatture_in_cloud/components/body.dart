import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/details_screen/details_fatture_acquisti.dart';
import 'package:vat_calculator/screens/recessed_manager/components/recessed_reg_card.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';

class VatFattureInCloudCalculatorBody extends StatefulWidget {
  const VatFattureInCloudCalculatorBody({Key key}) : super(key: key);

  static String routeName = 'fattureincloud_screen';
  @override
  _VatFattureInCloudCalculatorBodyState createState() => _VatFattureInCloudCalculatorBodyState();
}

class _VatFattureInCloudCalculatorBodyState extends State<VatFattureInCloudCalculatorBody> {

  Map<int, List<ProductOrderAmountModel>> orderIdProductListMap = {};
  String importExpences;

  @override
  void initState() {

    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        if (dataBundleNotifier.userDetailsList.isEmpty ||
            dataBundleNotifier.userDetailsList[0].companyList.isEmpty) {
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
                    children: const [
                      Text(''),
                    ],
                  )
                      : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          dataBundleNotifier.currentDateTimeRangeVatService.start.day.toString() + ' ' +
                              getMonthFromMonthNumber(dataBundleNotifier.currentDateTimeRangeVatService.start.month) +' ' +
                              dataBundleNotifier.currentDateTimeRangeVatService.start.year.toString() + ' - ' +
                              dataBundleNotifier.currentDateTimeRangeVatService.end.day.toString() +' ' +
                              getMonthFromMonthNumber(dataBundleNotifier.currentDateTimeRangeVatService.end.month) +' ' +
                              dataBundleNotifier.currentDateTimeRangeVatService.end.year.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),
                        ),
                      ),
                      buildDetailsIvaWidget(dataBundleNotifier, MediaQuery.of(context).size.width),
                      buildHeaderDetailsIvaWidget(dataBundleNotifier, MediaQuery.of(context).size.width),
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
        RecessedCard(showIndex: false),
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
          Text(recessedModel.amountF.toStringAsFixed(2), style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
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
          totalIva = totalIva + (element.amountF * (element.vat / 100));
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
      if(DateTime.fromMillisecondsSinceEpoch(recessedElement.dateTimeRecessed).isBefore(dataBundleNotifier.currentDateTimeRangeVatService.end)
          && DateTime.fromMillisecondsSinceEpoch(recessedElement.dateTimeRecessed).isAfter(dataBundleNotifier.currentDateTimeRangeVatService.start)){
        currentRecessedVat = currentRecessedVat + ((recessedElement.amountF / 100) * recessedElement.vat);
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '€ ' +
                        (vatCredit - (vatDebit + currentRecessedVat))
                            .toStringAsFixed(2),
                    style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(30)),
                  ),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '€ ' +
                        ((vatDebit + currentRecessedVat) - vatCredit)
                            .toStringAsFixed(2),
                    style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(30)),
                  ),
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
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildCustomCard(kPrimaryColor, Colors.green, 'Fatture Acquisti', dataBundleNotifier.totalIvaAcquisti.toStringAsFixed(2), () {
              Navigator.pushNamed(context, FattureAcquistiDetailsPage.routeName);
            }),
            buildCustomCard(kPrimaryColor, Colors.green, 'NDC(Emesse)', dataBundleNotifier.totalIvaNdcSent.toStringAsFixed(2), () { }),
            buildCustomCard(kPrimaryColor, Colors.redAccent, 'Fatture Vendite', dataBundleNotifier.totalIvaFatture.toStringAsFixed(2), () { }),
            buildCustomCard(kPrimaryColor, Colors.redAccent, 'NDC(Ricevute)', dataBundleNotifier.totalIvaNdcReceived.toStringAsFixed(2), () { }),
            buildCustomCard(kPrimaryColor, Colors.redAccent, 'Incassi', calculateVatFromListRecessed(dataBundleNotifier
                .getRecessedListByRangeDate(
                dataBundleNotifier.currentDateTimeRangeVatService.start,
                dataBundleNotifier.currentDateTimeRangeVatService.end))
                .toStringAsFixed(2), () { }),

          ],
        ),
      ),
    );
    listOut.add(
      Divider(),
    );
    return Column(
      children: listOut,
    );
  }

  Card buildCustomCard(Color primaryColor, Color shadowColor, String description, String value, Function function){
    return Card(
      elevation: 8,
      color: primaryColor,
      shadowColor: shadowColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: function,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Iva',
                    style: TextStyle(
                        color: Colors.white, fontSize: getProportionateScreenWidth(8), fontWeight: FontWeight.bold),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                        color: Colors.white, fontSize: getProportionateScreenWidth(8), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text('€ ' + value,
                style: TextStyle(
                    color: shadowColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(11)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
