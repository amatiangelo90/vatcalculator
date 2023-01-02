import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class AmountHundredScreen extends StatefulWidget {
  const AmountHundredScreen({Key? key}) : super(key: key);

  static String routeName = 'amount_hundred_screen_storage';

  @override
  _AmountHundredScreenState createState() => _AmountHundredScreenState();
}

class _AmountHundredScreenState extends State<AmountHundredScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios, color: kCustomGrey, size: getProportionateScreenHeight(20),),
              ),
              centerTitle: true,
              title: Text(dataBundleNotifier.getCurrentStorage().name!, style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenHeight(15)),),
            ),
            bottomSheet: Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
              child: DefaultButton(
                color: Colors.blueAccent,
                text: 'QuantitàX100',
                press: () async {
                }, textColor: kCustomGrey,
              ),
            ),

            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 80,),
                ],
              ),
            ),
          );
        }
    );
  }

}
