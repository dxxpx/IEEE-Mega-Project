import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import '../models/chat_request.dart';
import '../models/chat_response.dart';
import '../services/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sendNotification() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch device tokens from Firestore
  List<String> deviceTokens =
      await _firestore.collection('users').get().then((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => doc['deviceToken'].toString())
        .toList();
  });

  // Prepare the payload for the API
  final Map<String, dynamic> payload = {
    'tokens': deviceTokens,
    'title': 'There is a disaster at your place',
    'body': 'DISASTER',
  };

  // Send the notification via the API
  final http.Response response = await http.post(
    Uri.parse('http://154.49.243.165:7500/api/notify/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(payload),
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully');
  } else {
    print('Failed to send notification: ${response.statusCode}');
  }
}

String user = '';
String location = '';
Future<String> getLocation(String loc) async {
  final latLng = loc.split(',');
  double latitude = double.parse(latLng[0]);
  double longitude = double.parse(latLng[1]);

  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
  final place = placemarks[0];
  return "${place.street}, ${place.subLocality}, ${place.locality}, "
      "${place.administrativeArea}, ${place.postalCode}, ${place.country}";
}

class ApiKey {
  static String? openAIApiKey = dotenv.env['OPENAI_API_KEY'];
}

class ChatService {
  static final Uri chatUri =
      Uri.parse('https://api.openai.com/v1/chat/completions');

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ApiKey.openAIApiKey}',
  };

  Future<String?> request(String prompt) async {
    try {
      ChatRequest request = ChatRequest(
          model: "gpt-3.5-turbo",
          maxTokens: 150,
          messages: [Message(role: "system", content: prompt)]);
      if (prompt.isEmpty) {
        return null;
      }
      http.Response response = await http.post(
        chatUri,
        headers: headers,
        body: request.toJson(),
      );
      print(response);
      ChatResponse chatResponse = ChatResponse.fromResponse(response);
      print(chatResponse);
      print(chatResponse.choices?[0].message?.content);
      return chatResponse.choices?[0].message?.content;
    } catch (e) {
      print("error $e");
    }
    return null;
  }
}

class Service_Imp extends Services {
  Future<void> storelocation(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('location', value);
    location = value;
    print("Updated");
  }

  Future<String?> retrievelocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    location = prefs.getString('location') ?? "location";
    return location;
  }

  Future<void> storeid(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userid', value);
    user = value;
  }

  Future<String?> retrieveid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('userid') ?? 'ID';
    print(user);
    print("kjdglsjdgkjds");
    return user;
  }

  Future<void> registerUser(
      String name,
      String mail,
      String primaryphno,
      String secondaryphno,
      String location,
      String adhar,
      int people,
      String ages,
      String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );
      String userID = userCredential.user!.uid;
      storeid(userID);
      storelocation(location);
      await FirebaseFirestore.instance.collection('users').doc(userID).set({
        'name': name,
        'mail': mail,
        'primaryphno': primaryphno,
        'secondaryphno': secondaryphno,
        'location': location,
        'adhar': adhar,
        'people': people,
        'ages': ages,
        'userId': userID
      });
    } catch (e) {
      print("Error registering user: $e");
    }
  }
}
