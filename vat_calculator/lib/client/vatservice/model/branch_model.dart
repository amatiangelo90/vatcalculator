import 'package:flutter/cupertino.dart';

import '../../../enums.dart';

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
      'pkBranchId' : 0,
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

// {
//    "pkBranchId": 1,
//    "name": "branch",
//    "vatNumber": "123123123",
//    "address": "via del tormento 32",
//    "phone": "4343234234",
//    "provider": "aruba",
//    "idKeyUser": "XXXXXXXXXXXXXXXXX",
//    "idUidPassword": "XXXXXXXXXXXXXXX",
//    "fkUserId": 1
// }
}
/**
 * pkBranchId
    name
    eMail
    vatNumber
    address
    phone
    provider
    idKeyUser
    idUidPassword
    fkUserId
 */

