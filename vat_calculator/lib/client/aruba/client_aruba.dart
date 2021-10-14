import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:vat_calculator/client/aruba/constant/utils_aruba.dart';

import 'model/aruba_request_info.dart';



class ArubaClient {

  Future<Response> performAuthentication(
      String password,
      String username) async {

    var dio = Dio();

    String body = json.encode(
        ArubaAuthRequest(
          grantType: 'password',
          username: username,
          password: password
        ).toMap());

    print('Request' + body);
    Response post;
    try{
      post = await dio.post(
          URL_FATTURE_ARUBA_AUTH_SIGNIN,
          data: body,
          options: Options(contentType: Headers.formUrlEncodedContentType)
      );


      print('Response From Aruba (' + URL_FATTURE_ARUBA_AUTH_SIGNIN + '): ' + post.data.toString());

    }catch(e){
      print(e);
    }
    return post;
  }
}