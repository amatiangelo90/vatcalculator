import 'dart:core';

import 'package:flutter/cupertino.dart';

class  FattureInCloudRequestInfoCompany{
  String apiUid;
  String apiKey;


  FattureInCloudRequestInfoCompany(
      {@required this.apiUid,
        @required this.apiKey
      });

  toMap(){
    return {
      'api_uid': apiUid,
      'api_key': apiKey,
      "campi": [
        "durata_licenza",
        "nome",
        "tipo_licenza"
      ]
    };
  }
}
