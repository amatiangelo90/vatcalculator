import 'package:flutter/cupertino.dart';

class RecessedModel{

  int pkRecessedId;
  String description;
  double amountF;
  double amountNF;
  double amountCash;
  double amountPos;
  int vat;
  int dateTimeRecessed;
  int dateTimeRecessedInsert;
  int fkCashRegisterId;

  RecessedModel({
    @required this.pkRecessedId,
    @required this.description,
    @required this.amountF,
    @required this.amountNF,
    @required this.amountCash,
    @required this.amountPos,
    @required this.vat,
    @required this.dateTimeRecessed,
    @required this.dateTimeRecessedInsert,
    @required this.fkCashRegisterId,});

  toMap(){
    return {
      'pkRecessedId' : pkRecessedId,
      'description': description,
      'amountF': amountF,
      'amountNF': amountNF,
      'amountCash': amountCash,
      'amountPos': amountPos,
      'vat': vat,
      'dateTimeRecessed' : dateTimeRecessed.toString(),
      'dateTimeRecessedInsert' : dateTimeRecessedInsert.toString(),
      'fkCashRegisterId' : fkCashRegisterId
    };
  }
}