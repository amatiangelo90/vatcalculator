import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:vat_calculator/client/aruba/constant/utils_aruba.dart';

import 'model/aruba_request_info.dart';



class ArubaClient {

  Future<Response> performVerifyCredentials(
      String password,
      String username) async {

    var dio = Dio();

    Response post;

    try{

      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';

      Response response = await dio.post(
        URL_FATTURE_ARUBA_AUTH_SIGNIN,
        data: ArubaAuthRequest(
            grantType: 'password',
            username: username,
            password: password
        ).toMap(),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      print('Response From Aruba (' + URL_FATTURE_ARUBA_AUTH_SIGNIN + '): ' + response.statusCode.toString());
      return response;
    }catch(e){
      print(e);
      Response response = Response(
        data: e,
        statusCode: 500
      );
      return response;
    }

  }
}