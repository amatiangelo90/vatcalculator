import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';
import '../../../constants.dart';
import '../../main_page.dart';
import 'order_build_from_storage_widget.dart';

class OrderFromStorageComunicationPage extends StatelessWidget {
  const OrderFromStorageComunicationPage({Key? key,required this.orderedMapBySuppliers})
      : super(key: key);

  final Map<int, List<StorageProductModel>> orderedMapBySuppliers;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        bottomSheet: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: getProportionateScreenWidth(500),
            child: CupertinoButton(
              child:
              Text('Torna alla Home', style: TextStyle(
                  fontSize: getProportionateScreenHeight(20),
                  color: Colors.white,
                  fontWeight: FontWeight.w600
              ),),
              color: Colors.green,
              onPressed: () {
                dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
                dataBundleNotifier.onItemTapped(0);
                dataBundleNotifier.refreshExtraFieldsIntoDuplicatedProductList();

                Navigator.pushNamed(context, HomeScreenMain.routeName);
              },
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: getProportionateScreenHeight(20),),
          ),
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
                buildProductList(orderedMapBySuppliers, dataBundleNotifier),
              ],
            ),
          ),
        ),
      );
    });
  }


  buildProductList(Map<int, List<StorageProductModel>> orderedMapBySuppliers, DataBundleNotifier dataBundleNotifier) {

    List<Widget> widgets = [
    ];

    orderedMapBySuppliers.forEach((key, value) {
      widgets.add(OrderWidgetForStorage(supplierId: key, orderedMapBySuppliers: value));
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: widgets,
      ),
    );
  }


}
