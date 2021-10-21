import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../constants.dart';
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
            drawer: Drawer(),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Text(
                dataBundleNotifier.dataBundleList.isNotEmpty ? "Profilo " + dataBundleNotifier.dataBundleList[0].firstName : '',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              elevation: 0,
            ),
            body: BodyProfile(),
          );
        }
        );
  }
}
