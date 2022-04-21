import 'package:flutter/material.dart';

class LoadProductIntoWorkstationAndUnloadFromStorageModel{
  int pkProductId;
  int storageIdFrom;
  int storageIdTo;
  double amount;

  LoadProductIntoWorkstationAndUnloadFromStorageModel({
    @required this.pkProductId,
    @required this.storageIdFrom,
    @required this.storageIdTo,
    @required this.amount,
  });

  toMap(){
    return {
      'pkProductId' : pkProductId,
      'storageIdFrom' : storageIdFrom,
      'storageIdTo' : storageIdTo,
      'amount' : amount
    };
  }

}