import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/components/form_error.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class RecessedCard extends StatefulWidget {
  const RecessedCard({Key key}) : super(key: key);

  @override
  _RecessedCardState createState() => _RecessedCardState();
}

class _RecessedCardState extends State<RecessedCard> with RestorationMixin{

  RestorableInt currentSegmentIva;
  TextEditingController recessedController = TextEditingController();
  TextEditingController casualeRecessedController = TextEditingController();

  final List<String> errors = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Column(
          children: [
            Card(
              color: kPrimaryColor,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: IconButton(icon: Icon(
                            Icons.arrow_back_ios,
                            size: getProportionateScreenWidth(15),
                            color: kCustomYellow800,
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
                            child: Text(dataBundleNotifier.getCurrentDate(), style: TextStyle(fontSize: 15, color: kCustomYellow800),)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: IconButton(icon: Icon(
                            Icons.arrow_forward_ios,
                            size: getProportionateScreenWidth(15),
                            color: kCustomYellow800,
                          ), onPressed: () { dataBundleNotifier.addOneDayToDate(); },),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                              child: Text('Importo (€)', style: TextStyle(color: Colors.white),),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(100),
                              child: CupertinoTextField(
                                controller: recessedController,
                                onChanged: (text) {},
                                textInputAction: TextInputAction.next,
                                keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true, signed: true),
                                clearButtonMode: OverlayVisibilityMode.never,
                                textAlign: TextAlign.center,
                                autocorrect: false,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                              child: Text('Casuale', style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(240),
                              child: CupertinoTextField(
                                controller: casualeRecessedController,
                                onChanged: (text) {},
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
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: kCustomYellow800,
                      endIndent: 10,
                      indent: 10,
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(400),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SizedBox(
                          width: getProportionateScreenWidth(320),
                          child: CupertinoButton(
                            pressedOpacity: 0.5,
                            child: const Text('Salva Incasso'),
                            color: kCustomYellow800,
                            onPressed: () async {
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    currentSegmentIva = RestorableInt(0);

  }

  @override
  String get restorationId => 'cupertino_control';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(currentSegmentIva, 'current_segment');
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
                  ? kCustomYellow800
                  : kCustomWhite,
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey),

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


}
