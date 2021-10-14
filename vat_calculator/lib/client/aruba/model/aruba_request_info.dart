import 'dart:core';

import 'package:flutter/cupertino.dart';

class  ArubaAuthRequest{
  String grantType;
  String username;
  String password;


  ArubaAuthRequest(
      {@required this.grantType,
        @required this.username,
        @required this.password,
      });

  toMap(){
    return {
      'grant_type': grantType,
      'username': username,
      'password': password
    };

  }
}
