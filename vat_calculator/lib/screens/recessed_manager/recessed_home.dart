import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import '../../client/vatservice/model/cash_register_model.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'components/recessed_body.dart';
import 'components/recessed_reg_card.dart';

class RecessedScreen extends StatefulWidget {
  const RecessedScreen({Key key}) : super(key: key);


  static String routeName = "/recessedscreen";

  @override
  _RecessedScreenState createState() => _RecessedScreenState();
}

class _RecessedScreenState extends State<RecessedScreen> {

  DateTimeRange _currentDateTimeRange;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              backgroundColor: kCustomGreen,
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
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, HomeScreen.routeName),
                  }),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        'Area Gestione Incassi',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(17),
                          color: kCustomGreen,
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
                IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/cashregister.svg",
                      color: Colors.white,
                      width: getProportionateScreenWidth(22),
                    ),
                    onPressed: () {
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
                                            color: kCustomGreen,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(25.0),
                                                bottomRight: Radius.circular(25.0)),
                                          ),
                                          child: SizedBox(
                                            width: getProportionateScreenWidth(300),
                                            child: CupertinoButton(child: const Text('Crea'), color: kCustomGreen, onPressed: () async {

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
                IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/calendar.svg",
                      color: Colors.white,
                      width: getProportionateScreenWidth(22),
                    ),
                    onPressed: () {
                      _selectDateTimeRange(context, dataBundleNotifier);

                    }),

              ],
              elevation: 2,
            ),
            body: const RecessedBodyWidget(),
          );
        });
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
