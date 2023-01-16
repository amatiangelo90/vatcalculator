import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/swagger/swagger.enums.swagger.dart';

import '../../constants.dart';
import '../../size_config.dart';
import '../../swagger/swagger.models.swagger.dart';
import '../home/main_page.dart';

class BranchJoinScreen extends StatefulWidget {
  const BranchJoinScreen({Key? key}) : super(key: key);

  static String routeName = 'branch_join_screen';

  @override
  State<BranchJoinScreen> createState() => _BranchJoinScreenState();
}

class _BranchJoinScreenState extends State<BranchJoinScreen> {

  TextEditingController branchCodeController = TextEditingController();

  TextEditingController controllerBranchName = TextEditingController();


  StreamController<ErrorAnimationType> errorController = StreamController();
  final formKey = GlobalKey<FormState>();

  bool hasError = false;
  late String currentPassword;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Container(
          color: kCustomGrey,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: kCustomGrey,
                ),
              ),
              centerTitle: true,
              title: Text('Unisciti ad una attività',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(19),
                  color: kCustomGrey,
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: Container(
              height: getProportionateScreenHeight(5000),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(38.0),
                        child: Center(child: Text('Aggiungi attività tramite codice', style: TextStyle(color: kCustomGrey),)),
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
                                  inactiveColor: kCustomGrey,
                                  selectedColor: kCustomGreen,
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

                                  if(dataBundleNotifier.getUserEntity().branchList!.where((element) => element.branchCode == code).isNotEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      backgroundColor: kCustomBordeaux,
                                      duration: const Duration(seconds: 3),
                                      content: Text('Il branch con codice ${code} è già associato al tuo profilo'),
                                    ));
                                    branchCodeController.clear();
                                  }else{
                                    formKey.currentState!.validate();

                                    Widget cancelButton = TextButton(
                                      child: const Text("Indietro", style: TextStyle(color: kCustomGrey),),
                                      onPressed:  () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                    try{
                                      Response response = await dataBundleNotifier.getSwaggerClient().apiV1AppBranchesRetrievebranchbycodeGet(branchcode: code);
                                      if(response.isSuccessful){

                                        Widget continueButton = TextButton(
                                          child: const Text("Unisciti", style: TextStyle(color: kCustomGreen, fontWeight: FontWeight.bold)),
                                          onPressed:  () async {

                                            Branch branch = response.body;

                                            print('Create branch relation with user. Branch id: ' + branch.branchId!.toInt().toString() + ' - User Id: ' + dataBundleNotifier.getUserEntity().userId!.toInt().toString() + ' - User priviledge: ' + branchUserPriviledgeToJson(BranchUserPriviledge.employee).toString());
                                            Response response1 = await dataBundleNotifier.getSwaggerClient().apiV1AppBranchesLinkbranchanduserGet(
                                                branchId: branch.branchId!.toInt(),
                                                userId: dataBundleNotifier.getUserEntity().userId!.toInt(),
                                                userPriviledge: branchUserPriviledgeToJson(BranchUserPriviledge.employee)
                                            );

                                            if(!response1.isSuccessful){
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
                                                                    color: kCustomGrey,
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
                                                                  child: Text('Ho riscontrato problemi nell\'aggiungere ' + branch.name! + ' alla tua lista. Attendi 2 minuti e riprova.', textAlign: TextAlign.center,),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                              );
                                            } else{

                                              Response responseBranch = await dataBundleNotifier.getSwaggerClient().apiV1AppBranchesRetrievebranchbyidGet(branchid: branch.branchId!.toInt());
                                              if(responseBranch.isSuccessful){
                                                Response response = await dataBundleNotifier.getSwaggerClient().apiV1AppUsersFindbyemailGet(email: dataBundleNotifier.getUserEntity().email);
                                                if(response.isSuccessful){
                                                  dataBundleNotifier.setUser(response.body);
                                                  Navigator.pushNamed(context, HomeScreenMain.routeName);
                                                }else{
                                                  print(response.error);
                                                  print(response.base.headers.toString());
                                                }
                                                Navigator.pushNamed(context, HomeScreenMain.routeName);
                                              }else{

                                              }

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
                                                              color: kCustomGrey,
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
                                                          const Center(
                                                            child: Text('Stai per aggiungere alla tua lista di attività', textAlign: TextAlign.center,),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: SizedBox(
                                                              width: getProportionateScreenWidth(400),
                                                              height: getProportionateScreenWidth(40),
                                                              child: Card(
                                                                child: Center(child: Text(response.body.name,
                                                                  style: TextStyle(color: kCustomGreen, fontSize: getProportionateScreenWidth(20), fontWeight: FontWeight.bold),)),
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding: EdgeInsets.all(8.0),
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
                                      } else {
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
                                                              color: kCustomGrey,
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
                                                                  'Mi daresti una mano a risolvere il problema? Grazie mille. ${dataBundleNotifier.getUserEntity().name!}');
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
                                                            color: kCustomGrey,
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
                                                                'Mi daresti una mano a risolvere il problema? Grazie mille. ${dataBundleNotifier.getUserEntity().name!}');
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
                                  }

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
