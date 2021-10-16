import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/components/custom_surfix_icon.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/form_error.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/registration_company/registration_company_screen.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final List<String> errors = [];
  String importExpences;
  final _formExpenceKey = GlobalKey<FormState>();

  TextEditingController recessedController = TextEditingController();
  TextEditingController casualeRecessedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Container(
          color: const Color(0xFFF5F6F9),
          child: dataBundleNotifier.dataBundleList.isEmpty || dataBundleNotifier.dataBundleList[0].companyList.isEmpty ? Padding(
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
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: getProportionateScreenHeight(56),
                    child: buildGestureDetectorBranchSelector(context, dataBundleNotifier),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: IconButton(icon: const Icon(
                        Icons.arrow_back_ios,
                        color: kPrimaryColor,
                      ), onPressed: () { dataBundleNotifier.removeOneDayToDate(); },),
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
                                                          color: const Color(0xFFF5F6F9),
                                                        ),),
                                                        IconButton(icon: const Icon(
                                                          Icons.clear,
                                                          color: Color(0xFFF5F6F9),
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
                        child: Text(dataBundleNotifier.getCurrentDate(), style: TextStyle(fontSize: 20),)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: IconButton(icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: kPrimaryColor,
                      ), onPressed: () { dataBundleNotifier.addOneDayToDate(); },),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
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

                                        ClientVatService clientService = ClientVatService();
                                        await clientService.saveRecessed(
                                            double.parse(recessedController.text),
                                            casualeRecessedController.text,
                                            dataBundleNotifier.getIvaList()[dataBundleNotifier.indexIvaList],
                                            dataBundleNotifier.currentDateTime.millisecondsSinceEpoch,
                                            dataBundleNotifier.currentBranch.pkBranchId
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
              ],
            ),
          ),
        );
      },
    );
  }

  GestureDetector buildGestureDetectorBranchSelector(BuildContext context,
      DataBundleNotifier dataBundleNotifier) {
    return GestureDetector(
                onTap: () {
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
                              height: height - 350,
                              width: width,
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
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('  Lista Attività',style: TextStyle(
                                            fontSize: getProportionateScreenWidth(20),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),),
                                          IconButton(icon: const Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                          ), onPressed: () { Navigator.pop(context); },),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: buildListBranches(dataBundleNotifier),
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
                child: Card(
                  color: kPinaColor,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                          child: Text('' + dataBundleNotifier.currentBranch.companyName, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(20)),),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white,),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }

  buildListBranches(DataBundleNotifier dataBundleNotifier) {

    List<Widget> branchWidgetList = [];

    dataBundleNotifier.dataBundleList[0].companyList.forEach((currentBranch) {
      branchWidgetList.add(
        GestureDetector(
            child: Container(
                  decoration: BoxDecoration(
                    color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? kPinaColor : Colors.white,
                    border: const Border(
                      bottom: BorderSide(width: 1.0, color: Colors.grey),
                    ),
                 ),
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('   ' + currentBranch.companyName,
                      style: TextStyle(
                      fontSize: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? getProportionateScreenWidth(20) : getProportionateScreenWidth(16),
                        color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.white : Colors.black,
                    ),),
                  ],
                ),
              ),
            ),
            onTap: () {
              dataBundleNotifier.setCurrentBranch(currentBranch);
              Navigator.pop(context);
            },
        ),
      );
    });
    return branchWidgetList;
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
      border: TableBorder.symmetric(inside: BorderSide(width: 1, color: const Color(0xFFF5F6F9))),
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
                  && dataBundleNotifier.currentDateTime.month == currentDate.month) ? Colors.grey : const Color(0xFFF5F6F9),
              border: const Border(
                bottom: BorderSide(width: 1.0, color: Colors.blueGrey),

              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  currentDate.day == DateTime.now().day ?
                  Text('  OGGI',
                    style: TextStyle(
                      fontSize: (dataBundleNotifier.currentDateTime.day == currentDate.day
                          && dataBundleNotifier.currentDateTime.month == currentDate.month) ? getProportionateScreenWidth(16) : getProportionateScreenWidth(13),
                      color: (dataBundleNotifier.currentDateTime.day == currentDate.day
                          && dataBundleNotifier.currentDateTime.month == currentDate.month) ? Colors.white : Colors.black,
                    ),) :
                  Text('  '  + currentDate.day.toString() + '.' + currentDate.month.toString() + ' ' + getNameDayFromWeekDay(currentDate.weekday),
                    style: TextStyle(
                      fontSize: (dataBundleNotifier.currentDateTime.day == currentDate.day
                          && dataBundleNotifier.currentDateTime.month == currentDate.month) ? getProportionateScreenWidth(16) : getProportionateScreenWidth(13),
                      color: (dataBundleNotifier.currentDateTime.day == currentDate.day
                          && dataBundleNotifier.currentDateTime.month == currentDate.month) ? Colors.white : Colors.black,
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

