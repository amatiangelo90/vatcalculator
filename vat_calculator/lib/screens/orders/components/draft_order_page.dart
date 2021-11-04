import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';

import '../../../constants.dart';

class DraftOrderPage extends StatefulWidget {
  @override
  _DraftOrderPageState createState() => _DraftOrderPageState();
}

class _DraftOrderPageState extends State<DraftOrderPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: FutureBuilder(
              initialData: <Widget>[
                const Center(
                    child: CircularProgressIndicator(
                      color: kPinaColor,
                    )),
                const SizedBox(),
                Column(
                  children: const [
                    Center(
                      child: Text(
                        'Caricamento prodotti..',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: kPrimaryColor,
                            fontFamily: 'LoraFont'),
                      ),
                    ),
                  ],
                ),
              ],
              future: buildDraftOrderList(dataBundleNotifier.currentDraftOrdersList, dataBundleNotifier),
              builder: (context, snapshot) {
                return Column(
                  children: snapshot.data,
                );
              },
            ),
          ),
        );
      }
    );
  }

  Future<List<Widget>> buildDraftOrderList(List<OrderModel> currentDraftOrdersList, DataBundleNotifier databundleNotifier) async{

    List<Widget> currentCard = [];

    if(currentDraftOrdersList.length == 0){
      currentCard.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(280),
            ),
            Center(
              child: Text('Nessuna bozza di ordine presente',textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenHeight(20)),),
            ),
          ],
        ),
      );
    }else{
      currentDraftOrdersList.forEach((orderElementDraft) async {
        currentCard.add(
          SizedBox(
            width: getProportionateScreenWidth(360),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Center(
                        child: ClipRect(
                          child: Container(
                            margin: const EdgeInsets.all(10.0),

                            height: 100,
                            color: Colors.orange,

                            child: Banner(
                              message: "hello",
                              location: BannerLocation.topEnd,
                              color: Colors.red,
                              child: Container(


                                child: Center(child: Text("Hello, banner!"),),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text('Codice Ordine #' + orderElementDraft.code),
                      Text(orderElementDraft.details),
                      SizedBox(
                        height: getProportionateScreenHeight(28),
                          width: getProportionateScreenHeight(60),
                          child: Card(
                            child: Text(orderElementDraft.status),
                          ),
                      ),
                      Text('Supplier Id: ' + orderElementDraft.fk_supplier_id.toString()),
                      Text('Storage Id: ' + orderElementDraft.fk_storage_id.toString()),
                      Text(DateTime.fromMillisecondsSinceEpoch(orderElementDraft.creation_date).toString()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    }

    return currentCard;
  }
}