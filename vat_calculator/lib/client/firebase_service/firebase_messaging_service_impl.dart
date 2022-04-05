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
              "sound": "default",
              "title": "$title",
              "body": "$message"
            },
            "data": {
              "msgId": "$msgId"
            }
          }
      );

      await dio.post(
        FIREBASE_MESSAGING_SERVICE_URL,
        data: jsonEncodedBody,
      );


    }catch(e){
      print(e);
    }
  }

  @override
  Future<Response> sendNotificationToUsersByTokens(List<String> tokensList, String message, String title, String msgId) async {
    try{
      print('Send notification to follow list tokens ' + tokensList.toString());
      if(tokensList != null && tokensList.isNotEmpty){
        var dio = Dio();

        dio.options.headers['Authorization'] = 'key=$FIREBASE_USER_KEY';
        dio.options.headers['Content-Type'] = 'application/json';

        String tokensListString = '';

        tokensList.forEach((token) {
          tokensListString = tokensListString + token + ',';
        });
        tokensListString = tokensListString.substring(0, tokensListString.length - 1);

        var jsonEncodedBody = jsonEncode(
            {
              "registration_ids": [tokensListString],
              "notification": {
                "sound": "default",
                "title": "$title",
                "body": "$message"
              },
              "data": {
                "msgId": "$msgId"
              }
            }
        );

        print('Request: ' + jsonEncodedBody);
        await dio.post(
          FIREBASE_MESSAGING_SERVICE_URL,
          data: jsonEncodedBody,
        );
      }else{
        print('Not sending push notification. Tokens list is empty');
      }



    }catch(e){
      print(e);
    }
  }
}