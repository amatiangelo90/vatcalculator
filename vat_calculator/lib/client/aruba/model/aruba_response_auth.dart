import 'dart:core';

import 'package:flutter/cupertino.dart';

class  ArubaAuthResponse{
  String acess_token;
  String token_type;
  int expires_in;
  String refresh_token;
  String as_client_id;
  String userName;
  String issued;
  String expires;

  ArubaAuthResponse({
    @required this.acess_token,
    @required   this.token_type,
    this.expires_in,
    this.refresh_token,
    this.as_client_id,
    this.userName,
    this.issued,
    this.expires});
}
