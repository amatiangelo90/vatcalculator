import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

class UnderWorkingOrderPage extends StatelessWidget {
  const UnderWorkingOrderPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child){
          return Container(
            child: Text(dataBundleNotifier.currentUnderWorkingOrdersList.length.toString()),
          );
        }
    );
  }
}
