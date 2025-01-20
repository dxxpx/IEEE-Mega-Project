import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/service_imp.dart';
import '../notifications.dart';
import '../user_online/welcome_page.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Color _blue = Color(0XFF4D88D7);

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController =
      TextEditingController(text: "soniya@gmail.com");

  final TextEditingController passwordController =
      TextEditingController(text: "123456");

  Color _statusColor = Colors.green; // Default color is red

  @override
  void initState() {
    super.initState();
    _checkInternetStatus();
  }

  void _checkInternetStatus() async {
    print(await InternetConnectionCheckerPlus().hasConnection);
    final listener = InternetConnectionCheckerPlus()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      setState(() {
        _statusColor = status == InternetConnectionStatus.connected
            ? Colors.green
            : Colors.red;
      });
    });
  }

  String dvt = "Device Token";

  @override
  Widget build(BuildContext context) {
    void _loginUser(String email, String password) async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        String userID = userCredential.user!.uid;
        Service_Imp().storeid(userID);
        if (user != null) {
          // Get the device token
          String? token = await getDeviceToken();
          if (token != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userID)
                .update({
              'deviceToken': token,
            });
          }
        }
        print(user);

        Navigator.pop(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      } catch (e) {
        print("Error logging in: $e");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid Login')));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "   Login",
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 35, color: Colors.white),
        ),
        backgroundColor: _blue,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      color: _blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Text(
                              'Welcome Back !!',
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 1.0),
                            Text(
                              'Login with your details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            Divider(
                              thickness: 1.17,
                              color: Colors.white,
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                label: Text('Email'),
                                floatingLabelStyle: TextStyle(
                                    fontSize: 25, color: Colors.black),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                icon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.0),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                filled: true,
                                fillColor: Colors.white,
                                floatingLabelStyle: TextStyle(
                                    fontSize: 25, color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                icon: Icon(
                                  Icons.password_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () async {
                                String email = emailController.text;
                                String password = passwordController.text;
                                _loginUser(email, password);

                                // String at = await getAccessToken();
                                // sendNotification(at, dt ?? '');
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 28.0),
                    Text(
                      'Don\'t have an Account ?',
                      style: TextStyle(fontSize: 18),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 17),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
