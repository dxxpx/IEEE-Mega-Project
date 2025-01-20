import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/service_imp.dart';
import '../sockets_udp.dart';
import '../user_online/primary_phone.dart';
import '../user_online/register_page.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';
import '../../viewmodels/changes.dart';
import '../Uicomponents.dart';

class UserOffline extends StatefulWidget {
  @override
  _UserOfflineState createState() => _UserOfflineState();
}

class _UserOfflineState extends State<UserOffline> {
  Color _statusColor = Colors.purple; // Default color is red

  @override
  void initState() {
    super.initState();
    getstring();
    Service_Imp().retrieveid();
    _checkInternetStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final Telephony telephony = Telephony.instance;

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
    return "${position.latitude}, ${position.longitude}";

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

  Future<void> getstring() async {
    location = await Service_Imp().retrievelocation() ?? 'loco';
    print(location);
    setState(() {});
  }

  void _showConfirmationDialog(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content:
              Text('Are you sure you want to send a $type distress signal?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Future<void> send(String phoneNumber) async {
                  bool? permissionsGranted =
                      await telephony.requestSmsPermissions;
                  if (permissionsGranted != null && permissionsGranted) {
                    telephony.sendSms(
                      to: phoneNumber,
                      message:
                          "DISTRESS CALL\nFrom User:$user\nType:$type\nLocation:$location",
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Distress Call Sent Successfully')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('SMS permissions not granted')));
                  }
                }

                send("7305293478");

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Distress signal sent sucessfully'),
                  ),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getCurrentLocationAndSave() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    location = '${position.latitude}, ${position.longitude}';
    print(location);
    Service_Imp().storelocation(location);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disaster Relief-Offline', style: appbar_Tstyle),
        backgroundColor: appblue,
        iconTheme: backButton(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Switch Mode'),
                      content: Text(
                          'Are you sure you want to switch to Online Mode?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Register()));

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Switching to Online Mode'),
                              ),
                            );
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.signal_cellular_alt))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              location,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: getCurrentLocationAndSave,
              child: Text('Update Location'),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  elevation: 10),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  distressTile("I am safe but I need food supply",
                      Icons.food_bank_rounded, () {
                    _showConfirmationDialog("food");
                  }, Colors.green),
                  SizedBox(height: 40),
                  distressTile(
                      "I need Medical Assistance", Icons.local_hospital_rounded,
                      () {
                    _showConfirmationDialog("Medical");
                  }, Colors.blueAccent),
                  SizedBox(height: 40),
                  distressTile(
                      "I am at danger, Come and Save me", Icons.sos_rounded,
                      () {
                    _showConfirmationDialog("sos");
                  }, Colors.red),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future<void> showWifiPage(BuildContext context) async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Please Connect to wifi DistressAP'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await OpenSettingsPlusAndroid().wifi();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UdpSender()));
                      },
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );
          }

          Future<void> showSettings(BuildContext context) async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Switch on the Hotspot'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: Text('Done'),
                    ),
                  ],
                );
              },
            );
          }

          Future<void> showconfirm(BuildContext context) async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                      'Are you sure you want to use our No network communication to send message?'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        showWifiPage(context);
                      },
                      child: Text('Yes'),
                    ),
                  ],
                );
              },
            );
          }

          showconfirm(context);
        },
        child: Icon(Icons.wifi),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: locationController,
            decoration: InputDecoration(labelText: 'Location'),
          ),
          SizedBox(height: 10),
          Text(locationController.text),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              String location = await _getCurrentLocation();
              locationController.text = location;
            },
            child: Text('Get Current Location'),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              await context.read<MyModel>().register1(
                  nameController.text,
                  locationController.text,
                  emailController.text,
                  passwordController.text);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrimaryPhone()),
              );
            },
            child: Text('Continue to Register'),
          ),
        ],
      ),
    );
  }
}
