import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

Future<String?> getDeviceToken() async {
  return await _firebaseMessaging.getToken();
}

Future<String> getAccessToken() async {
  final serviceAccountJson =
      await rootBundle.loadString('assets/service_account.json');
  final serviceAccount = ServiceAccountCredentials.fromJson(serviceAccountJson);

  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  final authClient = await clientViaServiceAccount(serviceAccount, scopes);
  final accessToken = (await authClient.credentials).accessToken.data;
  return accessToken;
}

Future<void> sendNotification(String act, String dvt) async {
  final url =
      'https://fcm.googleapis.com/v1/projects/hackfest-d74d3/messages:send';
  final headers = {
    'Authorization': 'Bearer $act',
    'Content-Type': 'application/json',
  };

  final notification = {
    'message': {
      'notification': {
        'title': "title",
        'body': "body",
      },
      'token': dvt,
    }
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: json.encode(notification),
  );

  if (response.statusCode == 200) {
    print(response);
    print('Notification sent successfully');
  } else {
    print('Failed to send notification: ${response.body}');
  }
}
