import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'move_product_stock_widget.dart';

class ChoicedStorageStockComponent extends StatefulWidget {
  const ChoicedStorageStockComponent({Key? key}) : super(key: key);

  @override
  State<ChoicedStorageStockComponent> createState() => _ChoicedStorageStockComponentState();
}

class _ChoicedStorageStockComponentState extends State<ChoicedStorageStockComponent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return SizedBox(
          height: getProportionateScreenHeight(700),
          child: ListView.separated(
              itemCount: dataBundleNotifier.rStorageProdListToMoveProdBetweenStorages!.length,
              padding: EdgeInsets.only(bottom: getProportionateScreenHeight(70), left: 5, top: getProportionateScreenHeight(40), right: 5),
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){

                  },
                  enabled: dataBundleNotifier.rStorageProdListToMoveProdBetweenStorages![index].stock! > 0 ? true : false,
                  title: Text(dataBundleNotifier.rStorageProdListToMoveProdBetweenStorages![index].productName!, style: const TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(dataBundleNotifier.rStorageProdListToMoveProdBetweenStorages![index].stock!.toStringAsFixed(2).replaceAll('.00', '') + ' x ' + dataBundleNotifier.rStorageProdListToMoveProdBetweenStorages![index].unitMeasure!),
                );
              }
          ),
        );
      },
    );
  }
}
