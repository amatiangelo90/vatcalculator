import 'package:flutter/cupertino.dart';

class EventModel{
  int pkEventId;
  String eventName;
  int creationDate;
  int eventDate;
  String closed;
  String owner;
  String location;
  int fkStorageId;
  int fkBranchId;

  EventModel({
    @required this.pkEventId,
    @required this.eventName,
    @required this.creationDate,
    @required this.eventDate,
    @required this.closed,
    @required this.owner,
    @required this.location,
    @required this.fkStorageId,
    @required this.fkBranchId,
  });


  toMap(){
    return {
      'pkEventId' : pkEventId,
      'eventName': eventName,
      'creationDate': creationDate,
      'eventDate' : eventDate,
      'closed' : closed,
      'owner' : owner,
      'location' : location,
      'fkStorageId' : fkStorageId,
      'fkBranchId' : fkBranchId,
    };
  }
}
