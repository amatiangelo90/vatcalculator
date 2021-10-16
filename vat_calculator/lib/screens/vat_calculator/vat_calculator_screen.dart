import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/body.dart';

class VatCalculatorScreen extends StatelessWidget {

  static String routeName = "/vatcalculator";

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: Text(
              "Iva",
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
                  color: Color(0xFFF5F6F9),
                ),

                ),
              ),
            ],
          ),
          body: const VatCalculatorBody(),
          bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.home),
        );
      },
    );
  }
}
