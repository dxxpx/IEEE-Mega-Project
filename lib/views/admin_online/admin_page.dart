import 'package:flutter/material.dart';
import '../admin_online/admin_welcome_page.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../Uicomponents.dart';

Color _blue = Color(0XFF4D88D7);

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController emailController =
      TextEditingController(text: "123");

  final TextEditingController passwordController =
      TextEditingController(text: "123");

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

  @override
  Widget build(BuildContext context) {
    void _loginUser(String email, String password) async {
      if (email == "123" && password == "123") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => AdminWelcomePage()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid Login')));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Rescue Crew Login', style: buttonTstyle()),
        backgroundColor: appblue,
        iconTheme: backButton(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Container(
            //   padding: EdgeInsets.all(16),
            //   color: _statusColor,
            //   width: double.infinity,
            //   child: Center(
            //     child: Text(
            //       _statusColor == Colors.green ? 'Online' : 'Offline',
            //       style: TextStyle(
            //         fontSize: 24,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: t_boxdecor(
                      hintText: "Enter Crew Code", labelText: "Crew Code"),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  decoration: t_boxdecor(
                      hintText: "Enter your Password", labelText: "Password"),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () {
                    String email = emailController.text;
                    String password = passwordController.text;
                    _loginUser(email, password);
                  },
                  child: Text(
                    'Login',
                    style: buttonTstyle(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
