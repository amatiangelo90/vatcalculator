import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/databundlenotifier.dart';

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

            ),
          );
        });
  }
}
