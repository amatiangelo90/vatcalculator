import 'package:flutter/material.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Ordini',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(20),
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        backgroundColor: kCustomWhite,
      ),
      body: const OrdersScreenBody(

      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.orders),
    );
  }
}
