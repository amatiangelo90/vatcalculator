import 'package:dio/dio.dart';

abstract class FirebaseServiceInterface{

  Future<Response> sendNotificationToTopic(String topicName, String message, String title, String msgId);
}