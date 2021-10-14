import 'package:flutter/cupertino.dart';

class UserModel{
  int id;
  String name;
  String lastName;
  String phone;
  String mail;

  UserModel(
      {
        @required this.id,
        @required this.name,
        @required this.lastName,
        @required this.phone,
        @required this.mail,
      });

  toMap(){
    return {
      'id' : id,
      'name': name,
      'lastName': lastName,
      'phone' : phone,
      'mail' : mail
    };
  }

  factory UserModel.fromJson(dynamic json){
    return UserModel(
      id: json['id'] as int,
      name: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phoneNumber'] as String,
      mail: json['eMail'] as String,
    );
  }
}