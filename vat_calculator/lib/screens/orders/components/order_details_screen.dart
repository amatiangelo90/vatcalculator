import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/size_config.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({Key key, this.orderModel, this.productList, }) : super(key: key);

  final OrderModel orderModel;
  final List<ProductOrderAmountModel> productList;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CupertinoButton(child: Text('Ricevuto', style: const TextStyle(color: Colors.green),), onPressed: (){

            }),
            CupertinoButton(child: Text('Archivia', style: const TextStyle(color: kPinaColor),), onPressed: (){

            }),
          ],
        ),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: kPrimaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: kBeigeColor,
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: const Text(
              'Dettaglio Ordine', style: TextStyle(color: kPrimaryColor),
          ),
        ),
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.45,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Card(
                    child: Column(
                      children: [
                        Text('# ' + orderModel.code, style: TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: [
                  Text('Carrello', style: TextStyle(color: kPinaColor, fontSize: getProportionateScreenHeight(20), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            buildProductListWidget(productList),
            Divider(indent: 20, endIndent: 20,),
          ],
        ),
      ),
    );
  }

  buildProductListWidget(List<ProductOrderAmountModel> productList) {
    
    List<TableRow> tableRowList = [
    ];

    productList.forEach((currentProduct) {
      tableRowList.add(
        TableRow(
          children: [
            Text(currentProduct.nome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(15)),),
            Row(
              children: [
                Text(getNiceNumber(currentProduct.amount.toString()), style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(15)),),
              ],
            ),
            Text('x'),
            Text(currentProduct.unita_misura, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(15))),
          ],
        ),
      );
    });
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(4),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
        },
        children: tableRowList,
      ),
    );
  }

  String getNiceNumber(String string) {
    if(string.contains('.00')){
      return string.replaceAll('.00', '');
    }else if(string.contains('.0')){
      return string.replaceAll('.0', '');
    }else {
      return string;
    }
  }
}
