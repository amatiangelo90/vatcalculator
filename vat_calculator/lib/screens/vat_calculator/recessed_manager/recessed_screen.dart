import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class RecessedManagerScreen extends StatelessWidget {
  const RecessedManagerScreen({Key key}) : super(key: key);

  static String routeName = 'recessed_manager';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, _){
        return Container(
          child: Scaffold(
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
              title: Text('Incassi'),
              elevation: 0,
            ),
          ),
        );
      }
    );
  }
}
