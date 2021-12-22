import 'package:flutter/cupertino.dart';

class ExpenceModel{

  int pkExpenceId;
  String description;
  double amount;
  int vat;
  int dateTimeExpence;
  int dateTimeExpenceInsert;
  int fkBranchId;
  String fiscal;

  ExpenceModel({
    @required this.pkExpenceId,
    @required this.description,
    @required this.amount,
    @required this.vat,
    @required this.dateTimeExpence,
    @required this.dateTimeExpenceInsert,
    @required this.fkBranchId,
    @required this.fiscal,
  });

  toMap(){
    return {
      'pkExpenceId' : pkExpenceId,
      'description': description,
      'amount': amount,
      'vat': vat,
      'dateTimeExpence' : dateTimeExpence.toString(),
      'dateTimeExpenceInsert' : dateTimeExpenceInsert.toString(),
      'fkBranchId' : fkBranchId,
      'fiscal' : fiscal
    };
  }
}