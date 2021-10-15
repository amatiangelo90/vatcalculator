import 'package:flutter/cupertino.dart';

class RecessedModel{

  int pkRecessedId;
  String description;
  double amount;
  int dateTimeRecessed;
  int dateTimeRecessedInsert;
  int fkBranchId;

  RecessedModel({
    @required this.pkRecessedId,
    @required this.description,
    @required this.amount,
    @required this.dateTimeRecessed,
    @required this.dateTimeRecessedInsert,
    @required this.fkBranchId,});

  toMap(){
    return {
      'pkRecessedId' : pkRecessedId,
      'description': description,
      'amount': amount,
      'dateTimeRecessed' : dateTimeRecessed.toString(),
      'dateTimeRecessedInsert' : dateTimeRecessedInsert.toString(),
      'fkBranchId' : fkBranchId
    };
  }
}