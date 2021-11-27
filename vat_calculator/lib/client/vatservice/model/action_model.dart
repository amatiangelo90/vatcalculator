import 'package:flutter/cupertino.dart';

class ActionModel{

  int pkActionId;
  String user;
  String description;
  int date;
  int fkBranchId;
  String type;

  ActionModel({
    @required this.pkActionId,
    @required this.user,
    @required this.description,
    @required this.date,
    @required this.fkBranchId,
    @required this.type,});

  toMap(){
    return {
      'pkActionId' : pkActionId,
      'user': user,
      'description': description,
      'date' : date.toString(),
      'fkBranchId' : fkBranchId,
      'type' : type
    };
  }
}