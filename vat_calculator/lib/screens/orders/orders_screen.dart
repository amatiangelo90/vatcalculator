import 'package:flutter/material.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/body_orders.dart';

class OrdersScreen extends StatelessWidget {
  static String routeName = "/ordersscreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: const OrdersScreenBody(
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.orders),
    );
  }
}
