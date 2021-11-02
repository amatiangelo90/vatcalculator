import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';

import '../../constants.dart';
import '../../size_config.dart';

class ProfileEditiScreen extends StatelessWidget {
  const ProfileEditiScreen({Key key}) : super(key: key);

  static String routeName = 'profile_edit_screen';
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, HomeScreen.routeName),
                  }
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              centerTitle: true,
              title: Text(
                'Gestione Profilo',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(17),
                  color: kCustomWhite,
                ),
              ),
              backgroundColor: kPrimaryColor,
            ),
            body: Column(

            ),
          );
        }
    );
  }
}
