import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

class ArchiviedOrderPage extends StatelessWidget {
  const ArchiviedOrderPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child){
         return Container(
           child: Text(dataBundleNotifier.currentArchiviedWorkingOrdersList.length.toString()),
         );
        }
    );
  }
}
