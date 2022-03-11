import 'package:flutter/cupertino.dart';

class CashRegisterModel{

  int pkCashRegisterId;
  String name;
  int fkBranchId;

  CashRegisterModel({
    @required this.pkCashRegisterId,
    @required this.name,
    @required this.fkBranchId,
    });

  toMap(){
    return {
      'pkCashRegisterId' : pkCashRegisterId,
      'name': name,
      'fkBranchId': fkBranchId
    };
  }
}