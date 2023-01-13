import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  static String routeName = 'order_details';
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotification, _){
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dettagli ordine'),
          ),
          body: Container(
            child: Column(
              children: [
                Card(
                  
                )
              ]
            )
          ),
        );
      },
    );
  }
}
