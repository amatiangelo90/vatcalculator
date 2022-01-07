import 'dart:convert';

import 'package:dio/dio.dart';

import 'costants_mail_service.dart';

class EmailSenderService{

  Future<Response> sendEmail1({
    String userName,
    String userEmail,
    String message,
    String orderCode,
    String branchName,
    String supplierName,
    String supplierEmail,
    String addressBranch,
    String deliveryDate
  }) async {

    print('Send mail order from branch [$branchName] from [$userName] with email address [$userEmail] to supplier [$supplierName] with email [$supplierEmail]');
    var dio = Dio();
    Response post;

    try{
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['origin'] = 'http://localhost';


      post = await dio.post(
        URL_EMAIL_API_SERVICE,
        data: jsonEncode(
          {
            'service_id' : MAIL_API_SERVICE_ID,
            'template_id' : MAIL_API_TEMPLATE_ID,
            'user_id' : MAIL_API_USER_ID,
            'template_params' : {
              'branch_name' : branchName,
              'user_name' : userName,
              'user_email' : userEmail,
              'supplier_email' : supplierEmail,
              'message' : message,
              'branch_address' : addressBranch,
              'delivery_date' : deliveryDate,
              'order_code': orderCode
            }
          }
        ),
      );


      print('Response From Email Sender (' + URL_EMAIL_API_SERVICE + '): ' + post.data.toString());
      return post;
    }catch(e){
      print(e);
      Response erroreResponse = Response();
      erroreResponse.statusCode = 500;
      erroreResponse.statusMessage = e;
      return erroreResponse;
    }
  }

  Future<Response> sendEmailByKontumServiceApi({
    String userName,
    String userEmail,
    String message,
    String orderCode,
    String branchName,
    String supplierName,
    String supplierEmail,
    String addressBranch,
    String addressBranchCity,
    String addressBranchCap,
    String branchNumber,
    String deliveryDate
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
    print('EMAIL API: ' + URL_KONTUM_EMAIL_SERVICE);
    print('EMAIL Api Request: ' + jsonEncodeString);

    try{
      post = await dio.post(
        URL_KONTUM_EMAIL_SERVICE,
        data: jsonEncodeString,
      );

    }catch(e){
      print('Exception message: ' + e.toString());
      return Response(statusCode: 500);
    }
    return post;
  }
}
