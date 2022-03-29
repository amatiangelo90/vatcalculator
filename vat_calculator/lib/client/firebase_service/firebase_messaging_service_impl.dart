import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:vat_calculator/client/firebase_service/firebase_service_interface.dart';

import 'constant/utils_firebase_service.dart';

class FirebaseMessagingService implements FirebaseServiceInterface{

  @override
  Future<Response> sendNotificationToTopic(String topicName, String message, String title, String msgId) async {

    try{
      var dio = Dio();

      dio.options.headers['Authorization'] = 'key=$FIREBASE_USER_KEY';
      dio.options.headers['Content-Type'] = 'application/json';

      var jsonEncodedBody = jsonEncode(
          {
            "to": "/topics/$topicName",
            "notification": {
              "title": "$title",
              "body": "$message"
            },
            "data": {
              "msgId": "$msgId"
            }
          }
      );

      Response response = await dio.post(
        FIREBASE_MESSAGING_SERVICE_URL,
        data: jsonEncodedBody,
      );


    }catch(e){
      print(e);
    }
  }
}