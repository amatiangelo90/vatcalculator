import 'package:flutter/cupertino.dart';

class WorkstationModel{
  int id;
  String name;
  String type;
  String responsible;
  String extra;
  String closed;
  int fkEventId;

  WorkstationModel(
      {
        @required this.id,
        @required this.name,
        @required this.type,
        @required this.responsible,
        @required this.extra,
        @required this.closed,
        @required this.fkEventId,
      });

  toMap(){
    return {
      'id' : id,
      'name': name,
      'type': type,
      'responsible' : responsible,
      'extra' : extra,
      'closed' : closed,
      'fkEventId' : fkEventId,
    };
  }

  factory WorkstationModel.fromJson(dynamic json){
    return WorkstationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      responsible: json['responsible'] as String,
      extra: json['extra'] as String,
      closed: json['closed'] as String,
      fkEventId: json['fkEventId'] as int,
    );
  }
}