import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
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
            leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: kCustomWhite,
                size: getProportionateScreenHeight(20),
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: Text(
              "Iva FattureInCloud",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(17),
                color: kCustomWhite,
              ),
            ),
            elevation: 0,
          ),
          body: const VatFattureInCloudCalculatorBody(),
        );
      },
    );
  }
}
