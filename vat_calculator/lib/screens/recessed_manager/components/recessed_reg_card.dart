import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/expence_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/components/datepiker/date_picker_timeline.dart';
import 'package:vat_calculator/components/form_error.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../../client/vatservice/model/recessed_model.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../expence_manager/expence_home.dart';

class RecessedCard extends StatefulWidget {
  const RecessedCard({Key key, this.showIndex}) : super(key: key);

  final bool showIndex;

  @override
  _RecessedCardState createState() => _RecessedCardState();
}

class _RecessedCardState extends State<RecessedCard> with RestorationMixin {

  RestorableInt currentSegmentIva;

  TextEditingController recessedCashController = TextEditingController();
  TextEditingController recessedNotFiscalController = TextEditingController();
  TextEditingController recessedFiscalController = TextEditingController();
  TextEditingController recessedPosController = TextEditingController();


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

  DateTime _currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(10),
                      ),
                      Text(
                        'Registra Incassi',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenWidth(12)),
                      ),
                    ],
                  ),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ExpenceScreen.routeName);
                    },
                    child: Row(
                      children: [
                        Text(
                          'Dettaglio Incassi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getProportionateScreenWidth(12),
                              color: Colors.grey),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: getProportionateScreenWidth(15),
                            color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: kPrimaryColor,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DatePicker(
                        DateTime.now().subtract(Duration(days: 4)),
                        initialSelectedDate: DateTime.now(),
                        selectionColor: kCustomGreen,
                        selectedTextColor: Colors.white,
                        width: getProportionateScreenHeight(40),
                        daysCount: 9,
                        dayTextStyle: TextStyle(fontSize: 5),
                        dateTextStyle: TextStyle(fontSize: 15),
                        monthTextStyle: TextStyle(fontSize: 10),
                        onDateChange: (date) {
                          // New date selected
                          setState(() {
                            _currentDate = date;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(1, 8, 1, 8),
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: CupertinoSlidingSegmentedControl<int>(
                                thumbColor: kCustomGreen,

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
                      ),
                      Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                child: Text('Cash', style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(
                                child: CupertinoTextField(
                                  controller: recessedCashController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
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
                              Padding(
                                padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                child: Text(dataBundleNotifier.userDetailsList[0].firstName, style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(
                                child: CupertinoTextField(
                                  controller: recessedNotFiscalController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
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
                                child: Text('Socio', style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(
                                child: CupertinoTextField(
                                  controller: recessedFiscalController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
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
                                child: Text('Pos', style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(
                                child: CupertinoTextField(
                                  controller: recessedPosController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                                  clearButtonMode: OverlayVisibilityMode.never,
                                  textAlign: TextAlign.center,
                                  autocorrect: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        color: kPrimaryColor,
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
                              color: kCustomGreen,
                              onPressed: () async {
                                try {
                                  KeyboardUtil.hideKeyboard(context);
                                  if(isValueValid(recessedCashController)){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                            const Duration(milliseconds: 2000),
                                            backgroundColor:
                                            Colors.redAccent.withOpacity(0.8),
                                            content: const Text(
                                              'Importo Cash vuoto o errato',
                                              style: TextStyle(color: Colors.white),
                                            )));
                                  } else if(isValueValid(recessedNotFiscalController)){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                            const Duration(milliseconds: 2000),
                                            backgroundColor:
                                            Colors.redAccent.withOpacity(0.8),
                                            content: const Text(
                                              'Importo Cash vuoto o errato',
                                              style: TextStyle(color: Colors.white),
                                            )));
                                  }else if(isValueValid(recessedFiscalController)){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                            const Duration(milliseconds: 2000),
                                            backgroundColor:
                                            Colors.redAccent.withOpacity(0.8),
                                            content: const Text(
                                              'Importo Cash vuoto o errato',
                                              style: TextStyle(color: Colors.white),
                                            )));
                                  }else if(isValueValid(recessedPosController)){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                            const Duration(milliseconds: 2000),
                                            backgroundColor:
                                            Colors.redAccent.withOpacity(0.8),
                                            content: const Text(
                                              'Importo Pos vuoto o errato',
                                              style: TextStyle(color: Colors.white),
                                            )));
                                  } else {
                                    try {
                                      ClientVatService clientService = dataBundleNotifier.getclientServiceInstance();

                                      await clientService.performSaveRecessed(
                                          double.parse(recessedFiscalController.text),
                                          double.parse(recessedNotFiscalController.text),
                                          double.parse(recessedCashController.text),
                                          double.parse(recessedPosController.text),
                                          '',
                                          dataBundleNotifier.getIvaList()[dataBundleNotifier.indexIvaList],
                                          dataBundleNotifier.currentDateTime.millisecondsSinceEpoch,
                                          dataBundleNotifier.currentBranch.pkBranchId,
                                          ActionModel(
                                              date: DateTime.now().millisecondsSinceEpoch,
                                              description: 'Ha registrato incasso ${recessedFiscalController.text} € per attività ${dataBundleNotifier.currentBranch.companyName}',
                                              fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                              user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                              type: ActionType.RECESSED_CREATION
                                          )
                                      );

                                      List<RecessedModel> _recessedModelList = await clientService.retrieveRecessedListByBranch(dataBundleNotifier.currentBranch);
                                      dataBundleNotifier.addCurrentRecessedList(_recessedModelList);
                                      dataBundleNotifier.recalculateGraph();

                                      recessedFiscalController.clear();
                                      recessedNotFiscalController.clear();
                                      recessedCashController.clear();
                                      recessedPosController.clear();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          duration: Duration(milliseconds: 2000),
                                          backgroundColor: Colors.green.shade700.withOpacity(0.8),
                                          content: Text('Incasso registrato', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              duration: const Duration(
                                                  milliseconds: 6000),
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                'Abbiamo riscontrato un errore durante l\'operzione. Riprova più tardi. Errore: $e',
                                                style: const TextStyle(
                                                    fontFamily: 'LoraFont',
                                                    color: Colors.white),
                                              )));
                                    }
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      duration: const Duration(milliseconds: 6000),
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Abbiamo riscontrato un errore durante l\'operzione. Riprova più tardi. Errore: $e',
                                        style: const TextStyle(
                                            fontFamily: 'LoraFont',
                                            color: Colors.white),
                                      )));
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
              widget.showIndex ? Center(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Spese / ', style: TextStyle(color: Colors.grey)),
                  Text('Incassi', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen),),
                ],
              )) : Text('')
            ],
          ),
        );
      },
    );
  }

  bool isValueValid(TextEditingController controller) {
    if (controller.text == '') {
      return true;
    } else if (double.tryParse(controller.text) == null) {
      return true;
    }else{
      return false;
    }
  }
}
