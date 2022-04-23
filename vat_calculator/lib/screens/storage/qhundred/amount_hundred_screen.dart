import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class AmountHundredScreen extends StatefulWidget {
  const AmountHundredScreen({Key key}) : super(key: key);

  static String routeName = 'amount_hundred_screen_storage';

  @override
  _AmountHundredScreenState createState() => _AmountHundredScreenState();
}

class _AmountHundredScreenState extends State<AmountHundredScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor, size: getProportionateScreenHeight(20),),
              ),
              centerTitle: true,
              title: Text(dataBundleNotifier.currentStorage.name, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(15)),),
            ),
            bottomSheet: Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
              child: DefaultButton(
                color: Colors.blueAccent,
                text: 'QuantitàX100',
                press: () async {
                  int amountHundred = 0;
                  Map<int, List<StorageProductModel>> orderedMapBySuppliers = {};
                  dataBundleNotifier.currentStorageProductListForCurrentStorage.forEach((element) {


                    if(element.amountHundred != 0){
                      amountHundred = amountHundred + 1;
                      if(orderedMapBySuppliers.keys.contains(element.supplierId)){
                        orderedMapBySuppliers[element.supplierId].add(element);
                      }else{
                        orderedMapBySuppliers[element.supplierId] = [element];
                      }
                    }

                  });

                  if(amountHundred == 0){
                    Scaffold.of(context).showSnackBar(const SnackBar(
                      backgroundColor: kPinaColor,
                      content: Text('Immettere il valore di Q/100 per almeno un prodotto'),
                    ));
                  }else{

                  }
                },
              ),
            ),

            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: buildCurrentListProdutctTableForStockManagmentUnload(dataBundleNotifier, context),
                  ),
                  const SizedBox(height: 80,),
                ],
              ),
            ),
          );
        }
    );
  }

  buildCurrentListProdutctTableForStockManagmentUnload(DataBundleNotifier dataBundleNotifier, context){
    List<Row> rows = [

    ];

    dataBundleNotifier.currentStorageProductListForCurrentStorage.forEach((element) {

      TextEditingController controller = TextEditingController(text: element.amountHundred.toString());
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(200),
                  child: Text(element.productName, overflow: TextOverflow.clip, style: TextStyle(fontSize: getProportionateScreenWidth(16)),),
                ),
                Row(
                  children: [
                    Text(element.unitMeasure, style: TextStyle(fontSize: getProportionateScreenWidth(8)),),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(FontAwesomeIcons.dotCircle, size: getProportionateScreenWidth(3),),
                    ),
                    dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? Text('',style:
                    TextStyle(fontSize: getProportionateScreenWidth(8))) : Text(element.price.toString() + ' €', style: TextStyle(fontSize: getProportionateScreenWidth(8)),),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if(element.amountHundred <= 0){
                      }else{
                        element.amountHundred --;
                      }
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.minus, color: kPinaColor,),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(getProportionateScreenWidth(70), getProportionateScreenWidth(60))),
                  child: CupertinoTextField(
                    controller: controller,
                    onChanged: (text) {
                      if( double.tryParse(text) != null){
                        element.amountHundred = double.parse(text);
                      }else{
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text('Immettere un valore numerico corretto per ' + element.productName),
                        ));
                      }

                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    clearButtonMode: OverlayVisibilityMode.never,
                    textAlign: TextAlign.center,
                    autocorrect: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      element.amountHundred ++;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.plus, color: Colors.green.shade900),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
    return Column(
      children: rows,
    );
  }
}
