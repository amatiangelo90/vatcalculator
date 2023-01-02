import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';

class JoinSupplierAlreadyRegisteredScreen extends StatefulWidget {
  JoinSupplierAlreadyRegisteredScreen({Key? key}) : super(key: key);

  static String routeName = 'joinfromsupplierlist';

  @override
  State<JoinSupplierAlreadyRegisteredScreen> createState() => _JoinSupplierAlreadyRegisteredScreenState();
}

class _JoinSupplierAlreadyRegisteredScreenState extends State<JoinSupplierAlreadyRegisteredScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            backgroundColor: kCustomWhite,
            bottomSheet: Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
            ),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, SuppliersScreen.routeName),
                  }
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kCustomGrey,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'Associa Fornitore',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(19),
                      color: kCustomWhite,
                    ),
                  ),
                ],
              ),
              elevation: 5,
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                ],
              ),
            ),
          );
        });
  }
}



