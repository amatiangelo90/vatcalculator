import 'package:flutter/cupertino.dart';

class UserModel{
  int id;
  String name;
  String lastName;
  String phone;
  String mail;
  String privilege;
  int relatedUserId;

  UserModel(
      {
        required this.id,
        required this.name,
        required this.lastName,
        required this.phone,
        required this.mail,
        required this.privilege,
        required this.relatedUserId,
      });

  toMap(){
    return {
      'id' : id,
      'name': name,
      'lastName': lastName,
      'phone' : phone,
      'mail' : mail,
      'privilege' : privilege,
      'relatedUserId' : relatedUserId,
    };
  }

  factory UserModel.fromJson(dynamic json){
    return UserModel(
      id: json['id'] as int,
      name: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phoneNumber'] as String,
      mail: json['eMail'] as String,
      privilege: json['privilege'] as String,
      relatedUserId: json['relatedUserId'] as int,
    );
  }
}