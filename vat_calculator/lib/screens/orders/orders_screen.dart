import 'package:flutter/material.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/body_orders.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = "/ordersscreen";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with TickerProviderStateMixin{

  TabController controller;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    final kPages = <Widget>[
      Center(child: Text('Bozze Ordini' + controller.index.toString())),
      Center(child: Text('Bozze Ordini' + controller.index.toString())),
    ];


    final kTab = <Tab>[
      const Tab(child: Text('Ordini')),
      const Tab(child: Text('Bozze Ordini')),
    ];

    return DefaultTabController(
      length: kTab.length,
      child: Scaffold(
        drawer: const CommonDrawer(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text('Ordini',
            style: TextStyle(
              fontSize: getProportionateScreenWidth(17),
              color: kCustomWhite,
            ),
          ),
          backgroundColor: kPrimaryColor,
          bottom: TabBar(
            controller: controller,
            tabs: kTab,
            indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 3.0, color: controller.index == 0 ? Colors.blueAccent : Colors.orange),
            ),
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: kPages,
        ),
        bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.orders),
      ),
    );
  }

  @override
  void initState() {
    controller = TabController(length:2, initialIndex: _currentIndex, vsync: this);
    controller.addListener(() {
      setState(() {
        _currentIndex = controller.index;
      });
    });
  }
}
