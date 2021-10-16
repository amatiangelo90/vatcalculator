import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../enums.dart';
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
              automaticallyImplyLeading: false,
              title: Text("Profilo " + (dataBundleNotifier.dataBundleList.isNotEmpty ? dataBundleNotifier.dataBundleList[0].firstName : ''), style: const TextStyle(fontSize: 15, color: Colors.black),),
            ),
            body: BodyProfile(),
            bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.profile),
          );
        }
        );
  }
}
