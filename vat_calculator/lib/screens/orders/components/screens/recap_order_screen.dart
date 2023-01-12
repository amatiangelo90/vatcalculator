import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/size_config.dart';
import '../../../../constants.dart';
import '../../../../models/databundlenotifier.dart';
import '../../../home/main_page.dart';

class RecapOrderScreen extends StatefulWidget {
  const RecapOrderScreen({Key? key}) : super(key: key);

  static String routeName = 'recaporderscreen';

  @override
  State<RecapOrderScreen> createState() => _RecapOrderScreenState();
}

class _RecapOrderScreenState extends State<RecapOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, HomeScreenMain.routeName);
                },
                icon: Icon(Icons.arrow_back_ios, size: getProportionateScreenHeight(25)),
                color: kCustomGrey,
              ),
              title: Text('Ordini', style: TextStyle(fontSize: getProportionateScreenWidth(15), color: kCustomGrey)),
            ),
          );
        });
  }
}
