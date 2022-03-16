import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/expence_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/components/datepiker/date_picker_timeline.dart';
import 'package:vat_calculator/components/form_error.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../../client/vatservice/model/cash_register_model.dart';
import '../../../client/vatservice/model/recessed_model.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../expence_manager/expence_home.dart';
import '../recessed_home.dart';

class RecessedCard extends StatefulWidget {
  const RecessedCard({Key key, this.showIndex, this.showHeader}) : super(key: key);

  final bool showIndex;
  final bool showHeader;

  @override
  _RecessedCardState createState() => _RecessedCardState();
}

class _RecessedCardState extends State<RecessedCard> with RestorationMixin {

  RestorableInt currentSegmentIva;

  TextEditingController recessedCashController = TextEditingController();
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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                widget.showHeader ? Row(
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
                        Navigator.pushNamed(context, RecessedScreen.routeName);
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
                ) : SizedBox(width: 0),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: kPrimaryColor,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: dataBundleNotifier.currentListCashRegister.isNotEmpty ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(' Cassa', style: TextStyle(color: Colors.white)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset('assets/icons/Settings.svg'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(400),
                          height: getProportionateScreenHeight(45),
                          child: Card(
                            color: kCustomBlueAccent,
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
                        const Padding(
                          padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                          child: Text(' Data', style: TextStyle(color: Colors.white)),
                        ),
                        DatePicker(
                          DateTime.now().subtract(Duration(days: 4)),
                          initialSelectedDate: DateTime.now(),
                          selectionColor: kCustomBlueAccent,
                          selectedTextColor: Colors.white,
                          width: getProportionateScreenHeight(40),
                          daysCount: 9,
                          dayTextStyle: const TextStyle(fontSize: 5),
                          dateTextStyle: const TextStyle(fontSize: 15),
                          monthTextStyle: const TextStyle(fontSize: 10),
                          onDateChange: (date) {
                            // New date selected
                            setState(() {
                              _currentDate = date;
                            });
                          },
                        ),
                        const Text(' Iva', style: TextStyle(color: Colors.white)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(1, 2, 1, 2),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: CupertinoSlidingSegmentedControl<int>(
                                  thumbColor: kCustomBlueAccent,

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
                                  child: Text('Incasso fiscale ' + dataBundleNotifier.currentBranch.companyName, style: TextStyle(color: Colors.white)),
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
                                color: kCustomBlueAccent,
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
                                    } else if(double.parse(recessedFiscalController.text.replaceAll(",", "."))
                                        > (double.parse(recessedCashController.text.replaceAll(",", ".")) + double.parse(recessedPosController.text.replaceAll(",", ".")))){
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

                                        ClientVatService clientService = dataBundleNotifier.getclientServiceInstance();

                                        await clientService.performSaveRecessed(
                                            double.parse(recessedFiscalController.text.replaceAll(",", ".")),
                                            (double.parse(recessedCashController.text.replaceAll(",", ".")) + double.parse(recessedPosController.text.replaceAll(",", "."))) - double.parse(recessedFiscalController.text.replaceAll(",", ".")),
                                            double.parse(recessedCashController.text.replaceAll(",", ".")),
                                            double.parse(recessedPosController.text.replaceAll(",", ".")),
                                            '',
                                            dataBundleNotifier.getIvaList()[dataBundleNotifier.indexIvaList],
                                            _currentDate.millisecondsSinceEpoch + 3600000,
                                            dataBundleNotifier.currentCashRegisterModel.pkCashRegisterId,

                                            ActionModel(
                                                date: DateTime.now().millisecondsSinceEpoch,
                                                description: 'Ha registrato incasso ${recessedFiscalController.text} su cassa ${dataBundleNotifier.currentCashRegisterModel.name} € per attività ${dataBundleNotifier.currentBranch.companyName}',
                                                fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                                user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                                type: ActionType.RECESSED_CREATION
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
                                            content: Text('Incasso registrato', style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
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
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ) : Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(2, 50, 0, 50),
                          child: Text(' Per iniziare a registrare i tuoi incassi ed utilizzarli per calcolare l\'iva configura un registratore di cassa', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(400),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: getProportionateScreenWidth(320),
                              child: CupertinoButton(
                                pressedOpacity: 0.5,
                                child: const Text('Configura Registratore di Cassa', textAlign: TextAlign.center),
                                color: kCustomBlueAccent,
                                onPressed: () async {
                                  TextEditingController cashRegisterNameController = TextEditingController();

                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(25.0))),
                                        backgroundColor: kCustomWhite,
                                        contentPadding: EdgeInsets.only(top: 10.0),
                                        elevation: 30,

                                        content: SizedBox(
                                          height: getProportionateScreenHeight(250),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Configura Registratore di cassa', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text('   Nome Registratore di cassa', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(10)),)
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: ConstrainedBox(
                                                          constraints: BoxConstraints.loose(Size(
                                                              getProportionateScreenWidth(300),
                                                              getProportionateScreenWidth(80))),
                                                          child: CupertinoTextField(
                                                            controller: cashRegisterNameController,
                                                            textInputAction: TextInputAction.next,
                                                            keyboardType: TextInputType.text,
                                                            clearButtonMode: OverlayVisibilityMode.never,
                                                            textAlign: TextAlign.center,
                                                            autocorrect: false,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: getProportionateScreenHeight(25),
                                                  ),
                                                  InkWell(
                                                    child: Container(
                                                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                                        decoration: const BoxDecoration(
                                                          color: kCustomBlueAccent,
                                                          borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius.circular(25.0),
                                                              bottomRight: Radius.circular(25.0)),
                                                        ),
                                                        child: SizedBox(
                                                          width: getProportionateScreenWidth(300),
                                                          child: CupertinoButton(child: const Text('Crea'), color: kCustomBlueAccent, onPressed: () async {

                                                            if (cashRegisterNameController.text == null || cashRegisterNameController.text == '') {
                                                              Scaffold.of(context).showSnackBar(const SnackBar(
                                                                backgroundColor: kPinaColor,
                                                                duration: Duration(milliseconds: 1200),
                                                                content: Text(
                                                                    'Inserisci il nome del Registratore di cassa'),
                                                              ));
                                                              } else if (dataBundleNotifier.isCurrentCashAlreadyUsed(cashRegisterNameController.text)){
                                                                Scaffold.of(context).showSnackBar(SnackBar(
                                                                  backgroundColor: kPinaColor,
                                                                  duration: Duration(milliseconds: 1200),
                                                                  content: Text(
                                                                      'Errore. Esiste già un registratore di cassa denominato ${cashRegisterNameController.text}'),
                                                                ));
                                                              } else {
                                                              Response response = await dataBundleNotifier.getclientServiceInstance().createCashRegister(CashRegisterModel(
                                                                  pkCashRegisterId: 0,
                                                                  name: cashRegisterNameController.text,
                                                                  fkBranchId: dataBundleNotifier.currentBranch.pkBranchId));

                                                              if(response != null && response.data > 0){
                                                                Scaffold.of(context).showSnackBar(SnackBar(
                                                                  backgroundColor: Colors.green.withOpacity(0.8),
                                                                  duration: Duration(milliseconds: 1200),
                                                                  content: const Text(
                                                                      'Registratore di cassa creato'),
                                                                ));
                                                                List<CashRegisterModel> cashRegisterModelList= await dataBundleNotifier.getclientServiceInstance().retrieveCashRegistersByBranchId(
                                                                    dataBundleNotifier.currentBranch);

                                                                dataBundleNotifier.setCashRegisterList(cashRegisterModelList);
                                                              }else{
                                                                Scaffold.of(context).showSnackBar(const SnackBar(
                                                                  backgroundColor: kPinaColor,
                                                                  duration: Duration(milliseconds: 1500),
                                                                  content: Text(
                                                                      'Errore durante la creazione del registratore di cassa. Si prega di riprovare'),
                                                                ));
                                                              }
                                                            }
                                                            Navigator.of(context).pop();
                                                          }),
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  );
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
                    Text('Incassi', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomBlueAccent),),
                  ],
                )) : Text('')
              ],
            ),
          ),
        );
      },
    );
  }

  bool isValueValid(TextEditingController controller) {
    if (controller.text == '') {
      return true;
    } else if (double.tryParse(controller.text.replaceAll(",", ".")) == null) {
      return true;
    }else{
      return false;
    }
  }

  buildCashRegisterWidget(DataBundleNotifier dataBundleNotifier) {}


}
