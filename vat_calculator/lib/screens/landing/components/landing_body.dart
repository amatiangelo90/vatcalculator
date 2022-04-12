import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/cash_register_model.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/expence_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/user_model.dart';
import 'package:vat_calculator/models/databundle.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../main_page.dart';

class LandingBody extends StatefulWidget {
  final String email;
  const LandingBody({Key key, this.email}) : super(key: key);

  @override
  State<LandingBody> createState() => _LandingBodyState();
}

class _LandingBodyState extends State<LandingBody> {

  bool isButtonPressed = false;
  int _currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Scaffold(
          backgroundColor: kPrimaryColor,

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Center(
                  child: Image.asset(
                    "assets/logo/logo_home_white.png",
                    height: SizeConfig.screenHeight * 0.2,
                    width: 130,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    'Benvenuto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(110),),
              Text(kVersionApp, style: TextStyle(fontSize: getProportionateScreenHeight(12))),

              isButtonPressed ? Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: FAProgressBar(
                    size: 20,
                    progressColor: Colors.green,
                    backgroundColor: Colors.white,
                    currentValue: _currentValue,
                    displayText: '%',
                    ),
              ) : Padding(
                padding: EdgeInsets.all(Platform.isAndroid ? 10.0 : 30.0),
                child: SizedBox(
                  width: getProportionateScreenWidth(500),
                  child: CupertinoButton(
                    child: const Text('AVANTI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                    color: kCustomGreenAccent,
                    onPressed: () async {
                      setState(() {
                        isButtonPressed = true;
                      });


                      ClientVatService clientService = dataBundleNotifier.getclientServiceInstance();
                      UserModel userModelRetrieved = await clientService.retrieveUserByEmail(widget.email);
                      if(userModelRetrieved != null){
                        Response response = await clientService.checkSpecialUser(userModelRetrieved);
                        if(response != null && response.statusCode != null && response.statusCode == 200){
                          if(response.data){
                            print('Enable special user');
                            dataBundleNotifier.enableSpecialUser();
                          }
                        }
                      }
                      UserDetailsModel dataBundle = UserDetailsModel(
                          userModelRetrieved.id,
                          userModelRetrieved.mail,
                          '',
                          userModelRetrieved.name,
                          userModelRetrieved.lastName,
                          userModelRetrieved.phone,
                          userModelRetrieved.privilege,
                          []);

                      List<BranchModel> _branchList = await clientService.retrieveBranchesByUserId(userModelRetrieved.id);
                      dataBundleNotifier.addDataBundle(dataBundle);
                      dataBundleNotifier.addBranches(_branchList);
                      _currentValue = 100;
                      List<RecessedModel> _recessedModelList = [];
                      List<CashRegisterModel> _cashRegisterModelList = [];

                      if(dataBundleNotifier.currentBranch != null){
                        _cashRegisterModelList = await clientService.retrieveCashRegistersByBranchId(dataBundleNotifier.currentBranch);

                        if(_cashRegisterModelList.isNotEmpty){
                          await Future.forEach(_cashRegisterModelList,
                                  (CashRegisterModel cashRegisterModel) async {
                                List<RecessedModel> list = await clientService.retrieveRecessedListByCashRegister(cashRegisterModel);
                                _recessedModelList.addAll(list);
                              });
                        }

                        dataBundleNotifier.setCashRegisterList(_cashRegisterModelList);
                        dataBundleNotifier.addCurrentRecessedList(_recessedModelList);
                      }

                      List<ExpenceModel> _expenceModelList = [];

                      if(dataBundleNotifier.currentBranch != null){
                        _expenceModelList = await clientService.retrieveExpencesListByBranch(dataBundleNotifier.currentBranch);
                        dataBundleNotifier.addCurrentExpencesList(_expenceModelList);
                      }

                      if(dataBundleNotifier.currentBranch != null){
                        List<SupplierModel> _suppliersModelList = await clientService.retrieveSuppliersListByBranch(dataBundleNotifier.currentBranch);
                        dataBundleNotifier.addCurrentSuppliersList(_suppliersModelList);
                      }
                      if(dataBundleNotifier.currentBranch != null){
                        List<StorageModel> _storageModelList = await clientService.retrieveStorageListByBranch(dataBundleNotifier.currentBranch);
                        dataBundleNotifier.addCurrentStorageList(_storageModelList);
                      }

                      if(dataBundleNotifier.currentBranch != null){
                        List<OrderModel> _orderModelList = await clientService.retrieveOrdersByBranch(dataBundleNotifier.currentBranch);
                        dataBundleNotifier.addCurrentOrdersList(_orderModelList);
                      }

                      if(dataBundleNotifier.currentBranch != null){
                        List<EventModel> _eventModelList = await clientService.retrieveEventsListByBranchId(dataBundleNotifier.currentBranch);
                        dataBundleNotifier.addCurrentEventsList(_eventModelList);
                      }
                      if(dataBundleNotifier.currentBranch != null) {
                        List<String> tokenList = await clientService.retrieveTokenList(
                            dataBundleNotifier.currentBranch);
                        dataBundleNotifier.setCurrentBossTokenList(tokenList);

                      }
                      dataBundleNotifier.initializeCurrentDateTimeRange3Months();

                      Future.forEach(dataBundleNotifier.userDetailsList[0].companyList, (BranchModel branch) {
                        if(branch.token == null || branch.token == ''){
                          FirebaseMessaging.instance.getToken().then((value) {
                            branch.token = value;
                            dataBundleNotifier.getclientServiceInstance().updateFirebaseTokenForUserBranchRelation(branchId: branch.pkBranchId, userId: dataBundleNotifier.userDetailsList[0].id, token: value);
                          });
                        }
                        FirebaseMessaging.instance.subscribeToTopic('branch-${branch.pkBranchId.toString()}').then((value) => print('Subscription to topic [branch-${branch.pkBranchId.toString()}] done!!'));
                      });
                      _currentValue = 100;
                      setState(() {
                        isButtonPressed = false;
                      });
                      dataBundleNotifier.onItemTapped(0);
                      Navigator.pushNamed(context, HomeScreenMain.routeName);
                    },
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
