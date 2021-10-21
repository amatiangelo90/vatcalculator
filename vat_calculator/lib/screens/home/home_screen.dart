import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {

  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Scaffold(
          drawer: const CommonDrawer(),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: Text(
              "Ciao ${dataBundleNotifier.dataBundleList.isNotEmpty ? dataBundleNotifier.dataBundleList[0].firstName : ''}",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(17),
                color: kCustomWhite,
              ),
            ),

            elevation: 0,
          ),
          body: const Body(),
          bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.home),
        );
      },
    );
  }
}