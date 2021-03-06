import 'dart:async';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/screens/event/component/event_card.dart';
import 'package:vat_calculator/screens/event/component/event_create_screen.dart';
import 'package:vat_calculator/screens/orders/components/order_card.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/actions_manager/action_screen.dart';
import 'package:vat_calculator/screens/branch_registration/branch_choice_registration.dart';
import 'package:vat_calculator/screens/expence_manager/components/expence_reg_card.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/order_create_screen.dart';
import '../../../components/light_colors.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../branch_registration/branch_update.dart';
import '../../event/event_home.dart';
import '../../recessed_manager/components/recessed_reg_card.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({Key key}) : super(key: key);

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {

  int currentOrderIndex = 0;
  int currentEventIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        if (dataBundleNotifier.userDetailsList.isEmpty ||
            dataBundleNotifier.userDetailsList[0].companyList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sembra che tu non abbia configurato ancora nessuna attivit??. ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * 0.6,
                  child: CreateBranchButton(),
                ),
              ],
            ),
          );
        } else {
          return RefreshIndicator(
            color: kPrimaryColor,
            onRefresh: () {
              dataBundleNotifier
                  .setCurrentBranch(dataBundleNotifier.currentBranch);
              setState(() {});
              return Future.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: getProportionateScreenHeight(56),
                    child: buildGestureDetectorBranchSelector(
                        context, dataBundleNotifier),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            Text(
                              'Ordini in arrivo oggi: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getProportionateScreenWidth(12)),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(28),
                              width: dataBundleNotifier
                                          .currentListSuppliers.length >
                                      90
                                  ? getProportionateScreenWidth(35)
                                  : getProportionateScreenWidth(28),
                              child: Card(
                                color: kPrimaryColor,
                                child: Center(
                                  child: Text(
                                    retrieveTodayOrdersList(dataBundleNotifier
                                            .currentUnderWorkingOrdersList)
                                        .length
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        CupertinoButton(
                          onPressed: () {
                            dataBundleNotifier.onItemTapped(2);
                          },
                          child: Row(
                            children: [
                              Text(
                                'Dettaglio Ordini',
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
                      future: populateProductsListForTodayOrders(
                          dataBundleNotifier),
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            retrieveTodayOrderList(dataBundleNotifier.currentUnderWorkingOrdersList).isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: getProportionateScreenWidth(400),
                                      child: CupertinoButton(
                                        color: kPrimaryColor,
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              CreateOrderScreen.routeName);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(''),
                                            Text(
                                              'Effettua Ordine',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          17)),
                                            ),
                                            Stack(
                                              children: [
                                                IconButton(
                                                  icon: SvgPicture.asset(
                                                    'assets/icons/receipt.svg',
                                                    color: kCustomWhite,
                                                    width: 25,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pushNamed(context,
                                                        CreateOrderScreen.routeName);
                                                  },
                                                ),
                                                Positioned(
                                                  top: 26.0,
                                                  right: 9.0,
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
                                                          child: Icon(
                                                            Icons
                                                                .add_circle_outline,
                                                            size: 13,
                                                            color:
                                                                kCustomGreenAccent,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: snapshot.data,
                                  ),
                                ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    retrieveTodayOrdersList(dataBundleNotifier
                                            .currentUnderWorkingOrdersList)
                                        .length,
                                    (index) => buildDot(index: index),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            Text(
                              'Eventi in programma oggi: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getProportionateScreenWidth(12)),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(28),
                              width: dataBundleNotifier.retrieveEventsForCurrentDate(DateTime.now()).length >
                                  90
                                  ? getProportionateScreenWidth(35)
                                  : getProportionateScreenWidth(28),
                              child: Card(
                                color: kPrimaryColor,
                                child: Center(
                                  child: Text(
                                    dataBundleNotifier.retrieveEventsForCurrentDate(DateTime.now())
                                        .length
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        CupertinoButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, EventHomeScreen.routeName);
                          },
                          child: Row(
                            children: [
                              Text(
                                'Gestione Eventi',
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
                    ),
                  ),
                  dataBundleNotifier.retrieveEventsForCurrentDate(DateTime.now()).isEmpty ?
                  dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: const Text('Non hai eventi in programma oggi'),
                  ) : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: getProportionateScreenWidth(400),
                      child: CupertinoButton(
                        color: kPrimaryColor,
                        onPressed: () {
                          Navigator.pushNamed(context,
                              EventCreateScreen.routeName);
                        },
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(''),
                            Text(
                              'Crea Evento',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                  getProportionateScreenWidth(
                                      17)),
                            ),
                            Stack(
                              children: [
                                IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/icons/party.svg',
                                    color: kCustomWhite,
                                    width: 50,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context,
                                        EventCreateScreen.routeName);
                                  },
                                ),
                                Positioned(
                                  top: 26.0,
                                  right: 9.0,
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
                                          child: Icon(
                                            Icons
                                                .add_circle_outline,
                                            size: 13,
                                            color:
                                            kCustomGreenAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ) :
                  SizedBox(
                    height: getProportionateScreenHeight(240),
                    child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          currentEventIndex = value;
                        });
                      },
                      itemCount: dataBundleNotifier.retrieveEventsForCurrentDate(DateTime.now()).length,
                      itemBuilder: (context, index) =>
                          EventCard(
                            eventModel: dataBundleNotifier.retrieveEventsForCurrentDate(DateTime.now())[index],
                            showButton: true,
                            showArrow: false,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          dataBundleNotifier.retrieveEventsForCurrentDate(DateTime.now())
                              .length,
                              (index) => buildDotEvent(index: index),
                        ),
                      ),
                    ),
                  ),
                  // buildActionsList(dataBundleNotifier.currentBranchActionsList),
                  SizedBox(height: getProportionateScreenHeight(dataBundleNotifier.currentBranch.accessPrivilege == Privileges.EMPLOYEE ? 280 : 100),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Developed by A.A.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(9))),
                  ),
                  SizedBox(height: getProportionateScreenHeight(200),),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  GestureDetector buildGestureDetectorBranchSelector(
      BuildContext context, DataBundleNotifier dataBundleNotifier) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  height: getProportionateScreenHeight(550),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('        Seleziona attivit??', style: TextStyle(fontSize: getProportionateScreenHeight(20), color: kPrimaryColor, fontWeight: FontWeight.w900)),
                            IconButton(icon: Icon(Icons.clear, size: getProportionateScreenHeight(30)), color: kPrimaryColor, onPressed: (){
                              Navigator.of(context).pop();
                            },)
                          ],
                        ),
                      ),
                      Column(
                        children: buildListBranches(dataBundleNotifier),
                      ),

                      SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: kPrimaryColor,
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
                child: Text(
                  '' + dataBundleNotifier.currentBranch.companyName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: getProportionateScreenWidth(15),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? SizedBox(height: 0,) :
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                    child: IconButton(
                        icon: SvgPicture.asset('assets/icons/Settings.svg', color: Colors.white, height: getProportionateScreenHeight(27),),
                        onPressed: (){
                          Navigator.pushNamed(context, UpdateBranchScreen.routeName);
                        },
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: getProportionateScreenWidth(30),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildListBranches(DataBundleNotifier dataBundleNotifier) {
    List<Widget> branchWidgetList = [];
    branchWidgetList.add(
        Divider(color: Colors.grey, height: 10,)
    );
    dataBundleNotifier.userDetailsList[0].companyList.forEach((currentBranch) {
      branchWidgetList.add(
        ListTile(
          title: Text(currentBranch.companyName, style: TextStyle(color: dataBundleNotifier.currentBranch.pkBranchId ==
              currentBranch.pkBranchId ? LightColors.kPalePink : Colors.grey, fontSize: getProportionateScreenHeight(18), fontWeight: FontWeight.w800)),
          leading: dataBundleNotifier.currentBranch.pkBranchId ==
              currentBranch.pkBranchId ? Icon(FontAwesomeIcons.checkCircle, color: LightColors.kPalePink,) : SizedBox(height: 0),
          onTap: () async {
            if(dataBundleNotifier.currentBranch.pkBranchId ==
                currentBranch.pkBranchId){
              Navigator.pop(context);
            }else{
              context.loaderOverlay.show();
              Navigator.pop(context);
              await dataBundleNotifier.setCurrentBranch(currentBranch);
              context.loaderOverlay.hide();
            }
          },
        ),
      );
    });
    branchWidgetList.add(
      Divider(color: Colors.grey, height: 10,)
    );
    branchWidgetList.add(
      ListTile(
        leading: Icon(FontAwesomeIcons.plus, color: kPrimaryColor,),
        title: Text('Crea Nuova Attivit??', style: TextStyle(fontSize: getProportionateScreenHeight(20), fontWeight: FontWeight.w900)),
        onTap: (){
          Navigator.of(context).pop();
          Navigator.pushNamed(context, BranchChoiceCreationEnjoy.routeName);
        },
      )
    );
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
                SizedBox(
                  width: getProportionateScreenWidth(10),
                ),
                Text(
                  'Ultime Azioni',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenWidth(12)),
                ),
              ],
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.pushNamed(context, ActionsDetailsScreen.routeName);
              },
              child: Row(
                children: [
                  Text(
                    'Visualizza Tutte',
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
        ),
      ),
    ];

    rows.add(const Padding(
      padding: EdgeInsets.all(0.0),
      child: Divider(
        height: 1,
      ),
    ));

    currentBranchActionsList.forEach((action) {
      if (rows.length < 10) {
        rows.add(
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              children: [
                Row(
                  children: [
                    ActionType.getIconWidget(action.type) ??
                        const Text('ICONA'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            action.user,
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: getProportionateScreenWidth(15),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                              DateTime.fromMillisecondsSinceEpoch(action.date)
                                      .day
                                      .toString() +
                                  '/' +
                                  DateTime.fromMillisecondsSinceEpoch(action.date)
                                      .month
                                      .toString() +
                                  '/' +
                                  DateTime.fromMillisecondsSinceEpoch(
                                          action.date)
                                      .year
                                      .toString() +
                                  '  ' +
                                  DateTime.fromMillisecondsSinceEpoch(
                                          action.date)
                                      .hour
                                      .toString() +
                                  ':' +
                                  (DateTime.fromMillisecondsSinceEpoch(
                                                  action.date)
                                              .minute >
                                          9
                                      ? DateTime.fromMillisecondsSinceEpoch(
                                              action.date)
                                          .minute
                                          .toString()
                                      : '0' +
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  action.date)
                                              .minute
                                              .toString()),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(getProportionateScreenWidth(58),
                      0, getProportionateScreenWidth(10), 2),
                  child: Text(
                    action.description,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.visible,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  height: 1,
                  indent: getProportionateScreenWidth(58),
                ),
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

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: currentOrderIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentOrderIndex == index
            ? kPrimaryColor
            : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  AnimatedContainer buildDotEvent({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: currentEventIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentEventIndex == index
            ? kPrimaryColor
            : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Future<List<Widget>> populateProductsListForTodayOrders(
      DataBundleNotifier dataBundleNotifier) async {

    List<OrderCard> orderCardList = [];

    await Future.forEach(dataBundleNotifier.currentUnderWorkingOrdersList, (OrderModel orderModel) async {
      if (isToday(dateFormat.parse(orderModel.delivery_date))) {
        List<ProductOrderAmountModel> list = await dataBundleNotifier
            .getclientServiceInstance()
            .retrieveProductByOrderId(
          OrderModel(
            pk_order_id: orderModel.pk_order_id,
          ),
        );
        orderCardList.add(OrderCard(
          order: orderModel,
          showExpandedTile: false,
          orderIdProductList: list,
        ));
      }
    });

    return orderCardList;
  }

  String normalizeCalendarValue(int day) {
    if (day < 10) {
      return '0' + day.toString();
    } else {
      return day.toString();
    }
  }

  List<OrderModel> retrieveTodayOrdersList(List<OrderModel> currentUnderWorkingOrdersList) {

    List<OrderModel> toReturnTodayOrders = [];
    if(currentUnderWorkingOrdersList != null){
      currentUnderWorkingOrdersList.forEach((element) {
        if(element.delivery_date != null){
          if (isToday(dateFormat.parse(element.delivery_date))) {
            toReturnTodayOrders.add(element);
          }
        }
      });
    }


    return toReturnTodayOrders;
  }

  retrieveTodayOrderList(List<OrderModel> currentUnderWorkingOrdersList) {

    List<OrderModel> list = [];
    currentUnderWorkingOrdersList.forEach((element) async {
      if (isToday(dateFormat.parse(element.delivery_date))) {
        list.add(element);
      }
    });
    return list;
  }

}
