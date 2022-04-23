import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../../client/vatservice/model/workstation_model.dart';
import '../../../client/vatservice/model/workstation_product_model.dart';
import '../../../client/vatservice/model/workstation_type.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'event_manager_screen.dart';

class RecapWorkstationsWidget extends StatelessWidget {
  const RecapWorkstationsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return FutureBuilder(
          initialData: const Center(
              child: CircularProgressIndicator(
                color: Colors.lightBlueAccent,
              )),
          builder: (context, snapshot){
            return snapshot.data;
          },
          future: retrieveDataToBuildRecapWidget(dataBundleNotifier),
        );

      },
    );
  }

  Future<Widget> retrieveDataToBuildRecapWidget(
      DataBundleNotifier dataBundleNotifier) async {

    Map<int, SupportTableObj> supportTableObjList = {};

    supportTableObjList.clear();
    supportTableObjList = {};

    sleep(const Duration(milliseconds: 300));


    List<TableRow> rows = [];
    rows.add(
      TableRow( children: [
        Row(
          children: [
            Text('  PRODOTTO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(9)),),
          ],
        ),
        Text('CARICO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(9)),),
        Text('RESIDUO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(9)),),
        Text('CONSUMO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(9)),),
        Text('COSTO (€)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(9)),),
      ]),
    );

    Set<int> idsProductsPresent = Set();

    if(dataBundleNotifier.workstationsProductsMap != null || dataBundleNotifier.workstationsProductsMap.isNotEmpty){
      dataBundleNotifier.workstationsProductsMap.forEach((workstationId, listProducts) {
        listProducts.forEach((product) {
          idsProductsPresent.add(product.fkProductId);
        });
      });
    }

    idsProductsPresent.forEach((productId) {
      dataBundleNotifier.workstationsProductsMap.forEach((workstationId, listProducts) {
        listProducts.forEach((product) {
          if(product.fkProductId == productId){

            if(supportTableObjList.containsKey(productId)){
              supportTableObjList[productId].amountout = supportTableObjList[productId].amountout + product.consumed;
              supportTableObjList[productId].amountin = supportTableObjList[productId].amountin + product.refillStock;

            }else{
              supportTableObjList[productId] = SupportTableObj(
                  id: productId,
                  amountin: product.refillStock,
                  amountout: product.consumed,
                  productName: product.productName,
                  price: product.productPrice,
                  unitMeasure: product.unitMeasure
              );
            }
          }
        });
      });
    });

    double totalExpence = 0.0;

    idsProductsPresent.forEach((id) {
      totalExpence = totalExpence + ((supportTableObjList[id].amountin - supportTableObjList[id].amountout) * supportTableObjList[id].price);
      rows.add(TableRow( children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(supportTableObjList[id].productName, textAlign: TextAlign.start, overflow: TextOverflow.visible,
                style: TextStyle( color: Colors.white, fontSize: getProportionateScreenHeight(14)),),
              Text('€ ' + supportTableObjList[id].price.toStringAsFixed(2) + ' / ' + supportTableObjList[id].unitMeasure, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: getProportionateScreenHeight(10)),),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Column(
            children: [
              Text(supportTableObjList[id].amountin.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(14)),),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(supportTableObjList[id].amountout.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(14)),),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text((supportTableObjList[id].amountin - supportTableObjList[id].amountout).toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(color: kCustomWhite, fontSize: getProportionateScreenHeight(14)),),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(((supportTableObjList[id].amountin - supportTableObjList[id].amountout) * supportTableObjList[id].price).toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(color: kCustomWhite, fontSize: getProportionateScreenHeight(14)),),
        ),
      ]),);
    });


    return Container(
      color: kPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              dataBundleNotifier.currentEventModel.closed == 'Y' ? SizedBox(
                width: getProportionateScreenWidth(500),
                child: Container(color: kCustomBordeaux, child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Center(child: Text('EVENTO CHIUSO', style: TextStyle(fontSize: getProportionateScreenHeight(25), color: Colors.white),)),
                )),
              ) : SizedBox(height: 10),
              SizedBox(
                width: getProportionateScreenWidth(500),
                child: Container(color: Color(0XFFE64C3D), child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child:  Text('TOTALE', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(24)),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text('€ ' + totalExpence.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(30)),),
                    ),
                  ],
                ),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Riepilogo Costi Workstations', style: TextStyle(fontSize: getProportionateScreenHeight(18), color: Colors.white), ),
                    Text(''),
                  ],
                ),
              ),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(5),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(3),
                },
                border: TableBorder.all(
                    color: Colors.grey,
                    width: 0.1
                ),
                children: rows,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child:  Text('TOTALE', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: getProportionateScreenHeight(18)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text('€ ' + totalExpence.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomWhite, fontSize: getProportionateScreenHeight(20)),),
                  ),

                ],
              ),
              SizedBox(height: 50),
              buildWorkstationDetailsTablesWidget(dataBundleNotifier.currentWorkstationModelList, dataBundleNotifier.workstationsProductsMap),
              SizedBox(height: 100),
            ],

          ),
        ),
      ),
    );
  }

  buildWorkstationDetailsTablesWidget(List<WorkstationModel> workstationModelList, Map<int, List<WorkstationProductModel>> map) {
    List<Widget> tablesWidget = [];

    workstationModelList.forEach((workstationItem) {


      tablesWidget.add(Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: getProportionateScreenWidth(300),
            child: Card(
              color: workstationItem.type == WORKSTATION_TYPE_BAR ? kCustomOrange : kCustomEvidenziatoreGreen,
              child: Text('  Riepilogo ' + workstationItem.name,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ));
      List<TableRow> rows = [];
      rows.add(
        TableRow( children: [
          Row(
            children: [
              Text('  PRODOTTO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(9)),),
            ],
          ),
          Text('CARICO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(9)),),
          Text('RESIDUO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(9)),),
          Text('CONSUMO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(9)),),
          Text('COSTO (€)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(9)),),
        ]),
      );
      double totalExpenceWorkstation = 0.0;
      map[workstationItem.pkWorkstationId].forEach((workStationProdModel) {


        totalExpenceWorkstation = totalExpenceWorkstation + (workStationProdModel.refillStock - workStationProdModel.consumed) * workStationProdModel.productPrice;

        rows.add(
          TableRow( children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(workStationProdModel.productName, textAlign: TextAlign.start, overflow: TextOverflow.visible,
                    style: TextStyle( color: Colors.white, fontSize: getProportionateScreenHeight(14)),),
                  Text('€ ' + workStationProdModel.productPrice.toStringAsFixed(2) + ' / ' + workStationProdModel.unitMeasure, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: getProportionateScreenHeight(10)),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Column(
                children: [
                  Text(workStationProdModel.refillStock.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(14)),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Text(workStationProdModel.consumed.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(14)),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Text((workStationProdModel.refillStock - workStationProdModel.consumed).toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(color: kCustomWhite, fontSize: getProportionateScreenHeight(14)),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Text(((workStationProdModel.refillStock - workStationProdModel.consumed) * workStationProdModel.productPrice).toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(color: kCustomWhite, fontSize: getProportionateScreenHeight(14)),),
            ),
          ]),
        );
      });


      tablesWidget.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(5),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(3),
          },
          border: TableBorder.all(
              color: Colors.grey,
              width: 0.1
          ),
          children: rows,
        ),
      ));

      tablesWidget.add(
        Card(
          child: SizedBox(
            width: getProportionateScreenWidth(500),
            child: Container(color: workstationItem.type == WORKSTATION_TYPE_BAR ? Colors.yellow.shade800 : Colors.teal.shade700, child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  Text('TOTALE', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(24)),),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text('€ ' + totalExpenceWorkstation.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(30)),),
                ),
              ],
            ),),
          ),
        ),
      );
    });



    return Column(
      children: tablesWidget,
    );

  }
}
