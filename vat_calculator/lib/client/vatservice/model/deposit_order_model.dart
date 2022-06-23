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
      'pk_deposit_order_id' : pkDepositOrderId,
      'creation_date': creationDate,
      'amount': amount,
      'fk_order_id' : fkOrderId,
      'user' : user
    };
  }

}