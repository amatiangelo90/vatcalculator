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
    @required this.unitMeasure
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
    };
  }

}