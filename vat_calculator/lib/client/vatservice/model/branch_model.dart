import 'package:flutter/cupertino.dart';

class BranchModel{
  int pkBranchId;
  String companyName;
  String eMail;
  String vatNumber;
  String address;
  String city;
  int cap;
  String phoneNumber;
  String providerFatture;
  String apiKeyOrUser;
  String apiUidOrPassword;
  String accessPrivilege;
  String configuration;

  BranchModel({
    @required this.pkBranchId,
    @required this.companyName,
    @required this.eMail,
    @required this.vatNumber,
    @required this.address,
    @required this.city,
    @required this.cap,
    @required this.phoneNumber,
    @required this.providerFatture,
    @required this.apiKeyOrUser,
    @required this.apiUidOrPassword,
    @required this.accessPrivilege,
    @required this.configuration,
  });


  toMap(){
    return {
      'pkBranchId' : pkBranchId,
      'name': companyName,
      'email': eMail,
      'address' : address,
      'city' : city,
      'cap' : cap,
      'phone' : phoneNumber,
      'vatNumber': vatNumber,
      'provider': providerFatture,
      'idKeyUser' : apiKeyOrUser,
      'idUidPassword' : apiUidOrPassword,
      'fkUserId' : 0,
      'accessPrivilege' : accessPrivilege,
      'configuration' : configuration,
    };
  }
}
