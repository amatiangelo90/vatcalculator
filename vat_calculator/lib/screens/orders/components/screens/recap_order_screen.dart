import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/size_config.dart';
import 'package:vat_calculator/swagger/swagger.enums.swagger.dart';
import 'package:vat_calculator/swagger/swagger.models.swagger.dart';
import '../../../../constants.dart';
import '../../../../models/databundlenotifier.dart';
import '../../../home/main_page.dart';
import 'order_creation/order_create_screen.dart';
import 'order_creation/order_details_screen.dart';

class RecapOrderScreen extends StatefulWidget {
  const RecapOrderScreen({Key? key}) : super(key: key);

  static String routeName = 'recaporderscreen';

  @override
  State<RecapOrderScreen> createState() => _RecapOrderScreenState();
}

class _RecapOrderScreenState extends State<RecapOrderScreen> {

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    final String monthName = getMonthName(now.month);
    final String nextMonthName = getMonthName(now.month + 1);
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              heroTag: "btlola123123",
              backgroundColor: kCustomGreen,
              onPressed: (){
                Navigator.pushNamed(context, CreateOrderScreen.routeName);
              },
              child: Icon(Icons.add, size: getProportionateScreenHeight(30), color: Colors.white),
            ),
            appBar: AppBar(
              leading: IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, HomeScreenMain.routeName);
                },
                icon: Icon(Icons.arrow_back_ios, size: getProportionateScreenHeight(25)),
                color: kCustomGrey,
              ),
              title: Text('Ordini', style: TextStyle(fontSize: getProportionateScreenWidth(15), color: kCustomGrey)),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Text(getFormtDateToReadeableItalianDate(dateFormat.format(now)), style: TextStyle(fontSize: 7),),
                  buildImageContainerByMonth('assets/imagescalendar/${monthName}.png', monthName),
                  Column(
                    children: buildOrdersListWidgetByMonth(now, context, dataBundleNotifier),
                  ),
                ],
              ),
            ),
          );
        });
  }

  buildOrdersListWidgetByMonth(DateTime nowDate, BuildContext context, DataBundleNotifier dataBundleNotifier) {

    DateTime now = nowDate.subtract(Duration(days: 1));

    DateTimeRange range = DateTimeRange(start: now,
        end: DateTime(now.year, now.month + 1, 0));

    List<Widget> list = [];


    for (int i = 0; i <= range.end.difference(range.start).inDays+1; i++) {
      list.add(Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: range.start.add(Duration(days: i)) == now.add(Duration(days: 1)) ? kCustomGreen : kCustomGrey,
                      width: 2.0,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: getProportionateScreenHeight(90),
                  child: CircleAvatar(
                    backgroundColor: range.start.add(Duration(days: i)) == now.add(Duration(days: 1)) ? kCustomGreen : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(getDayFromWeekDay(range.start.add(Duration(days: i)).weekday!) , style: TextStyle(color: range.start.add(Duration(days: i)) == now.add(Duration(days: 1)) ? Colors.white : kCustomGrey,fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(10))),
                        Text(range.start.add(Duration(days: i)).day.toString()!, style: TextStyle(color: range.start.add(Duration(days: i)) == now.add(Duration(days: 1)) ? Colors.white : kCustomGrey, fontSize: getProportionateScreenHeight(22))),
                      ],
                    ),
                  )
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Column(
                children: buildOrdersListForCurrentDate(dataBundleNotifier.getCurrentBranch().orders!
                    .where((element) => element.deliveryDate == dateFormat.format(now.add(Duration(days: i)))),
                    context, dataBundleNotifier),
              ),
            ),
          ),
        ],
      ));
    }

    return list;
  }


  buildOrdersListForCurrentDate(Iterable<OrderEntity> orders, BuildContext context, DataBundleNotifier dataBundleNotifier) {
    List<Widget> list = [];
    for (var order in orders) {
      list.add(Padding(
        padding: const EdgeInsets.only(right: 5),
        child: SizedBox(
            width: getProportionateScreenWidth(600),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              shadowColor: kCustomGreen,
              elevation: 5,
              child: ListTile(
                onTap: (){
                  Navigator.pushNamed(context, OrderDetailsScreen.routeName);
                },
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dataBundleNotifier.getSupplierNameById(order.supplierId!), style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(25), color: kCustomGrey)),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Location point.svg',
                            color: kCustomGrey,
                            width: getProportionateScreenHeight(11),
                          ),
                          Text(' ' + dataBundleNotifier.getCurrentBranch().address! + ', ' + dataBundleNotifier.getCurrentBranch().city! , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(14), color: kCustomGrey)),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/calendar.svg',
                            color: kCustomGrey,
                            width: getProportionateScreenHeight(11),
                          ),
                          Text(' ' + getFormtDateToReadeableItalianDate(order.deliveryDate!) , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(14), color: kCustomGrey)),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/box.svg',
                            color: kCustomGrey,
                            width: getProportionateScreenHeight(11),
                          ),
                          Text(' Prodotti: ' + order.products!.length!.toString() , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(14), color: kCustomGrey)),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            getIconByOrderStatus(order.orderStatus!),
                            color: getColorByOrderStatus(order.orderStatus!),
                            width: getProportionateScreenHeight(16),
                          ),
                          Row(
                            children: [
                              Text(' Stato: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(13), color: kCustomGrey)),
                              Text(orderEntityOrderStatusToJson(order.orderStatus).toString() , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(16), color: getColorByOrderStatus(order.orderStatus!))),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      Text('Creato da ' + order.senderUser! , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(10), color: Colors.grey)),
                      Text('Ordine creato ' + getFormtDateToReadeableItalianDate(order.creationDate!) , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(6), color: Colors.grey)),
                      Text(order.code! , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(6), color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            )),
      ));
    }
    if(list.isEmpty){
      list.add(Text('Non ci sono ordini per la data corrente', style: TextStyle(color: Colors.grey, fontSize: getProportionateScreenHeight(10))));
    }
    return list;
  }

  buildImageContainerByMonth(String monthImage, String month) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [

          Container(
            height: getProportionateScreenHeight(150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage(monthImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Text(month, style: TextStyle(fontSize: getProportionateScreenHeight(30), color: Colors.black),),
          ),
        ],
      ),
    );
  }

  Color getColorByOrderStatus(OrderEntityOrderStatus orderStatus) {
    switch(orderStatus){
      case OrderEntityOrderStatus.nonInviato:
        return kCustomBordeaux;
      case OrderEntityOrderStatus.inviato:
        return kCustomGreen;
      default:
        return kCustomGrey;
    }
  }

  String getIconByOrderStatus(OrderEntityOrderStatus orderEntityOrderStatus) {
    switch(orderEntityOrderStatus){
      case OrderEntityOrderStatus.nonInviato:
        return 'assets/icons/Error.svg';
      case OrderEntityOrderStatus.inviato:
        return 'assets/icons/success-green.svg';
      default:
        return 'assets/icons/Error.svg';
    }
  }
}
