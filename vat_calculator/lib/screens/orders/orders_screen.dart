import 'package:flutter/material.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/body_orders.dart';

class OrdersScreen extends StatelessWidget {
  static String routeName = "/ordersscreen";

  final kPages = <Widget>[
    OrdersScreenBody(),
    const Center(child: Text('Bozze Ordini')),
  ];


  final kTab = <Tab>[
    const Tab(child: Text('Ordini')),
    const Tab(child: Text('Bozze Ordini')),
  ];

  @override
  Widget build(BuildContext context) {
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
            tabs: kTab,
            indicator: const UnderlineTabIndicator(borderSide: BorderSide(width: 3.0, color: kPinaColor),
            ),
          ),
        ),
        body: TabBarView(
          children: kPages,
        ),
        bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.orders),
      ),
    );
  }
}
