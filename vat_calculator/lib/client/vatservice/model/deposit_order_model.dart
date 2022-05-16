import 'package:flutter/cupertino.dart';

class DepositOrder{

  int pkDepositOrderId;
  int creationDate;
  double amount;
  int fkOrderId;
  String user;

  DepositOrder({
    @required this.pkDepositOrderId,
    @required this.creationDate,
    @required this.amount,
    @required this.fkOrderId,
    @required this.user
  });

  toMap(){
    return {
      'pkDepositOrderId' : pkDepositOrderId,
      'creationDate': creationDate,
      'amount': amount,
      'fkOrderId' : fkOrderId,
      'user' : user,
    };
  }

}