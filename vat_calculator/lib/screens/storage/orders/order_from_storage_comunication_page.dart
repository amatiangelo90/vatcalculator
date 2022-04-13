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

class OrderFromStorageComunicationPage extends StatelessWidget {
  const OrderFromStorageComunicationPage({Key key, this.orderedMapBySuppliers})
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Nota: Effettuare l\'ordine direttamente dal magazzino significa creare, in base alla merce selezionata, tante bozze di ordini quanti sono i fornitori associati ai prodotti.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getProportionateScreenHeight(10), color: Colors.white),
                  ),
                ),
                Divider(),
                Text(
                  'Bozze Ordini Create!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: getProportionateScreenHeight(18), color: Colors.green),
                ),
                Divider(),
                buildProductList(orderedMapBySuppliers),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: getProportionateScreenWidth(400),
                    child: CupertinoButton(
                      color: kCustomOrange,
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
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: getProportionateScreenWidth(400),
                    child: CupertinoButton(
                      color: Colors.lightBlueAccent,
                      child: Text('Torna al Magazzino'),
                      onPressed: () {
                        dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
                        Navigator.pushNamed(context, HomeScreenMain.routeName);
                        dataBundleNotifier.onItemTapped(1);
                      },
                    ),
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
              Text(element.supplierName, style: TextStyle(color: Colors.white),),
              Text(element.productName, style: TextStyle(color: Colors.grey)),
              Text(element.extra.toString(), style: TextStyle(color: Colors.green)),
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
