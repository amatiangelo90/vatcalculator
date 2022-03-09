import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/registration_provider/fatture_provider_registration.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/components/body.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'components/body_chart.dart';

class FattureInCloudCalculatorScreen extends StatelessWidget {

  DateTimeRange _currentDateTimeRange;
  static String routeName = "/fattureincloud";

  final kTab = <Tab>[
    const Tab(child: Text('Dettagli'),),
    Tab(child: SvgPicture.asset('assets/icons/linechart.svg', width: getProportionateScreenHeight(25),)),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return DefaultTabController(
          length: kTab.length,

          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: kTab,
                indicator: const UnderlineTabIndicator(borderSide: BorderSide(width: 2.0, color: Colors.white),
                ),
              ),
              actions: [
                IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Settings.svg",
                      color: Colors.white,
                      width: getProportionateScreenWidth(25),
                    ),
                    onPressed: () {
                      buildmethod(context, dataBundleNotifier);

                    }),
                IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/calendar.svg",
                      color: Colors.white,
                      width: getProportionateScreenWidth(25),
                    ),
                    onPressed: () {
                      _selectDateTimeRange(context, dataBundleNotifier);

                    }),
              ],
              leading: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomeScreen.routeName);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: kCustomWhite,
                  size: getProportionateScreenHeight(20),
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: GestureDetector(
                onTap: () {
                  buildmethod(context, dataBundleNotifier);
                },
                child: SizedBox(
                  width: getProportionateScreenWidth(170),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      color: dataBundleNotifier
                          .currentBranch.providerFatture ==
                          'fatture_in_cloud'
                          ? kPrimaryColor
                          : Colors.orange,
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Image.asset(
                          dataBundleNotifier.currentBranch
                              .providerFatture ==
                              'fatture_in_cloud'
                              ? 'assets/images/fattureincloud.png'
                              : 'assets/images/aruba.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),
              elevation: 0,
            ),
            body: TabBarView(
              children: [
                VatFattureInCloudCalculatorBody(),
                VatFattureInCloudCalculatorBodyChart(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> buildmethod(BuildContext context, DataBundleNotifier dataBundleNotifier) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
                child: SingleChildScrollView(
                  scrollDirection:
                  Axis.vertical,
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
                                  '  Dettagli Provider',
                                  style:
                                  TextStyle(
                                    fontSize:
                                    getProportionateScreenWidth(
                                        17),
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
                                  onPressed:
                                      () {
                                    Navigator.pop(
                                        context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: width - 90,
                            child: Card(
                              color:
                              kPrimaryColor,
                              semanticContainer:
                              true,
                              clipBehavior: Clip
                                  .antiAliasWithSaveLayer,
                              child:
                              Image.asset(
                                'assets/images/fattureincloud.png',
                                fit: BoxFit
                                    .contain,
                              ),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    10.0),
                              ),
                              elevation: 5,
                              margin:
                              const EdgeInsets
                                  .all(10),
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                  width: 22),
                              Text(
                                'ApiKey',
                                style:
                                TextStyle(
                                  color: Colors
                                      .grey,
                                  fontSize:
                                  getProportionateScreenWidth(
                                      14),
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                            ],
                          ),
                          Card(
                            child: Row(
                              children: [
                                SizedBox(width: getProportionateScreenHeight(20),),
                                Text(dataBundleNotifier
                                    .currentBranch
                                    .apiKeyOrUser, style: TextStyle(color: Colors.blue.shade500, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            elevation: 0,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                  width: 22),
                              Text(
                                dataBundleNotifier
                                    .currentBranch
                                    .providerFatture ==
                                    'fatture_in_cloud'
                                    ? 'ApiUid'
                                    : 'Password',
                                style:
                                TextStyle(
                                  color: Colors
                                      .grey,
                                  fontSize:
                                  getProportionateScreenWidth(
                                      14),
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                            ],
                          ),
                          Card(
                            child: Row(
                              children: [
                                SizedBox(width: getProportionateScreenHeight(20),),
                                Text(dataBundleNotifier
                                    .currentBranch
                                    .apiUidOrPassword, style: TextStyle(color: Colors.blue.shade500, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            elevation: 0,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(300),
                            child: CupertinoButton(
                              child: Text('Elimina Provider'),
                              color: Colors.redAccent,
                              onPressed: () async {
                                Response response = await dataBundleNotifier.getclientServiceInstance()
                                    .removeProviderFromBranch(
                                    branchModel: dataBundleNotifier.currentBranch,
                                    actionModel: ActionModel(
                                        date: DateTime.now().millisecondsSinceEpoch,
                                        description: 'Ha rimosso il provider per la fatturazione elettronica ${dataBundleNotifier.currentBranch.providerFatture} dall\'attività ${dataBundleNotifier.currentBranch.companyName}',
                                        fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                        user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                        type: ActionType.PROVIDER_DELETE
                                    )
                                );
                                if(response.data > 0){
                                  print('Provider Rimosso');
                                  dataBundleNotifier.removeProviderFromCurrentBranch();
                                }else{
                                  print('Errore rimozione provider');
                                }
                                Navigator.pushNamed(context, RegisterFattureProviderScreen.routeName);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
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
