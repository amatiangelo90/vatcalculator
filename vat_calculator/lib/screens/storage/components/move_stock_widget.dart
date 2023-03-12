import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../size_config.dart';
import 'move_product_stock_widget.dart';

class MoveStockComponent extends StatefulWidget {
  const MoveStockComponent({Key? key}) : super(key: key);

  @override
  State<MoveStockComponent> createState() => _MoveStockComponentState();
}

class _MoveStockComponentState extends State<MoveStockComponent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return SizedBox(
          height: getProportionateScreenHeight(700),
          child: ListView.separated(
              itemCount: dataBundleNotifier.getCurrentStorage().products!.length,
              padding: EdgeInsets.only(bottom: getProportionateScreenHeight(70), left: 5, top: getProportionateScreenHeight(40), right: 5),
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){
                    dataBundleNotifier.setStockToMoveProd(dataBundleNotifier.getCurrentStorage().products![index].stock!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoveStockProductWidgetDetails(
                          index: index,
                        ),
                      ),
                    );
                  },
                  enabled: dataBundleNotifier.getCurrentStorage().products![index].stock! > 0 ? true : false,
                  title: Text(dataBundleNotifier.getCurrentStorage().products![index].productName!, style: const TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(dataBundleNotifier.getCurrentStorage().products![index].stock!.toStringAsFixed(2).replaceAll('.00', '') + ' x ' + dataBundleNotifier.getCurrentStorage().products![index].unitMeasure!),
                );
              }
          ),
        );
      },
    );
  }
}
