import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import 'package:vat_calculator/size_config.dart';
import '../../../constants.dart';

class ComunicationUnloadStorageScreen extends StatelessWidget {
  const ComunicationUnloadStorageScreen({Key key, this.orderedMapBySuppliers})
      : super(key: key);

  final Map<int, List<StorageProductModel>> orderedMapBySuppliers;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(''),
        ),
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Scarico effettuato per ${dataBundleNotifier.currentStorage.name}!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: getProportionateScreenHeight(20)),
                ),
                buildProductList(orderedMapBySuppliers),
                Text(
                  'Nota: Per il presente scarico sono state create delle bozze di ordini da poter modificare o inviare al tuo fornitore',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: getProportionateScreenHeight(10)),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: DefaultButton(
                    color: kCustomBlue,
                    text: 'Vai alla sezione Bozze Ordini',
                    press: () {
                      dataBundleNotifier
                          .setCurrentBranch(dataBundleNotifier.currentBranch);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrdersScreen(
                            initialIndex: 1,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: DefaultButton(
                    color: kCustomBlue,
                    text: 'Torna al Magazzino',
                    press: () {
                      dataBundleNotifier
                          .setCurrentBranch(dataBundleNotifier.currentBranch);
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  buildProductList(Map<int, List<StorageProductModel>> orderedMapBySuppliers) {

    Table outputTable = Table();


    List<TableRow> tableRow = [
      TableRow(
          children: [
            Text('Fornitore',style: TextStyle(color: kPrimaryColor),),
            Text('Prodotto',style: TextStyle(color: kPrimaryColor)),
            Text('Quantità',style: TextStyle(color: kPrimaryColor)),
          ]
      ),
    ];

    orderedMapBySuppliers.forEach((key, value) {

      value.forEach((element) {

        tableRow.add(TableRow(
            children: [
              Text(element.supplierName),
              Text(element.productName),
              Text(element.stock.toString()),
            ]
        ));

      });

    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        children: tableRow,
      ),
    );
  }
}
