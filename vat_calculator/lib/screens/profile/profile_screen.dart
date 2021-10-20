import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child){
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                dataBundleNotifier.dataBundleList.isNotEmpty ? "Profilo " + dataBundleNotifier.dataBundleList[0].firstName : '',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(20),
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            body: BodyProfile(),
            bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.profile),
          );
        }
        );
  }
}
