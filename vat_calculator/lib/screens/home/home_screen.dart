import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Container(
          child: const HomePageBody(),
        );
      },
    );
  }
}