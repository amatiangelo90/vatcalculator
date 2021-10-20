import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../constants.dart';
import '../../size_config.dart';

class DetailsRecessed extends StatelessWidget {
  const DetailsRecessed({Key key}) : super(key: key);

  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () { Navigator.of(context).pop(); },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),

            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: Text(
              "Dettaglio incassi",style: TextStyle(
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.bold,
              color: Colors.white,),
            ),
            elevation: 5,
            actions: const [
            ],
          ),
          body: const Text(''),
        );
      },
    );
  }
}
