import 'package:flutter/cupertino.dart';

class RecessedModel{

  int pkRecessedId;
  String description;
  double amount;
  int vat;
  int dateTimeRecessed;
  int dateTimeRecessedInsert;
  int fkBranchId;

  RecessedModel({
    @required this.pkRecessedId,
    @required this.description,
    @required this.amount,
    @required this.vat,
    @required this.dateTimeRecessed,
    @required this.dateTimeRecessedInsert,
    @required this.fkBranchId,});

  toMap(){
    return {
      'pkRecessedId' : pkRecessedId,
      'description': description,
      'amount': amount,
      'vat': vat,
      'dateTimeRecessed' : dateTimeRecessed.toString(),
      'dateTimeRecessedInsert' : dateTimeRecessedInsert.toString(),
      'fkBranchId' : fkBranchId
    };
  }
}