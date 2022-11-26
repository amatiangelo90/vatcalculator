import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';
import '../../client/vatservice/model/product_order_amount_model.dart';
import '../../client/vatservice/model/utils/order_state.dart';
import '../../components/light_colors.dart';
import '../event/component/event_card.dart';
import '../main_page.dart';
import '../orders/components/order_card.dart';

class WarningScreen extends StatelessWidget {
  const WarningScreen({Key? key}) : super(key: key);

  static String routeName = 'warning_screen';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(

            appBar: AppBar(
              elevation: 5,
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              bottom: TabBar(
                indicatorColor: kCustomBordeaux,
                indicatorWeight: 4,
                tabs: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Ordini', style: TextStyle(fontSize: getProportionateScreenHeight(18))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Eventi', style: TextStyle(fontSize: getProportionateScreenHeight(18))),
                  ),
                ],
              ),
              leading: IconButton(
                onPressed: () {
                  dataBundleNotifier.onItemTapped(0);
                  Navigator.pushNamed(context, HomeScreenMain.routeName);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              title: Text('Abbiamo qualcosa in sospeso..', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(17))),
            ),
            body: TabBarView(
              children: [
                FutureBuilder(
                  initialData: <Widget>[
                    Column(
                      children: const [
                        CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                        Center(child: Text('Caricamento dati..')),
                      ],
                    ),
                  ],
                  builder: (context, snapshot){
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: snapshot.data,
                      ),
                    );
                  },
                  future: retrieveOrdersNotCompleted(dataBundleNotifier),
                ),
                FutureBuilder(
                  initialData: <Widget>[
                    Column(
                      children: const [
                        CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                        Center(child: Text('Caricamento dati..')),
                      ],
                    ),
                  ],
                  builder: (context, snapshot){
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: snapshot.data,
                      ),
                    );
                  },
                  future: retrieveEventsNotClosed(dataBundleNotifier),
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  Future retrieveEventsNotClosed(DataBundleNotifier dataBundleNotifier) async {
    List<EventModel> eventsList = dataBundleNotifier.getEventsOlderThanTodayNotClosed();

    print(eventsList.toString());

    List<Widget> eventWidget = [
      SizedBox(
        width: getProportionateScreenWidth(500),
        child: Container(color: kCustomBordeaux, child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Center(child: Text('EVENTI DA CHIUDERE', style: TextStyle(fontSize: getProportionateScreenHeight(20), color: Colors.white),)),
        )),
      ),
    ];
    eventsList.forEach((eventModelItem) {
      eventWidget.add(EventCard(eventModel: eventModelItem, showArrow: false, showButton: true));
    });

    return eventWidget;
  }


  Future retrieveOrdersNotCompleted(DataBundleNotifier dataBundleNotifier) async {
    List<OrderModel> ordersList = dataBundleNotifier.getOrdersOlderThanTodayUnderWorking();

    List<Widget> orderListWidget = [
      SizedBox(
        width: getProportionateScreenWidth(500),

        child: Column(
          children: [
            Container(color: kCustomBordeaux, child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(child: Text('ORDINI DA COMPLETARE', style: TextStyle(fontSize: getProportionateScreenHeight(20), color: Colors.white),)),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: getProportionateScreenWidth(400),
                child: CupertinoButton(
                  color: LightColors.kPalePink,
                  onPressed: () async {
                    ordersList.forEach((order) async {
                      await dataBundleNotifier.getclientServiceInstance().updateOrderStatus(
                          orderModel: OrderModel(
                              pk_order_id: order.pk_order_id,
                              status: OrderState.RECEIVED_ARCHIVED,
                              paid: 'NO',
                              total: order.total,
                              delivery_date: dateFormat.format(DateTime.now()),
                              closedby: dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName, code: '', fk_user_id: 0, fk_supplier_id: 0, fk_storage_id: 0, fk_branch_id: 0, details: '', creation_date: ''
                          )
                      );
                    });
                    dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
                  },
                  child: Text('Segna tutti come completati', style: TextStyle(fontWeight: FontWeight.w500, fontSize: getProportionateScreenWidth(15))),
                ),
              ),
            )
          ],
        ),
      ),
    ];
    await Future.forEach(ordersList, (OrderModel orderItem) async {

      List<ProductOrderAmountModel> list = await dataBundleNotifier
          .getclientServiceInstance()
          .retrieveProductByOrderId(orderItem);

      orderListWidget.add(
        OrderCard(
          order: orderItem,
          showExpandedTile: true,
          orderIdProductList: list,
        ),
      );

    });

    return orderListWidget;
  }
}
