import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/components/body.dart';
import '../../../constants.dart';
import '../../../enums.dart';
import '../../../size_config.dart';

class FattureInCloudCalculatorScreen extends StatelessWidget {

  static String routeName = "/fattureincloud";

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kCustomWhite,
            centerTitle: true,
            title: Text(
              "Iva FattureInCloud",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: const VatFattureInCloudCalculatorBody(),
          bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.vatcalc),
        );
      },
    );
  }
}
