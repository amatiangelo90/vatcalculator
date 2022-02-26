import 'package:flutter/cupertino.dart';

class WorkstationProductModel{

  String productName;
  String unitMeasure;
  int fkSupplierId;
  int pkWorkstationStorageProductId;
  double refillStock;
  double consumed;
  int fkWorkstationId;
  int fkStorProdId;
  double storeStock;
  double amountHunderd;


  WorkstationProductModel(
      {
        @required this.productName,
        @required this.unitMeasure,
        @required this.fkSupplierId,
        @required this.pkWorkstationStorageProductId,
        @required this.refillStock,
        @required this.consumed,
        @required this.fkWorkstationId,
        @required this.fkStorProdId,
        @required this.storeStock,
        @required this.amountHunderd,
      });

  toMap(){
    return {
      'productName' : productName,
      'unitMeasure': unitMeasure,
      'fkSupplierId': fkSupplierId,
      'pkWorkstationStorageProductId' : pkWorkstationStorageProductId,
      'refillStock' : refillStock,
      'consumed' : consumed,
      'fkWorkstationId' : fkWorkstationId,
      'fkStorProdId' : fkStorProdId,
      'storeStock' : storeStock,
      'amountHunderd' : amountHunderd,
    };
  }

  factory WorkstationProductModel.fromJson(dynamic json){
    return WorkstationProductModel(
      productName: json['productName'] as String,
      unitMeasure: json['unitMeasure'] as String,
      fkSupplierId: json['fkSupplierId'] as int,
      pkWorkstationStorageProductId: json['pkWorkstationStorageProductId'] as int,
      refillStock: json['refillStock'] as double,
      consumed: json['consumed'] as double,
      fkWorkstationId: json['fkWorkstationId'] as int,
      fkStorProdId: json['fkStorProdId'] as int,
      storeStock: json['storeStock'] as double,
      amountHunderd: json['amountHunderd'] as double,
    );
  }
}