import 'package:flutter/cupertino.dart';

class BranchModel{
  int pkBranchId;
  String companyName;
  String eMail;
  String vatNumber;
  String address;
  String phoneNumber;
  String providerFatture;
  String apiKeyOrUser;
  String apiUidOrPassword;

  BranchModel({
    @required this.pkBranchId,
    @required this.companyName,
    @required this.eMail,
    @required this.vatNumber,
    @required this.address,
    @required this.phoneNumber,
    @required this.providerFatture,
    @required this.apiKeyOrUser,
    @required this.apiUidOrPassword});

  toMap(){
    return {
      'pkBranchId' : pkBranchId,
      'name': companyName,
      'email': eMail,
      'address' : address,
      'phone' : phoneNumber,
      'vatNumber': vatNumber,
      'provider': providerFatture,
      'idKeyUser' : apiKeyOrUser,
      'idUidPassword' : apiUidOrPassword,
      'fkUserId' : 0,
    };
  }
}
