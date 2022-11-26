import 'dart:convert';

import 'package:dio/dio.dart';

import 'costants_mail_service.dart';

class EmailSenderService{

  Future<Response> sendEmailServiceApi({
    required String userName,
    required String userEmail,
    required String message,
    required String orderCode,
    required String branchName,
    required String supplierName,
    required String supplierEmail,
    required String addressBranch,
    required String addressBranchCity,
    required String addressBranchCap,
    required String branchNumber,
    required String deliveryDate
  }) async {

    print('Sending mail order from branch [$branchName] from [$userName] with email address [$userEmail] to supplier [$supplierName] with email [$supplierEmail]');
    var dio = Dio();

    Response post;
    var jsonEncodeString = jsonEncode(
        {
          "branch_name": branchName,
          "branch_number": branchNumber,
          "order_code": orderCode,
          "message": message,
          "supplier_name": supplierName,
          "supplier_email": supplierEmail,
          "user_name": userName,
          "user_email": userEmail,
          "branch_address": addressBranch,
          "branch_city": addressBranchCity,
          "branch_cap": addressBranchCap,
          "delivery_date_millisec": deliveryDate
        }
    );
    print('EMAIL API: ' + URL_EMAIL_SERVICE);
    print('EMAIL Api Request: ' + jsonEncodeString);

    try{
      post = await dio.post(
        URL_EMAIL_SERVICE,
        data: jsonEncodeString,
      );

    }catch(e){
      print('Exception message: ' + e.toString());
      return Response(statusCode: 500, requestOptions: RequestOptions(path: ''));
    }
    return post;
  }
}
