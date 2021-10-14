import 'dart:core';

import 'package:flutter/cupertino.dart';

class  FattureInCloudRequestInfo{
  String apiUid;
  String apiKey;


  FattureInCloudRequestInfo(
      {@required this.apiUid,
        @required this.apiKey
      });

  toMap(){
    return {
      'api_uid': apiUid,
      'api_key': apiKey
    };

  }
}
