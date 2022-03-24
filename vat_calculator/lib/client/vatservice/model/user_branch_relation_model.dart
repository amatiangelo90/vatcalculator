import 'package:flutter/cupertino.dart';

class UserBranchRelationModel{
  int pkUserBranchId;
  int fkUserId;
  int fkBranchId;
  String accessPrivilege;
  String configurations;

  UserBranchRelationModel({
    @required this.pkUserBranchId,
    @required this.fkBranchId,
    @required this.fkUserId,
    @required this.accessPrivilege,
    @required this.configurations
});

  toMap(){
    return {
      'pkUserBranchId' : pkUserBranchId,
      'fkBranchId': fkBranchId,
      'fkUserId' : fkUserId,
      'accessPrivilege' : accessPrivilege,
      'configurations' : configurations,
    };
  }

}