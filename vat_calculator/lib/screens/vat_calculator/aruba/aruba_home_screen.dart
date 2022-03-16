import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../main_page.dart';
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
                Navigator.pushNamed(context, HomeScreenMain.routeName);
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
