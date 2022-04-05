import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/expence_manager/components/expence_reg_card.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../main_page.dart';
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
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              backgroundColor: kCustomOrange,
              elevation: 5,
              onPressed: (){
                showDialog(context: context, builder: (_) => const AlertDialog(
                  backgroundColor: Colors.transparent,
                  actions: [
                    ExpenceCard(showTopNavigatorRow: false),
                  ],
                ));
              },
            ),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                  dataBundleNotifier.onItemTapped(0);
                  Navigator.pushNamed(context, HomeScreenMain.routeName);
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
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        dataBundleNotifier.currentBranch == null ? '' : dataBundleNotifier.currentBranch.companyName,
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

              ],
              elevation: 2,
            ),
            body: const ExpenceBodyWidget(),
          );
        });
  }
}
