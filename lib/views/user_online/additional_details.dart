import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/service_imp.dart';
import '../../services/services.dart';
import '../user_online/welcome_page.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';
import '../Uicomponents.dart';
import '../../viewmodels/changes.dart';

class AdditionalDetails extends StatefulWidget {
  @override
  _AdditionalDetailsState createState() => _AdditionalDetailsState();
}

class _AdditionalDetailsState extends State<AdditionalDetails> {
  Color _statusColor = Colors.green; // Default color is red

  @override
  void initState() {
    super.initState();
    _checkInternetStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle permission denied
      return '';
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle permanently denied
      return '';
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.toString());
    return position.toString();
    // Handle user location
  }

  void _checkInternetStatus() async {
    bool a = await InternetConnectionCheckerPlus().hasConnection;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Disaster Relief', style: appbar_Tstyle),
        iconTheme: backButton(color: Colors.white),
        backgroundColor: appblue,
        actions: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: _statusColor, borderRadius: BorderRadius.circular(10)),
            child: Text(
              _statusColor == Colors.green ? "Online" : "Offline",
              style: appbar_Tstyle,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
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
            _buildRegistrationForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    TextEditingController adharController = TextEditingController();
    TextEditingController peopleController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    String encryptedAdhar = '';

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            controller: adharController,
            decoration: InputDecoration(labelText: 'Adhar'),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: peopleController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Number of People'),
          ),
          SizedBox(height: 40),
          SizedBox(height: 10),
          TextFormField(
            controller: ageController,
            decoration: InputDecoration(labelText: 'Ages of People'),
          ),
          Text("Enter the ages of people seperated by comma"),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              Services obj = new Service_Imp();
              print(context.read<MyModel>().state.name);
              await obj.registerUser(
                  context.read<MyModel>().state.name ?? '',
                  context.read<MyModel>().state.mail ?? '',
                  context.read<MyModel>().state.primaryphno ?? '',
                  context.read<MyModel>().state.secondaryphno ?? '',
                  context.read<MyModel>().state.location ?? '',
                  adharController.text,
                  int.parse(peopleController.text),
                  ageController.text,
                  context.read<MyModel>().state.password ?? '');
              print("Done");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomePage()),
              );
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
