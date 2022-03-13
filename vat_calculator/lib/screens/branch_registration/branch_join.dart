import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/cash_register_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';

import '../../constants.dart';
import '../../size_config.dart';

class BranchJoinScreen extends StatefulWidget {
  const BranchJoinScreen({Key key}) : super(key: key);

  static String routeName = 'branch_join_screen';

  @override
  State<BranchJoinScreen> createState() => _BranchJoinScreenState();
}

class _BranchJoinScreenState extends State<BranchJoinScreen> {

  TextEditingController branchCodeController = TextEditingController();

  TextEditingController controllerBranchName = TextEditingController();


  StreamController<ErrorAnimationType> errorController;
  final formKey = GlobalKey<FormState>();

  bool hasError = false;
  String currentPassword;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Container(
          color: kPrimaryColor,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              title: Text('Unisciti ad una attività',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(19),
                  color: kCustomGreen,
                ),
              ),
              backgroundColor: kPrimaryColor,
            ),
            body: Container(
              height: getProportionateScreenHeight(5000),
              color: kPrimaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(38.0),
                        child: Center(child: Text('Aggiungi attività tramite codice', style: TextStyle(color: kCustomWhite),)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              PinCodeTextField(
                                appContext: context,
                                length: 8,
                                blinkWhenObscuring: true,
                                animationType: AnimationType.fade,
                                textStyle: const TextStyle(color: Colors.black),
                                pinTheme: PinTheme(
                                  inactiveColor: kPrimaryColor,
                                  selectedColor: kPinaColor,
                                  activeColor: Colors.white,
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(4),
                                  fieldHeight: getProportionateScreenHeight(40),
                                  fieldWidth: getProportionateScreenHeight(40),
                                  activeFillColor:
                                  hasError ? Colors.blue.shade100 : Colors.white,
                                ),
                                cursorColor: Colors.black,
                                animationDuration: const Duration(milliseconds: 300),
                                errorAnimationController: errorController,
                                controller: branchCodeController,
                                keyboardType: TextInputType.number,
                                boxShadows: const [
                                  BoxShadow(
                                    offset: Offset(0, 0),
                                    color: Colors.white,
                                    blurRadius: 1,
                                  )
                                ],
                                onCompleted: (code) async {

                                  formKey.currentState.validate();

                                  Widget cancelButton = TextButton(
                                    child: const Text("Indietro", style: TextStyle(color: kPrimaryColor),),
                                    onPressed:  () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                  List<BranchModel> retrieveBranchByBranchId;
                                  try{
                                    int currentBranchCodeToJoinInt = int.parse(code);
                                    double divider = currentBranchCodeToJoinInt / 169;
                                    String codeBranch = divider.toString().replaceAll('.0', '');
                                    codeBranch = codeBranch.replaceAll('.00', '00');

                                    retrieveBranchByBranchId = await dataBundleNotifier.getclientServiceInstance().retrieveBranchByBranchId(codeBranch);

                                    if(retrieveBranchByBranchId.length == 0){

                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog (
                                            actions: [
                                              ButtonBar(
                                                alignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  cancelButton,
                                                ],
                                              ),
                                            ],
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
                                                  height: getProportionateScreenHeight(400),
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
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text('  Ops..',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontSize: getProportionateScreenWidth(15),
                                                                    fontWeight: FontWeight.bold,
                                                                    color: kCustomWhite,
                                                                  )),
                                                              IconButton(icon: const Icon(
                                                                Icons.clear,
                                                                color: kCustomWhite,
                                                              ), onPressed: () { Navigator.pop(context); },),

                                                            ],
                                                          ),
                                                        ),
                                                        const Text(''),
                                                        const Center(
                                                          child: Text('Sembra che non esista nessuna attività corrispondente al codice inserito. ', textAlign: TextAlign.center,),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: SizedBox(
                                                            width: getProportionateScreenWidth(400),
                                                            height: getProportionateScreenWidth(40),
                                                            child: Card(
                                                              child: Center(child: Text(code,
                                                                style: TextStyle(color: Colors.red, fontSize: getProportionateScreenWidth(20), fontWeight: FontWeight.bold),)),
                                                            ),
                                                          ),
                                                        ),
                                                        const Center(
                                                          child: Text('Controlla la validità del condice con chi te l\'ha fornito, se riscontri ancora problemi contatta il supporto tecnico comunicando il codice non funzionante. Grazie.', textAlign: TextAlign.center,),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            launch('https://api.whatsapp.com/send/?phone=+393454937047&text=Ciao, ho avuto dei problemi in fase di creazione/associazione attività con il seguente codice [$code]. '
                                                                'Mi daresti una mano a risolvere il problema? Grazie mille. ${dataBundleNotifier.userDetailsList[0].firstName}');
                                                          },
                                                          child: Card(
                                                            elevation: 6,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  SvgPicture.asset(
                                                                    'assets/icons/ws.svg',
                                                                    height: 40,
                                                                    width: 30,
                                                                  ),
                                                                  const Text('Contatta il supporto'),
                                                                  SizedBox(width: getProportionateScreenWidth(30),),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                      );
                                    }
                                    else if(retrieveBranchByBranchId.length > 1){
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog (
                                            actions: [
                                              ButtonBar(
                                                alignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  cancelButton,
                                                ],
                                              ),
                                            ],
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
                                                  height: getProportionateScreenHeight(400),
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
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text('  Ops..',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontSize: getProportionateScreenWidth(15),
                                                                    fontWeight: FontWeight.bold,
                                                                    color: kCustomWhite,
                                                                  )),
                                                              IconButton(icon: const Icon(
                                                                Icons.clear,
                                                                color: kCustomWhite,
                                                              ), onPressed: () { Navigator.pop(context); },),

                                                            ],
                                                          ),
                                                        ),
                                                        const Text(''),
                                                        const Center(
                                                          child: Text('Sembra che non esista nessuna attività corrispondente al codice inserito. ', textAlign: TextAlign.center,),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: SizedBox(
                                                            width: getProportionateScreenWidth(400),
                                                            height: getProportionateScreenWidth(40),
                                                            child: Card(
                                                              child: Center(child: Text(code,
                                                                style: TextStyle(color: Colors.red, fontSize: getProportionateScreenWidth(20), fontWeight: FontWeight.bold),)),
                                                            ),
                                                          ),
                                                        ),
                                                        const Center(
                                                          child: Text('Controlla la validità del condice con chi te l\'ha fornito, se riscontri ancora problemi contatta il supporto tecnico comunicando il codice non funzionante. Grazie.', textAlign: TextAlign.center,),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            launch('https://api.whatsapp.com/send/?phone=+393454937047&text=Ciao, ho avuto dei problemi in fase di creazione/associazione attività con il seguente codice [$code]. '
                                                                'Mi daresti una mano a risolvere il problema? Grazie mille. ${dataBundleNotifier.userDetailsList[0].firstName}');
                                                          },
                                                          child: Card(
                                                            elevation: 6,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  SvgPicture.asset(
                                                                    'assets/icons/ws.svg',
                                                                    height: 40,
                                                                    width: 30,
                                                                  ),
                                                                  const Text('Contatta il supporto'),
                                                                  SizedBox(width: getProportionateScreenWidth(30),),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                      );
                                    }else if(retrieveBranchByBranchId.length == 1){

                                      Widget continueButton = TextButton(
                                        child: const Text("Unisciti", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                        onPressed:  () async {
                                          Response response = await dataBundleNotifier.getclientServiceInstance().createUserBranchRelation(
                                            accessPrivilege: Privileges.EMPLOYEE,
                                            fkBranchId: retrieveBranchByBranchId[0].pkBranchId,
                                            fkUserId: dataBundleNotifier.userDetailsList[0].id,
                                              actionModel: ActionModel(
                                                  date: DateTime.now().millisecondsSinceEpoch,
                                                  description: 'Si è collegato all\'attività ${retrieveBranchByBranchId[0].companyName} tramite il codice $currentPassword.',
                                                  type: ActionType.BRANCH_JOIN,
                                                  fkBranchId: retrieveBranchByBranchId[0].pkBranchId,
                                                  user: dataBundleNotifier.retrieveNameLastNameCurrentUser()
                                              )
                                          );
                                          if(response == null){
                                            showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog (
                                                  actions: [
                                                    ButtonBar(
                                                      alignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        cancelButton,
                                                      ],
                                                    ),
                                                  ],
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
                                                        height: getProportionateScreenHeight(400),
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
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text('  Ops..',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                          fontSize: getProportionateScreenWidth(15),
                                                                          fontWeight: FontWeight.bold,
                                                                          color: kCustomWhite,
                                                                        )),
                                                                    IconButton(icon: const Icon(
                                                                      Icons.clear,
                                                                      color: kCustomWhite,
                                                                    ), onPressed: () { Navigator.pop(context); },),

                                                                  ],
                                                                ),
                                                              ),
                                                              const Text(''),
                                                              Center(
                                                                child: Text('Ho riscontrato problemi nell\'aggiungere ' + retrieveBranchByBranchId[0].companyName + ' alla tua lista. Attendi 2 minuti e riprova.', textAlign: TextAlign.center,),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                            );
                                          }else{

                                            List<BranchModel> _branchList = await dataBundleNotifier.getclientServiceInstance().retrieveBranchesByUserId(dataBundleNotifier.userDetailsList[0].id);
                                            dataBundleNotifier.addBranches(_branchList);

                                            List<CashRegisterModel> currentListCashRegister = [];
                                            List<RecessedModel> _recessedModelList = [];

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

                                            if(dataBundleNotifier.currentBranch != null){
                                              List<SupplierModel> _suppliersModelList = await dataBundleNotifier.getclientServiceInstance().retrieveSuppliersListByBranch(dataBundleNotifier.currentBranch);
                                              dataBundleNotifier.addCurrentSuppliersList(_suppliersModelList);
                                            }
                                            if(dataBundleNotifier.currentBranch != null){
                                              List<StorageModel> _storageModelList = await dataBundleNotifier.getclientServiceInstance().retrieveStorageListByBranch(dataBundleNotifier.currentBranch);
                                              dataBundleNotifier.addCurrentStorageList(_storageModelList);
                                            }

                                            if(dataBundleNotifier.currentBranch != null){
                                              List<OrderModel> _orderModelList = await dataBundleNotifier.getclientServiceInstance().retrieveOrdersByBranch(dataBundleNotifier.currentBranch);
                                              dataBundleNotifier.addCurrentOrdersList(_orderModelList);

                                            }

                                            dataBundleNotifier.initializeCurrentDateTimeRange3Months();

                                            Navigator.pushNamed(context, HomeScreen.routeName);
                                          }
                                        },
                                      );
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog (
                                            actions: [
                                              ButtonBar(
                                                alignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  cancelButton,
                                                  continueButton,
                                                ],
                                              ),
                                            ],
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
                                                  height: getProportionateScreenHeight(400),
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
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text('  Abbiamo quasi finito..',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontSize: getProportionateScreenWidth(15),
                                                                    fontWeight: FontWeight.bold,
                                                                    color: kCustomWhite,
                                                                  )),
                                                              IconButton(icon: const Icon(
                                                                Icons.clear,
                                                                color: kCustomWhite,
                                                              ), onPressed: () { Navigator.pop(context); },),

                                                            ],
                                                          ),
                                                        ),
                                                        const Text(''),
                                                        Center(
                                                          child: Text('Stai per aggiungere alla tua lista di attività', textAlign: TextAlign.center,),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: SizedBox(
                                                            width: getProportionateScreenWidth(400),
                                                            height: getProportionateScreenWidth(40),
                                                            child: Card(
                                                              child: Center(child: Text(retrieveBranchByBranchId[0].companyName,
                                                                style: TextStyle(color: Colors.green, fontSize: getProportionateScreenWidth(20), fontWeight: FontWeight.bold),)),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Center(
                                                            child: Text('Una volta associata ti verrà assegnato il ruolo di DIPENDENTE. \n'
                                                                'Nel caso avessi la necessità di modificare i permessi assegnati contatta l\'amministratore', textAlign: TextAlign.center,),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                      );
                                    }
                                  }catch(e){
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog (
                                          actions: [
                                            ButtonBar(
                                              alignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                cancelButton,
                                              ],
                                            ),
                                          ],
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
                                                height: getProportionateScreenHeight(400),
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
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text('  Ops..',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: getProportionateScreenWidth(15),
                                                                  fontWeight: FontWeight.bold,
                                                                  color: kCustomWhite,
                                                                )),
                                                            IconButton(icon: const Icon(
                                                              Icons.clear,
                                                              color: kCustomWhite,
                                                            ), onPressed: () { Navigator.pop(context); },),

                                                          ],
                                                        ),
                                                      ),
                                                      const Text(''),
                                                      const Center(
                                                        child: Text('Sembra che non esista nessuna attività corrispondente al codice inserito. ', textAlign: TextAlign.center,),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: SizedBox(
                                                          width: getProportionateScreenWidth(400),
                                                          height: getProportionateScreenWidth(40),
                                                          child: Card(
                                                            child: Center(child: Text(code,
                                                              style: TextStyle(color: Colors.red, fontSize: getProportionateScreenWidth(20), fontWeight: FontWeight.bold),)),
                                                          ),
                                                        ),
                                                      ),
                                                      const Center(
                                                        child: Text('Controlla la validità del condice con chi te l\'ha fornito, se riscontri ancora problemi contatta il supporto tecnico comunicando il codice non funzionante. Grazie.', textAlign: TextAlign.center,),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          launch('https://api.whatsapp.com/send/?phone=+393454937047&text=Ciao, ho avuto dei problemi in fase di creazione/associazione attività con il seguente codice [$code]. '
                                                              'Mi daresti una mano a risolvere il problema? Grazie mille. ${dataBundleNotifier.userDetailsList[0].firstName}');
                                                        },
                                                        child: Card(
                                                          elevation: 6,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                SvgPicture.asset(
                                                                  'assets/icons/ws.svg',
                                                                  height: 40,
                                                                  width: 30,
                                                                ),
                                                                const Text('Contatta il supporto'),
                                                                SizedBox(width: getProportionateScreenWidth(30),),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                    );
                                  }
                                  branchCodeController.clear();
                                },
                                onChanged: (value) {
                                  setState(() {
                                    currentPassword = value;
                                  });
                                },
                              ),
                              SizedBox(height: getProportionateScreenHeight(20),),
                              Divider(color: kBeigeColor, endIndent: 40, indent: 40,),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },

    );
  }
}
