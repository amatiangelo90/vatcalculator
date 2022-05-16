import 'package:flutter/cupertino.dart';

class ArchiviedNotPaidRequest{

  int pkBranchId;
  int pkSupplierId;

  toMap(){
    return {
      'pkBranchId' : pkBranchId,
      'pkSupplierId' : pkSupplierId,
    };
  }

  ArchiviedNotPaidRequest({
    @required this.pkBranchId,
    @required this.pkSupplierId
  });

}