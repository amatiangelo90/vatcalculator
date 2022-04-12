import 'package:flutter/material.dart';

class MoveProductBetweenStorageModel{
  int pkProductId;
  int storageIdFrom;
  int storageIdTo;
  double amount;

  MoveProductBetweenStorageModel({
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