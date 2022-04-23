import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/components/screens/draft_order_page.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import 'package:vat_calculator/size_config.dart';
import '../../../constants.dart';
import '../../main_page.dart';

class ComunicationUnloadStorageScreen extends StatelessWidget {
  const ComunicationUnloadStorageScreen({Key key, this.orderedMapBySuppliers})
      : super(key: key);

  final Map<int, List<StorageProductModel>> orderedMapBySuppliers;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
      return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            dataBundleNotifier.currentStorage.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: getProportionateScreenHeight(22),fontWeight: FontWeight.bold, color: kCustomWhite),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Divider(),
                Text(
                  'Scarico effettuato!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: getProportionateScreenHeight(15), color: Colors.green.withOpacity(0.6)),
                ),
                Divider(),
                buildProductList(orderedMapBySuppliers),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Nota: Per il presente scarico sono state create delle bozze di ordini da poter modificare o inviare al tuo fornitore',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getProportionateScreenHeight(10)),
                  ),
                ),
                SizedBox(height: 50,),
                SizedBox(
                  width: getProportionateScreenWidth(300),
                  child: CupertinoButton(
                    color: Colors.deepOrangeAccent.withOpacity(0.7),
                    child: Text('Vai a Bozze Ordini',),
                    onPressed: () {
                      dataBundleNotifier
                          .setCurrentBranch(dataBundleNotifier.currentBranch);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DraftOrderPage(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: getProportionateScreenWidth(300),
                  child: CupertinoButton(
                    color: kPinaColor,
                    child: Text('Torna al Magazzino'),
                    onPressed: () {
                      dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
                      Navigator.pushNamed(context, HomeScreenMain.routeName);
                      dataBundleNotifier.onItemTapped(1);
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
            Text('Fornitore',style: TextStyle(color: kCustomWhite),),
            Text('Prodotto',style: TextStyle(color: kCustomWhite)),
            Text('Quantità',style: TextStyle(color: kCustomWhite)),
          ]
      ),
    ];

    orderedMapBySuppliers.forEach((key, value) {

      value.forEach((element) {

        tableRow.add(TableRow(
            children: [
              Text(element.supplierName),
              Text(element.productName),
              Text(element.loadUnloadAmount.toString()),
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
