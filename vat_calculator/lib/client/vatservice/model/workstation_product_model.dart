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
  int fkProductId;
  double storeStock;
  double amountHunderd;
  double productPrice;


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
        @required this.fkProductId,
        @required this.storeStock,
        @required this.amountHunderd,
        @required this.productPrice,
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
      'fkProductId' : fkProductId,
      'storeStock' : storeStock,
      'amountHunderd' : amountHunderd,
      'productPrice' : productPrice,
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
      fkProductId: json['fkProductId'] as int,
      storeStock: json['storeStock'] as double,
      amountHunderd: json['amountHunderd'] as double,
      productPrice: json['productPrice'] as double,
    );
  }
}