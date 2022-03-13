import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../client/vatservice/model/action_model.dart';
import '../../../client/vatservice/model/cash_register_model.dart';
import '../../../client/vatservice/model/utils/action_type.dart';
import '../../../helper/keyboard.dart';
import '../../../size_config.dart';

class RecessedBodyWidget extends StatefulWidget {
  const RecessedBodyWidget({Key key}) : super(key: key);

  @override
  _RecessedBodyWidgetState createState() => _RecessedBodyWidgetState();
}

class _RecessedBodyWidgetState extends State<RecessedBodyWidget> {
  double width;
  double height;

  DateTimeRange _currentDateTimeRange;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Container(
          color: kPrimaryColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                  child: SizedBox(
                    width: getProportionateScreenWidth(400),
                    height: getProportionateScreenHeight(45),
                    child: Card(
                      color: kCustomGreen,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          dataBundleNotifier.currentListCashRegister.length > 1 ? IconButton(onPressed: (){
                            dataBundleNotifier.switchCurrentCashRegisterBack();
                          }, icon: const Icon(Icons.arrow_back_ios, color: Colors.white,)) : SizedBox(height: 0),
                          Text(
                            dataBundleNotifier.currentCashRegisterModel.name,
                            style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(20)),
                          ),
                          dataBundleNotifier.currentListCashRegister.length > 1 ? IconButton(onPressed: (){
                            dataBundleNotifier.switchCurrentCashRegisterForward();
                          }, icon: const Icon(Icons.arrow_forward_ios, color: Colors.white,)) : SizedBox(height: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dataBundleNotifier.currentDateTimeRangeVatService.start.day.toString() + ' ' +
                            getMonthFromMonthNumber(dataBundleNotifier.currentDateTimeRangeVatService.start.month) +' ' +
                            dataBundleNotifier.currentDateTimeRangeVatService.start.year.toString() + ' - ' +
                            dataBundleNotifier.currentDateTimeRangeVatService.end.day.toString() +' ' +
                            getMonthFromMonthNumber(dataBundleNotifier.currentDateTimeRangeVatService.end.month) +' ' +
                            dataBundleNotifier.currentDateTimeRangeVatService.end.year.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      IconButton(
                          icon: SvgPicture.asset(
                            "assets/icons/calendar.svg",
                            color: kCustomGreen,
                            width: getProportionateScreenWidth(22),
                          ),
                          onPressed: () {
                            _selectDateTimeRange(context, dataBundleNotifier);

                          }
                      ),
                    ],
                  ),
                ),
                buildRecessedTable(dataBundleNotifier
                    .getRecessedListByRangeDate(
                    dataBundleNotifier.currentDateTimeRangeVatService.start,
                    dataBundleNotifier.currentDateTimeRangeVatService.end), dataBundleNotifier),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  buildRecessedTable(List<RecessedModel> currentListRecessed, DataBundleNotifier dataBundleNotifier) {
    List<TableRow> rows = [
      const TableRow( children: [
        Text('DATA', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        Text('CASH', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen),),
        Text('FISCALE', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen),),
        Text('POS', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen),),
        Text('EXTRA', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen),),
      ]),
    ];

    currentListRecessed.forEach((recessed) {

      if(dataBundleNotifier.currentCashRegisterModel.pkCashRegisterId == recessed.fkCashRegisterId){
        rows.add(
          TableRow(
              children: [
                GestureDetector(
                  onTap: (){
                    openDialog(recessed, dataBundleNotifier);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(normalizeCalendarValue(DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).day).toString()
                            + '/' + normalizeCalendarValue(DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).month).toString() , textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenWidth(15), color: Colors.white)),
                        Text(DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).year.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenWidth(10), color: Colors.grey),),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    openDialog(recessed, dataBundleNotifier);
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, getProportionateScreenWidth(15), 0, 0),
                    child: Text(recessed.amountCash.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenWidth(15), color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    openDialog(recessed, dataBundleNotifier);
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, getProportionateScreenWidth(15), 0, 0),
                    child: Text(recessed.amountF.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenWidth(15), color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    openDialog(recessed, dataBundleNotifier);
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, getProportionateScreenWidth(15), 0, 0),
                    child: Text(recessed.amountPos.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenWidth(15), color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    openDialog(recessed, dataBundleNotifier);
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, getProportionateScreenWidth(15), 0, 0),
                    child: Text(recessed.amountNF.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenWidth(15), color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ]),
        );
      }

    });
    return Container(
      color: kPrimaryColor,
      child: Table(
        border: TableBorder.all(
            color: Colors.grey,
            width: 0.1
        ),
        children: rows,
      ),
    );
  }

  String normalizeCalendarValue(int day) {
    if (day < 10) {
      return '0' + day.toString();
    } else {
      return day.toString();
    }
  }

  void openDialog(RecessedModel recessed, DataBundleNotifier dataBundleNotifier) {

    TextEditingController recessedCashController = TextEditingController(text: recessed.amountCash.toString());
    TextEditingController recessedFiscalController = TextEditingController(text: recessed.amountF.toString());
    TextEditingController recessedPosController = TextEditingController(text: recessed.amountPos.toString());

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text(
                    "Aggiorna",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize:
                        getProportionateScreenHeight(15)),
                  ),
                  onPressed: () async {


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
                    } else if(isValueValid(recessedFiscalController)){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              duration:
                              const Duration(milliseconds: 2000),
                              backgroundColor:
                              Colors.redAccent.withOpacity(0.8),
                              content: const Text(
                                'Importo Incasso fiscale vuoto o errato',
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
                    } else if(recessedCashController.text == '0' && recessedPosController.text == '0' && recessedFiscalController.text == '0'){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              duration:
                              const Duration(milliseconds: 2000),
                              backgroundColor:
                              Colors.redAccent.withOpacity(0.9),
                              content: const Text(
                                'Nessun importo valorizzato',
                                style: TextStyle(color: Colors.white),
                              )));
                    } else if(double.parse(recessedFiscalController.text) > (double.parse(recessedCashController.text) + double.parse(recessedPosController.text))){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              duration:
                              const Duration(milliseconds: 2500),
                              backgroundColor:
                              Colors.redAccent.withOpacity(0.8),
                              content: const Text(
                                'L\'importo fiscale non può essere maggiore della somma dell\'importo cash + importo pos',
                                style: TextStyle(color: Colors.white),
                              )));
                    } else {
                      try {


                        RecessedModel recessedModel = RecessedModel(
                            pkRecessedId: recessed.pkRecessedId,
                            description: '',
                            amountF: double.parse(recessedFiscalController.text),
                            amountNF: (double.parse(recessedCashController.text) + double.parse(recessedPosController.text)) - double.parse(recessedFiscalController.text),
                            amountCash: double.parse(recessedCashController.text),
                            amountPos: double.parse(recessedPosController.text),
                            vat: recessed.vat,
                            dateTimeRecessed: recessed.dateTimeRecessed,
                            dateTimeRecessedInsert: recessed.dateTimeRecessedInsert,
                            fkCashRegisterId: recessed.fkCashRegisterId);

                        await dataBundleNotifier.getclientServiceInstance().performUpdateRecessed(
                            recessedModel,
                            ActionModel(
                                date: DateTime.now().millisecondsSinceEpoch,
                                description: 'Ha aggiornato incasso fiscale del '
                                    '[${DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).day} -'
                                    ' ${DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).month}] '
                                    'in Fiscale: [${recessedFiscalController.text}], Cash[${recessedCashController.text}],'
                                    ' Pos[${recessedPosController.text}] € per attività ${dataBundleNotifier.currentBranch.companyName}',
                                fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                type: ActionType.RECESSED_UPDATE
                            )
                        );

                        List<CashRegisterModel> currentListCashRegister = [];
                        List<RecessedModel> _recessedModelList = [];

                        if(dataBundleNotifier.currentBranch != null) {

                          if(dataBundleNotifier.currentBranch != null){
                            currentListCashRegister = await dataBundleNotifier.getclientServiceInstance().retrieveCashRegistersByBranchId(dataBundleNotifier.currentBranch);

                            if(currentListCashRegister.isNotEmpty){
                              await Future.forEach(currentListCashRegister,
                                      (CashRegisterModel cashRegisterModel) async {
                                    List<RecessedModel> list = await dataBundleNotifier.getclientServiceInstance().retrieveRecessedListByCashRegister(cashRegisterModel);
                                    _recessedModelList.addAll(list);
                                  });
                            }
                            dataBundleNotifier.addCurrentRecessedList(_recessedModelList);
                            dataBundleNotifier.setCashRegisterList(currentListCashRegister);
                          }
                        }

                        recessedFiscalController.clear();
                        recessedCashController.clear();
                        recessedPosController.clear();

                        KeyboardUtil.hideKeyboard(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                            duration: Duration(milliseconds: 2000),
                            backgroundColor: Colors.green.shade700.withOpacity(0.8),
                            content: Text('Incasso aggiornato', style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                duration: const Duration(
                                    milliseconds: 6000),
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Abbiamo riscontrato un errore durante l\'operazione. Riprova più tardi. Errore: $e',
                                  style: const TextStyle(
                                      fontFamily: 'LoraFont',
                                      color: Colors.white),
                                )));
                      }
                    }

                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    "Elimina",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize:
                        getProportionateScreenHeight(15)),
                  ),
                  onPressed: () async {
                    try{
                      await dataBundleNotifier.getclientServiceInstance().performDeleteRecessed(
                          recessed,
                          ActionModel(
                              date: DateTime.now().millisecondsSinceEpoch,
                              description: 'Ha eliminato incasso del [${DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).day}/${DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).month}]. Dettaglio Incasso Fiscale: [${recessedFiscalController.text} €], Cash[${recessedCashController.text} €], Pos[${recessedPosController.text} €] per attività ${dataBundleNotifier.currentBranch.companyName}',
                              fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                              user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                              type: ActionType.RECESSED_DELETE
                          )
                      );

                      List<CashRegisterModel> currentListCashRegister = [];
                      List<RecessedModel> _recessedModelList = [];

                      if(dataBundleNotifier.currentBranch != null) {

                        if(dataBundleNotifier.currentBranch != null){
                          currentListCashRegister = await dataBundleNotifier.getclientServiceInstance().retrieveCashRegistersByBranchId(dataBundleNotifier.currentBranch);

                          if(currentListCashRegister.isNotEmpty){
                            await Future.forEach(currentListCashRegister,
                                    (CashRegisterModel cashRegisterModel) async {
                                  List<RecessedModel> list = await dataBundleNotifier.getclientServiceInstance().retrieveRecessedListByCashRegister(cashRegisterModel);
                                  _recessedModelList.addAll(list);
                                });
                          }
                          dataBundleNotifier.addCurrentRecessedList(_recessedModelList);
                          dataBundleNotifier.setCashRegisterList(currentListCashRegister);
                        }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              duration: Duration(
                                  milliseconds: 2000),
                              backgroundColor: Colors.redAccent,
                              content: Text(
                                'Incasso eliminato correttamente',
                                style: TextStyle(
                                    fontFamily: 'LoraFont',
                                    color: Colors.white),
                              )));
                      Navigator.of(context).pop();
                    }catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              duration: const Duration(
                                  milliseconds: 6000),
                              backgroundColor: Colors.red,
                              content: Text(
                                'Abbiamo riscontrato un errore durante l\'operazione. Riprova più tardi. Errore: $e',
                                style: const TextStyle(
                                    fontFamily: 'LoraFont',
                                    color: Colors.white),
                              )));
                    }

                  },
                ),
              ],
            ),
          ],
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return SizedBox(
                width: width - 90,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0)),
                          color: kPrimaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [

                            Text('  Aggiorna Incassi ' + normalizeCalendarValue(DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).day).toString()
                                + '/' + normalizeCalendarValue(DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).month).toString() + ''
                                + '/' + DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).year.toString() ,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:
                                  getProportionateScreenWidth(
                                      15),
                                  fontWeight: FontWeight.bold,
                                  color: kCustomWhite,
                                )),
                            IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                const Text('Importo Cash'),
                                SizedBox(
                                  width:
                                  getProportionateScreenWidth(
                                      100),
                                  child: CupertinoTextField(
                                    controller:
                                    recessedCashController,
                                    onChanged: (text) {},
                                    textInputAction:
                                    TextInputAction.next,
                                    keyboardType:
                                    const TextInputType
                                        .numberWithOptions(
                                        decimal: true,
                                        signed: true),
                                    clearButtonMode:
                                    OverlayVisibilityMode
                                        .never,
                                    textAlign: TextAlign.center,
                                    autocorrect: false,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                const Text('Importo Fiscale'),
                                SizedBox(
                                  width:
                                  getProportionateScreenWidth(
                                      100),
                                  child: CupertinoTextField(
                                    controller:
                                    recessedFiscalController,
                                    onChanged: (text) {},
                                    textInputAction:
                                    TextInputAction.next,
                                    keyboardType:
                                    const TextInputType
                                        .numberWithOptions(
                                        decimal: true,
                                        signed: true),
                                    clearButtonMode:
                                    OverlayVisibilityMode
                                        .never,
                                    textAlign: TextAlign.center,
                                    autocorrect: false,
                                  ),
                                ),

                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                const Text('Importo Pos'),
                                SizedBox(
                                  width:
                                  getProportionateScreenWidth(
                                      100),
                                  child: CupertinoTextField(
                                    controller:
                                    recessedPosController,
                                    onChanged: (text) {},
                                    textInputAction:
                                    TextInputAction.next,
                                    keyboardType:
                                    const TextInputType
                                        .numberWithOptions(
                                        decimal: true,
                                        signed: true),
                                    clearButtonMode:
                                    OverlayVisibilityMode
                                        .never,
                                    textAlign: TextAlign.center,
                                    autocorrect: false,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
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
              primary: kCustomGreen,
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

}