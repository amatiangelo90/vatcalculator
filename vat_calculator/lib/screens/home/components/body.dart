import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/components/chart_widget.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/actions_manager/action_screen.dart';
import 'package:vat_calculator/screens/orders/components/edit_order_underworking_screen.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/order_create_screen.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  Map<int, List<ProductOrderAmountModel>> orderIdProductListMap = {};

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        if (dataBundleNotifier.dataBundleList.isEmpty || dataBundleNotifier.dataBundleList[0].companyList.isEmpty) {
          return Padding(
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
                child: CreateBranchButton(),
              ),
            ],
          ),
        );
        } else {
          return RefreshIndicator(
            onRefresh: (){
              dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
              setState(() {
              });
              return Future.delayed(Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
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
                                builder: (_) => AlertDialog (
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
                                                          color: kCustomWhite,
                                                        ),),
                                                        IconButton(icon: const Icon(
                                                          Icons.clear,
                                                          color: kCustomWhite,
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
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: getProportionateScreenWidth(10),),
                          Text('Ordini in arrivo oggi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12)),),
                        ],
                      ),
                      CupertinoButton(
                        onPressed: (){
                          Navigator.pushNamed(context, OrdersScreen.routeName);
                        },
                        child: Row(
                          children: [
                            Text('Pagina Ordini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12), color: Colors.grey),),
                            Icon(Icons.arrow_forward_ios, size: getProportionateScreenWidth(15), color: Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                    initialData: <Widget>[
                      const Center(
                          child: CircularProgressIndicator(
                            color: kPinaColor,
                          )),
                      const SizedBox(),
                      Column(
                        children: const [
                          Center(
                            child: Text(
                              'Caricamento Ordini..',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: kPrimaryColor,
                                  fontFamily: 'LoraFont'),
                            ),
                          ),
                        ],
                      ),
                    ],
                    future: populateProductsListForTodayOrders(dataBundleNotifier),
                    builder: (context, snapshot){
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: buildOrderIncomingTodayListWidget(dataBundleNotifier),
                    ),
                  );
                }),
                dataBundleNotifier.currentBranch.providerFatture == '' ? Column(
                  children: [
                    Text(''),

                  ],
                ) :
                LineChartWidget(currentDateTimeRange: dataBundleNotifier.currentDateTimeRange),
                Divider(height: getProportionateScreenHeight(30),),
                buildActionsList(dataBundleNotifier.currentBranchActionsList),
                dataBundleNotifier.currentBranchActionsList.isEmpty ? SizedBox(height: 500,) : SizedBox(height: 0,),
              ],
            ),
        ),
          );
        }
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

                            return SizedBox(
                              width: getProportionateScreenWidth(800),
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
                                            fontSize: getProportionateScreenWidth(17),
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
                                    SizedBox(height: getProportionateScreenHeight(10),),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.blue.shade700.withOpacity(0.9),
                  elevation: 7,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                          child: Text('' + dataBundleNotifier.currentBranch.companyName,
                            style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(15)),),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: getProportionateScreenWidth(18),),
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
                    color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.blue.shade700.withOpacity(0.8) : Colors.white,
                    border: const Border(
                      bottom: BorderSide(width: 1.0, color: Colors.grey),
                    ),
                 ),
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.format_align_right_rounded, color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.white : kPrimaryColor,),
                    Icon(currentBranch.accessPrivilege == Privileges.EMPLOYEE ? Icons.person : Icons.vpn_key_outlined, color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.white : kPrimaryColor,),
                    Text('   ' + currentBranch.companyName,
                      style: TextStyle(
                      fontSize: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? getProportionateScreenWidth(16) : getProportionateScreenWidth(13),
                        color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.white : Colors.black,
                    ),),
                  ],
                ),
              ),
            ),
            onTap: () async {
              context.loaderOverlay.show();
              Navigator.pop(context);
              await dataBundleNotifier.setCurrentBranch(currentBranch);
              context.loaderOverlay.hide();

            },
        ),
      );
    });
    return branchWidgetList;
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
                  && dataBundleNotifier.currentDateTime.month == currentDate.month) ? Colors.grey : kCustomWhite,
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

  Widget buildActionsList(List<ActionModel> currentBranchActionsList) {

    List<Padding> rows = [
      Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: getProportionateScreenWidth(10),),
                Text('Ultime Azioni', style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12)),),
              ],
            ),
            CupertinoButton(
              onPressed: (){
                Navigator.pushNamed(context, ActionsDetailsScreen.routeName);
              },
              child: Row(
                children: [
                  Text('Visualizza Tutte', style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12), color: Colors.grey),),
                  Icon(Icons.arrow_forward_ios, size: getProportionateScreenWidth(15), color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    ];

    rows.add(const Padding(
      padding: EdgeInsets.all(0.0),
      child: Divider(height: 1,),
    ));

    currentBranchActionsList.forEach((action) {
      if(rows.length < 10){
        rows.add(
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              children: [
                Row(
                  children: [
                    ActionType.getIconWidget(action.type) ?? const Text('ICONA'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(action.user, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(15), fontWeight: FontWeight.bold),),
                          Text(
                              DateTime.fromMillisecondsSinceEpoch(action.date).day.toString() + '/' +
                                  DateTime.fromMillisecondsSinceEpoch(action.date).month.toString() + '/' +
                                  DateTime.fromMillisecondsSinceEpoch(action.date).year.toString() + '  ' +
                                  DateTime.fromMillisecondsSinceEpoch(action.date).hour.toString() + ':' +
                                  (DateTime.fromMillisecondsSinceEpoch(action.date).minute > 9
                                      ? DateTime.fromMillisecondsSinceEpoch(action.date).minute.toString()
                                      : '0' + DateTime.fromMillisecondsSinceEpoch(action.date).minute.toString())

                              , style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(getProportionateScreenWidth(58), 0, getProportionateScreenWidth(10), 2),
                  child: Text(action.description, textAlign: TextAlign.start, overflow: TextOverflow.visible, style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Divider(height: 1, indent: getProportionateScreenWidth(58),),
              ],
            ),
          ),
        );
      }
    });

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: rows,
      ),
    );
  }

  buildOrderIncomingTodayListWidget(DataBundleNotifier dataBundleNotifier) {

    List<Widget> ordersList = [];

    dataBundleNotifier.currentUnderWorkingOrdersList.forEach((order) {
      if(isToday(order.delivery_date)) {
        ordersList.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: getProportionateScreenWidth(350),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 10,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              OrderState.getIconWidget(OrderState.INCOMING),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(dataBundleNotifier.getSupplierName(order.fk_supplier_id),
                                style: TextStyle(fontSize: getProportionateScreenHeight(20), color: Colors.black54.withOpacity(0.6), fontWeight: FontWeight.bold),),
                              Text(
                                '       #' + order.code,
                                style: TextStyle(
                                    fontSize: getProportionateScreenHeight(12)),
                              ),
                            ],
                          ),
                          SizedBox(width: getProportionateScreenWidth(90)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Prodotti',
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(13), fontWeight: FontWeight.bold),
                            ),
                            Text(orderIdProductListMap[order.pk_order_id] == null ? '0' : orderIdProductListMap[order.pk_order_id].length.toString(),
                              style: TextStyle(
                                  color: kPinaColor,
                                  fontSize: getProportionateScreenHeight(17)),
                            ),
                          ],
                        ),
                        SizedBox(width: getProportionateScreenWidth(90)),
                        Column(
                          children: [
                            Text(
                              'Prezzo Stimato ',
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(13), fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '€ ' +
                                  calculatePriceFromProductList(
                                      orderIdProductListMap[
                                      order.pk_order_id]),
                              style: TextStyle(
                                  color: kPinaColor,
                                  fontSize: getProportionateScreenHeight(17)),
                            ),
                          ],
                        ),

                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(10),),
                    Container(
                      height: 50,
                      width: getProportionateScreenWidth(350),
                      child: CupertinoButton(
                        child: Text(
                          'Completa Ordine',
                          style: TextStyle(
                              fontSize: getProportionateScreenHeight(13)),
                        ),
                        pressedOpacity: 0.8,
                        color: Colors.green.shade700,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderCompletionScreen(orderModel: order,
                            productList: orderIdProductListMap[order.pk_order_id],),),);
                        },
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                        color: Colors.green.shade700,

                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });

    if(ordersList.isEmpty){
      ordersList.add(SizedBox(

          width: getProportionateScreenWidth(400),
          child: Card(
            child: Column(
              children: [
                Center(child: Text('Nessun ordine in arrivo per oggi', style: TextStyle(fontSize: getProportionateScreenWidth(16)),)),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: CupertinoButton(
                    color: Colors.deepOrangeAccent.shade700.withOpacity(0.6),
                    onPressed: (){
                      Navigator.pushNamed(context, CreateOrderScreen.routeName);
                    },
                    child: Text('Crea Ordine'),
                  ),
                ),
              ],
            ),
          ),
      ));
    }

    return ordersList;
  }
  bool isToday(int delivery_date) {
    DateTime currentDate = DateTime.fromMillisecondsSinceEpoch(delivery_date);
    DateTime now = DateTime.now();
    bool result = false;

    if(currentDate.day == now.day &&
        currentDate.month == now.month &&
          currentDate.year == now.year){
      result = true;
    }
    return result;
  }
  Future<List<Widget>> populateProductsListForTodayOrders(DataBundleNotifier dataBundleNotifier) async {

    dataBundleNotifier.currentUnderWorkingOrdersList.forEach((element) async {
      if(isToday(element.delivery_date)){
        List<ProductOrderAmountModel> list = await dataBundleNotifier.getclientServiceInstance().retrieveProductByOrderId(
          OrderModel(pk_order_id: element.pk_order_id,),
        );
        orderIdProductListMap[element.pk_order_id] = list;
      }
    });

    return [];
  }
  String calculatePriceFromProductList(List<ProductOrderAmountModel> orderIdProductListMap) {
    double total = 0.0;

    if(orderIdProductListMap != null && orderIdProductListMap.isNotEmpty){
      orderIdProductListMap.forEach((currentProduct) {
        total = total + (currentProduct.amount * currentProduct.prezzo_lordo);
      });
    }
    return total.toStringAsFixed(2);
  }
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
      });
    });

  }
}

