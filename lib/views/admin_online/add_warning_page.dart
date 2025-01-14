import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';

import '../Uicomponents.dart';

class AddWarningPage extends StatefulWidget {
  @override
  _AddWarningPageState createState() => _AddWarningPageState();
}

class _AddWarningPageState extends State<AddWarningPage> {
  // Variables to store input values
  String disasterType = '';
  bool isSevere = false;
  String suggestion = '';
  TextEditingController locationController = TextEditingController();
  String location = '';

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

  // Function to add warning to Firebase
  Future<void> _addWarningToFirebase() async {
    try {
      await FirebaseFirestore.instance.collection('updates').add({
        'disasterType': disasterType,
        'isSevere': isSevere,
        'suggestion': suggestion,
        'location': locationController.text,
        'timestamp': DateTime.now(),
      });
      Future<List<String>> fetchPhoneNumbers() async {
        Set<String> phoneNumbersSet = {};

        try {
          QuerySnapshot querySnapshot =
              await FirebaseFirestore.instance.collection('users').get();

          for (var doc in querySnapshot.docs) {
            String phoneNumber = doc['primaryphno'];
            phoneNumbersSet.add(phoneNumber);
          }
        } catch (e) {
          print('Error fetching phone numbers: $e');
        }

        return phoneNumbersSet.toList();
      }

      Future<void> send(String phoneNumber) async {
        final Telephony telephony = Telephony.instance;

        bool? permissionsGranted = await telephony.requestSmsPermissions;
        if (permissionsGranted != null && permissionsGranted) {
          telephony.sendSms(
            to: phoneNumber,
            message:
                "DISASTER CALL\nThere is a disaster of type:$disasterType\nAt:$location\nYou are suggested$suggestion",
          );
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Disaster Alert Sent Successfully')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('SMS permissions not granted')));
        }
      }

      List<String> contacts = await fetchPhoneNumbers();
      for (int i = 0; i < contacts.length; i++) {
        send(contacts[i]);
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Warning Posted Successfully')));
      Navigator.pop(context);
    } catch (e) {
      // Show error message
      print('Error adding warning: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Warning', style: appbar_Tstyle),
        backgroundColor: appblue,
        iconTheme: backButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(19.0),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 60),
              color: appblue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Disaster Type :',
                        style: heading_Tstlye(color: Colors.white)),
                    SizedBox(height: 1.0),
                    TextField(
                        onChanged: (value) {
                          setState(() {
                            disasterType = value;
                          });
                        },
                        decoration: t_boxdecor(
                          hintText: "Enter Disaster Type",
                        )),
                    Row(
                      children: [
                        Checkbox(
                          value: isSevere,
                          onChanged: (value) {
                            setState(() {
                              isSevere = value!;
                            });
                          },
                        ),
                        Text(
                          'Is Severe?',
                          style: content_Tstlye(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    Text('Location :',
                        style: heading_Tstlye(color: Colors.white)),
                    SizedBox(height: 1.0),
                    TextFormField(
                        controller: locationController,
                        decoration: t_boxdecor(hintText: "Get Location")),
                    SizedBox(height: 6),
                    Text(locationController.text),
                    SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        style: buttonStyle(bgcolor: Colors.white),
                        onPressed: () async {
                          String location = await _getCurrentLocation();
                          locationController.text = location;
                        },
                        child: Text(
                          'Get Current Location',
                          style: buttonTstyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Suggestion :',
                        style: heading_Tstlye(color: Colors.white)),
                    SizedBox(height: 1.0),
                    TextField(
                        onChanged: (value) {
                          setState(() {
                            suggestion = value;
                          });
                        },
                        decoration:
                            t_boxdecor(hintText: "Type your suggestion")),
                    SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        style: buttonStyle(bgcolor: Colors.white),
                        onPressed: _addWarningToFirebase,
                        child: Text(
                          'Update',
                          style: buttonTstyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
