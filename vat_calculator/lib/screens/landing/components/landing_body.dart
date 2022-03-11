import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:vat_calculator/screens/home/home_screen.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class LandingBody extends StatelessWidget {
  final String email;
  const LandingBody({Key key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child){
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(backgroundColor: Colors.black,),
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
                      email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(100),),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SizedBox(
                    width: getProportionateScreenWidth(500),
                    child: CupertinoButton(
                      child: const Text('AVANTI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                      color: kCustomGreen,
                      onPressed: () async {
                        context.loaderOverlay.show();
                        ClientVatService clientService = dataBundleNotifier.getclientServiceInstance();
                        UserModel userModelRetrieved = await clientService.retrieveUserByEmail(email);
                        if(userModelRetrieved != null){
                          Response response = await clientService.checkSpecialUser(userModelRetrieved);
                          if(response != null && response.statusCode != null && response.statusCode == 200){
                            if(response.data){
                              print('Enable special user');
                              dataBundleNotifier.enableSpecialUser();
                            }
                          }
                        }
                        print('Privilege: ' + userModelRetrieved.privilege.toString());
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

                        dataBundleNotifier.initializeCurrentDateTimeRange3Months();

                        context.loaderOverlay.hide();

                        Navigator.pushNamed(context, HomeScreen.routeName);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
