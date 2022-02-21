import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'components/expence_body.dart';

class ExpenceScreen extends StatefulWidget {
  const ExpenceScreen({Key key}) : super(key: key);


  static String routeName = "/expencescreen";

  @override
  _ExpenceScreenState createState() => _ExpenceScreenState();
}

class _ExpenceScreenState extends State<ExpenceScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, HomeScreen.routeName),
                  }),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        'Area Gestione Spese',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(17),
                          color: kCustomYellow800,
                        ),
                      ),
                      Text(
                        dataBundleNotifier.currentBranch.companyName,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(11),
                          color: kCustomWhite,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.white,), onPressed: () {  },
                ),
              ],
              elevation: 2,
            ),
            body: const ExpenceBodyWidget(),
          );
        });
  }
}
