import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

class DraftOrderPage extends StatelessWidget {
  const DraftOrderPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child){
          return Container(
            child: Text(dataBundleNotifier.currentDraftOrdersList.length.toString()),
          );
        }
    );
  }
}
