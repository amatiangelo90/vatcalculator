import 'package:flutter/cupertino.dart';

class StorageModel {
  int pkStorageId;
  String name;
  String code;
  DateTime creationDate;
  String address;
  String city;
  String cap;
  int fkBranchId;

  StorageModel({
    required this.pkStorageId,
    required this.name,
    required this.code,
    required this.creationDate,
    required this.address,
    required this.city,
    required this.cap,
    required this.fkBranchId,
  });

  factory StorageModel.fromJson(dynamic json){
    return StorageModel(
      pkStorageId: json['pkStorageId'],
      name: json['name'] as String,
      code: json['code'] as String,
      creationDate: json['creationDate'] as DateTime,
      address: json['address'],
      city: json['city'] as String,
      cap: json['cap'] as String,
      fkBranchId: json['fkBranchId'],
    );
  }

  factory StorageModel.fromMap(Map snapshot,
      String docId){
    return StorageModel(
      pkStorageId: snapshot['pk_storage_id'],
      name: snapshot['name'] as String,
      code: snapshot['code'] as String,
      creationDate: snapshot['creation_date'] as DateTime,
      address: snapshot['address'] as String,
      cap: snapshot['cap'] as String,
      city: snapshot['city'] as String,
      fkBranchId: snapshot['fk_branch_id'],
    );
  }

  toMap() {
    int currentDate;
    if(creationDate == null){
      currentDate = 0;
    }else{
      currentDate = creationDate.millisecondsSinceEpoch;
    }
    return {
      'pk_storage_id': pkStorageId,
      'name': name,
      'code': code,
      'creation_date': currentDate,
      'address': address,
      'cap': cap,
      'city': city,
      'fk_branch_id': fkBranchId,
    };
  }


  @override
  String toString() {
    return 'Magazzino [' + name + ']' + ' - branchid [' +
        fkBranchId.toString() + ']';
  }
}