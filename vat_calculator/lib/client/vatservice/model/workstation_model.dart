import 'package:flutter/cupertino.dart';

class WorkstationModel{
  int pkWorkstationId;
  String name;
  String type;
  String responsable;
  String extra;
  String closed;
  int fkEventId;

  WorkstationModel(
      {
        required this.pkWorkstationId,
        required this.name,
        required this.type,
        required this.responsable,
        required this.extra,
        required this.closed,
        required this.fkEventId,
      });

  toMap(){
    return {
      'pkWorkstationId' : pkWorkstationId,
      'name': name,
      'type': type,
      'responsable' : responsable,
      'extra' : extra,
      'closed' : closed,
      'fkEventId' : fkEventId,
    };
  }

  factory WorkstationModel.fromJson(dynamic json){
    return WorkstationModel(
      pkWorkstationId: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      responsable: json['responsable'] as String,
      extra: json['extra'] as String,
      closed: json['closed'] as String,
      fkEventId: json['fkEventId'] as int,
    );
  }
}