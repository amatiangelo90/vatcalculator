import 'package:flutter/cupertino.dart';

class UserBranchRelationModel{
  int pkUserBranchId;
  int fkUserId;
  int fkBranchId;
  String accessPrivilege;

  UserBranchRelationModel({
    @required this.pkUserBranchId,
    @required this.fkBranchId,
    @required this.fkUserId,
    @required this.accessPrivilege
});

  toMap(){
    return {
      'pkUserBranchId' : pkUserBranchId,
      'fkBranchId': fkBranchId,
      'fkUserId' : fkUserId,
      'accessPrivilege' : accessPrivilege
    };
  }

}