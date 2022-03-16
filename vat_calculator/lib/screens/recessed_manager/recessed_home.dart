import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import '../../client/vatservice/model/cash_register_model.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../main_page.dart';
import 'components/recessed_body.dart';
import 'components/recessed_reg_card.dart';

class RecessedScreen extends StatefulWidget {
  const RecessedScreen({Key key}) : super(key: key);


  static String routeName = "/recessedscreen";

  @override
  _RecessedScreenState createState() => _RecessedScreenState();
}

class _RecessedScreenState extends State<RecessedScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: kPrimaryColor,
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                  dataBundleNotifier.onItemTapped(0);
                  Navigator.pushNamed(context, HomeScreenMain.routeName);
                  }),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        'Gestione Incassi',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(16),
                          color: kCustomBlueAccent,
                        ),
                      ),
                      Text(
                        dataBundleNotifier.currentBranch.companyName,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(11),
                          color: kCustomWhite,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Stack(
                  children: [ Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/cashregister.svg",
                          color: Colors.white,
                          width: getProportionateScreenWidth(25),
                        ),
                        onPressed: () {
                          TextEditingController cashRegisterNameController = TextEditingController();

                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                shape: const RoundedRectangleBorder(
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
                                                    _scaffoldKey.currentState.showSnackBar(const SnackBar(
                                                      backgroundColor: kPinaColor,
                                                      duration: Duration(milliseconds: 1200),
                                                      content: Text(
                                                          'Inserisci il nome del Registratore di cassa'),
                                                    ));
                                                  } else if (dataBundleNotifier.isCurrentCashAlreadyUsed(cashRegisterNameController.text)){
                                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
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
                                                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                                                        backgroundColor: Colors.green.withOpacity(0.8),
                                                        duration: Duration(milliseconds: 1200),
                                                        content: const Text(
                                                            'Registratore di cassa creato'),
                                                      ));
                                                      List<CashRegisterModel> cashRegisterModelList= await dataBundleNotifier.getclientServiceInstance().retrieveCashRegistersByBranchId(
                                                          dataBundleNotifier.currentBranch);

                                                      dataBundleNotifier.setCashRegisterList(cashRegisterModelList);
                                                    }else{
                                                      _scaffoldKey.currentState.showSnackBar(const SnackBar(
                                                        backgroundColor: kPinaColor,
                                                        duration: Duration(milliseconds: 1500),
                                                        content: Text(
                                                            'Errore durante la creazione del registratore di cassa. Si prega di riprovare'),
                                                      ));
                                                    }
                                                  Navigator.of(context).pop();
                                                  }
                                                }
                                                ),
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
                        }),
                  ),
                    Positioned(
                      top: 26.0,
                      right: 3.0,
                      child: Stack(
                        children: const <Widget>[
                          Icon(
                            Icons.brightness_1,
                            size: 18,
                            color: kPrimaryColor,
                          ),
                          Positioned(
                            right: 2.5,
                            top: 2.5,
                            child: Center(
                              child: Icon(Icons.add_circle_outline, size: 13, color: kCustomBlueAccent,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 7,),
                SizedBox(
                  height: getProportionateScreenWidth(35),
                  width: getProportionateScreenWidth(35),
                  child: FittedBox(
                    child: FloatingActionButton(
                      child: Icon(Icons.add, size: getProportionateScreenWidth(40)),
                      backgroundColor: kCustomBlueAccent,
                      elevation: 5,
                      onPressed: (){
                        showDialog(context: context, builder: (_) => AlertDialog(
                          backgroundColor: Colors.transparent,
                          content: Container(
                            width: getProportionateScreenWidth(500),
                            child: SingleChildScrollView(

                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  RecessedCard(showIndex: false, showHeader: false),
                                ],
                              ),
                            ),
                          ),
                        ));
                      },
                    ),
                  ),
                ),
                SizedBox(width: 7,)
              ],
              elevation: 2,
            ),
            body: const RecessedBodyWidget(),
            bottomSheet: Container(
              color: kPrimaryColor,
              child: SizedBox(
                height: 50,
                child: Table(
                  border: TableBorder.all(
                      color: Colors.grey,
                      width: 0.2
                  ),
                  children: [
                    TableRow( children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, getProportionateScreenWidth(10), 0, 50),child: Text('TOT.', textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenWidth(16),fontWeight: FontWeight.bold, color: Colors.white),),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, getProportionateScreenWidth(10), 0, 50),
                        child: Text(getTotalCashFromCurrentListRecessed(dataBundleNotifier
                            .getRecessedListByRangeDate(
                            dataBundleNotifier.currentDateTimeRangeVatService.start,
                            dataBundleNotifier.currentDateTimeRangeVatService.end), dataBundleNotifier.currentCashRegisterModel), textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenWidth(16),fontWeight: FontWeight.bold, color: kCustomBlueAccent),),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, getProportionateScreenWidth(10), 0, 122),
                        child: Text(getTotalAmountFFromCurrentListRecessed(dataBundleNotifier
                            .getRecessedListByRangeDate(
                            dataBundleNotifier.currentDateTimeRangeVatService.start,
                            dataBundleNotifier.currentDateTimeRangeVatService.end), dataBundleNotifier.currentCashRegisterModel), textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenWidth(16),fontWeight: FontWeight.bold, color: kCustomBlueAccent),),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, getProportionateScreenWidth(10), 0, 50),child: Text(getTotalAmountPosFromCurrentListRecessed(dataBundleNotifier
                            .getRecessedListByRangeDate(
                            dataBundleNotifier.currentDateTimeRangeVatService.start,
                            dataBundleNotifier.currentDateTimeRangeVatService.end), dataBundleNotifier.currentCashRegisterModel), textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenWidth(16),fontWeight: FontWeight.bold, color: kCustomBlueAccent),),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, getProportionateScreenWidth(10), 0, 50),
                        child: Text(getTotalAmountExtraFromCurrentListRecessed(dataBundleNotifier
                            .getRecessedListByRangeDate(
                            dataBundleNotifier.currentDateTimeRangeVatService.start,
                            dataBundleNotifier.currentDateTimeRangeVatService.end), dataBundleNotifier.currentCashRegisterModel), textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenWidth(16),fontWeight: FontWeight.bold, color: kCustomBlueAccent),),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          );
        });
  }


  String getTotalCashFromCurrentListRecessed(List<RecessedModel> recessedList, CashRegisterModel currentCashRegisterModel) {

    double total = 0.0;

    recessedList.forEach((element) {
      if(element.fkCashRegisterId == currentCashRegisterModel.pkCashRegisterId){
        total = total + element.amountCash;
      }
    });
    return total.toStringAsFixed(2).replaceAll('.00', '');
  }

  String getTotalAmountFFromCurrentListRecessed(List<RecessedModel> recessedList, CashRegisterModel currentCashRegisterModel) {
    double total = 0.0;

    recessedList.forEach((element) {
      if(element.fkCashRegisterId == currentCashRegisterModel.pkCashRegisterId){
        total = total + element.amountF;
      }
    });
    return total.toStringAsFixed(2).replaceAll('.00', '');
  }

  String getTotalAmountPosFromCurrentListRecessed(List<RecessedModel> recessedList, CashRegisterModel currentCashRegisterModel) {
    double total = 0.0;

    recessedList.forEach((element) {
      if(element.fkCashRegisterId == currentCashRegisterModel.pkCashRegisterId){
        total = total + element.amountPos;
      }
    });
    return total.toStringAsFixed(2).replaceAll('.00', '');
  }

  String getTotalAmountExtraFromCurrentListRecessed(List<RecessedModel> recessedList, CashRegisterModel currentCashRegisterModel) {
    double total = 0.0;

    recessedList.forEach((element) {
      if(element.fkCashRegisterId == currentCashRegisterModel.pkCashRegisterId){
        total = total + element.amountNF;
      }
    });
    return total.toStringAsFixed(2).replaceAll('.00', '');
  }

}
