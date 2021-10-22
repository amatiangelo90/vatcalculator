import 'package:flutter/material.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';

class StorageScreen extends StatelessWidget {
  static String routeName = "/storagescreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CommonDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text('Magazzino',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(17),
            color: kCustomWhite,
          ),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: const Text('Storage'
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.storage),
    );
  }
}
