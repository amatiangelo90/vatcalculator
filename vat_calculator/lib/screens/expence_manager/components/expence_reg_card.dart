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

import '../../../constants.dart';
import '../../../size_config.dart';

class ExpenceCard extends StatefulWidget {
  const ExpenceCard({Key key}) : super(key: key);

  @override
  _ExpenceCardState createState() => _ExpenceCardState();
}

class _ExpenceCardState extends State<ExpenceCard> {

  final List<String> errors = [];
  String importExpences;
  TextEditingController expenceController = TextEditingController();
  TextEditingController casualeExpenceController = TextEditingController();


  DateTime _currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Container(
          child: Column(
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
                      DatePicker(
                        DateTime.now().subtract(Duration(days: 8)),
                        initialSelectedDate: DateTime.now(),
                        selectionColor: kCustomYellow800,
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
                                  controller: expenceController,
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
                                  controller: casualeExpenceController,
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
                              child: const Text('Salva Spesa'),
                              color: kCustomYellow800,
                              onPressed: () async {
                                try {
                                  KeyboardUtil.hideKeyboard(context);
                                  if (expenceController.text == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                            const Duration(milliseconds: 2000),
                                            backgroundColor:
                                            Colors.redAccent.withOpacity(0.8),
                                            content: const Text(
                                              'Inserire importo',
                                              style: TextStyle(color: Colors.white),
                                            )));
                                  } else if (double.tryParse(
                                      expenceController.text) ==
                                      null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                            const Duration(milliseconds: 2000),
                                            backgroundColor:
                                            Colors.redAccent.withOpacity(0.8),
                                            content: const Text(
                                              'Inserire un importo corretto',
                                              style: TextStyle(color: Colors.white),
                                            )));
                                  } else if (casualeExpenceController.text == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                            const Duration(milliseconds: 2000),
                                            backgroundColor:
                                            Colors.redAccent.withOpacity(0.8),
                                            content: const Text(
                                              'Inserire casuale',
                                              style: TextStyle(color: Colors.white),
                                            )));
                                  } else {
                                    Widget fiscalButton = TextButton(
                                      child: Text(
                                        "Fiscale",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                            getProportionateScreenHeight(15)),
                                      ),
                                      onPressed: () async {
                                        try {
                                          ClientVatService clientService =
                                          dataBundleNotifier
                                              .getclientServiceInstance();

                                          await clientService.performSaveExpence(
                                              double.parse(expenceController.text),
                                              casualeExpenceController.text,
                                              0,
                                              _currentDate.add(Duration(hours: 1)).millisecondsSinceEpoch,
                                              dataBundleNotifier
                                                  .currentBranch.pkBranchId,
                                              'Y',
                                              ActionModel(
                                                  date: DateTime.now()
                                                      .millisecondsSinceEpoch,
                                                  description:
                                                  'Ha registrato spesa fiscale ${expenceController.text} € con casuale [${casualeExpenceController.text}] per attività ${dataBundleNotifier.currentBranch.companyName}',
                                                  fkBranchId: dataBundleNotifier
                                                      .currentBranch.pkBranchId,
                                                  user: dataBundleNotifier
                                                      .retrieveNameLastNameCurrentUser(),
                                                  type: ActionType.EXPENCE_CREATION));

                                          List<ExpenceModel> _expencesModelList =
                                          await clientService
                                              .retrieveExpencesListByBranch(
                                              dataBundleNotifier
                                                  .currentBranch);
                                          dataBundleNotifier.addCurrentExpencesList(
                                              _expencesModelList);
                                          expenceController.clear();
                                          casualeExpenceController.clear();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                  duration:
                                                  Duration(milliseconds: 2000),
                                                  backgroundColor: Colors
                                                      .green.shade800
                                                      .withOpacity(0.6),
                                                  content: const Text(
                                                    'Spesa fiscale registrata',
                                                    style: TextStyle(
                                                        fontFamily: 'LoraFont',
                                                        color: Colors.white),
                                                  )));
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

                                        Navigator.of(context).pop();
                                      },
                                    );
                                    Widget notFiscalButton = TextButton(
                                      child: Text(
                                        "Non Fiscale",
                                        style: TextStyle(
                                            color: kPinaColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                            getProportionateScreenHeight(15)),
                                      ),
                                      onPressed: () async {
                                        try {
                                          ClientVatService clientService = dataBundleNotifier.getclientServiceInstance();

                                          await clientService.performSaveExpence(
                                              double.parse(expenceController.text),
                                              casualeExpenceController.text,
                                              0,
                                              _currentDate.add(Duration(hours: 1)).millisecondsSinceEpoch,
                                              dataBundleNotifier
                                                  .currentBranch.pkBranchId,
                                              'N',
                                              ActionModel(
                                                  date: DateTime.now()
                                                      .millisecondsSinceEpoch,
                                                  description:
                                                  'Ha registrato spesa non fiscale ${expenceController.text} € con casuale [${casualeExpenceController.text}] per attività ${dataBundleNotifier.currentBranch.companyName}',
                                                  fkBranchId: dataBundleNotifier
                                                      .currentBranch.pkBranchId,
                                                  user: dataBundleNotifier
                                                      .retrieveNameLastNameCurrentUser(),
                                                  type: ActionType.EXPENCE_CREATION));

                                          List<ExpenceModel> _expencesModelList =
                                          await clientService
                                              .retrieveExpencesListByBranch(
                                              dataBundleNotifier
                                                  .currentBranch);
                                          dataBundleNotifier.addCurrentExpencesList(
                                              _expencesModelList);
                                          expenceController.clear();
                                          casualeExpenceController.clear();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                  duration:
                                                  Duration(milliseconds: 2000),
                                                  backgroundColor: Colors
                                                      .blue.shade700
                                                      .withOpacity(0.6),
                                                  content: Text(
                                                    'Spesa non fiscale registrata',
                                                    style: TextStyle(
                                                        fontFamily: 'LoraFont',
                                                        color: Colors.white),
                                                  )));
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

                                        Navigator.of(context).pop();
                                      },
                                    );
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          actions: [
                                            ButtonBar(
                                              alignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                notFiscalButton,
                                                fiscalButton
                                              ],
                                            ),
                                          ],
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
                                                width: width - 90,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
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
                                                                  '    Registra Spesa',
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    getProportionateScreenWidth(
                                                                        15),
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                        children: [
                                                          Text(
                                                            'Descrizione: ',
                                                            style: TextStyle(
                                                                fontSize:
                                                                getProportionateScreenHeight(
                                                                    14)),
                                                          ),
                                                          Text(
                                                            casualeExpenceController
                                                                .text
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                getProportionateScreenHeight(
                                                                    15),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                        children: [
                                                          Text(
                                                            'Importo : ',
                                                            style: TextStyle(
                                                                fontSize:
                                                                getProportionateScreenHeight(
                                                                    14)),
                                                          ),
                                                          Text(
                                                            '€ ' +
                                                                expenceController
                                                                    .text
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                getProportionateScreenHeight(
                                                                    15),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ));
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
            ],
          ),
        );
      },
    );
  }
}
