import 'package:flutter/cupertino.dart';

class ExpenceEventModel{

  int pkEventExpenceId;
  String description;
  double amount;
  double cost;
  int dateTimeInsert;
  int fkEventId;


  ExpenceEventModel({
    @required this.pkEventExpenceId,
    @required this.description,
    @required this.amount,
    @required this.cost,
    @required this.dateTimeInsert,
    @required this.fkEventId
  });

  toMap(){
    return {
      'pkEventExpenceId' : pkEventExpenceId,
      'description': description,
      'amount': amount,
      'cost': cost,
      'dateTimeInsert' : dateTimeInsert.toString(),
      'fkEventId' : fkEventId
    };
  }
}