import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../viewmodels/changes.dart';
import '../views/user_online/register_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String apikey = dotenv.env['OPENAI_API_KEY'] ?? "";
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: apikey,
      appId: "1:795621005285:android:985e46eb36c7a2171f410c",
      messagingSenderId: "795621005285",
      projectId: "hackfest-d74d3",
      storageBucket: 'gs://hackfest-d74d3.appspot.com',
    ),
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  unawaited(MobileAds.instance.initialize());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Changes(
      child: MaterialApp(
        title: 'SafeReach',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Register(),
      ),
    );
  }
}
