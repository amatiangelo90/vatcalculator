import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/components/body.dart';
import '../../../constants.dart';
import '../../../enums.dart';
import '../../../size_config.dart';
import 'components/body.dart';

class ArubaCalculatorScreen extends StatelessWidget {

  static String routeName = "/aruba";

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                dataBundleNotifier.onItemTapped(0);
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: kCustomWhite,
                size: getProportionateScreenHeight(20),
              ),
            ),
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: Text(
              "Iva Aruba",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            elevation: 5,
            automaticallyImplyLeading: false,
            actions: const [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: IconButton(icon: Icon(
                  Icons.calendar_today_outlined,
                  color: kCustomWhite,
                ),

                ),
              ),
            ],
          ),
          body: const VatArubaCalculatorBody(),
        );
      },
    );
  }
}
