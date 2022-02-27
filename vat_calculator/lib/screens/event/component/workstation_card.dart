import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_product_model.dart';

class WorkstationCard extends StatelessWidget {
  const WorkstationCard({Key key, this.workstationModel, this.showExpandedTile, this.workstationIdProductListMap}) : super(key: key);

  final WorkstationModel workstationModel;
  final bool showExpandedTile;
  final Map<int, List<WorkstationProductModel>> workstationIdProductListMap;

  @override
  Widget build(BuildContext context) {
    print('workstation model ' + workstationModel.pkWorkstationId.toString());
    print('workstation prod list ' + workstationIdProductListMap.length.toString());
    workstationIdProductListMap.forEach((key, value) {
      print('key: ' + key.toString());
      value.forEach((element) {
        print(element.fkWorkstationId.toString());
        print(element.pkWorkstationStorageProductId.toString());
      });
    });
    return Container(
      width: 50,
      height: 50,
      color: Colors.green,
    );
  }
}
