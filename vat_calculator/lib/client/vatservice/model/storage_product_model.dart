import 'package:flutter/cupertino.dart';

class StorageProductModel{

  int pkStorageProductId;
  int fkStorageId;
  int fkProductId;
  int supplierId;
  String productName;
  double stock;
  String available;
  String supplierName;
  double price;
  int vatApplied;
  String unitMeasure;
  double amountHundred;
  bool selected;
  double extra;
  double loadUnloadAmount;

  StorageProductModel({
    @required this.pkStorageProductId,
    @required this.fkStorageId,
    @required this.fkProductId,
    @required this.supplierId,
    @required this.productName,
    @required this.stock,
    @required this.available,
    @required this.supplierName,
    @required this.price,
    @required this.vatApplied,
    @required this.unitMeasure,
    @required this.amountHundred,
    @required this.selected,
    @required this.extra,
    @required this.loadUnloadAmount
  });

  toMap(){
    return {
      'pkStorageProductId' : pkStorageProductId,
      'fkStorageId': fkStorageId,
      'fkProductId' : fkProductId,
      'supplierId' : supplierId,
      'productName': productName,
      'stock': stock,
      'available': available,
      'supplierName': supplierName,
      'price': price,
      'vatApplied': vatApplied,
      'unitMeasure': unitMeasure,
      'amountHundred': amountHundred,
      'selected' : selected
    };
  }

}