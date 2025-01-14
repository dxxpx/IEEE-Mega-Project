import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hackfest/views/Uicomponents.dart';
import 'places.dart';

class Addplaces extends StatefulWidget {
  const Addplaces({super.key});

  @override
  State<Addplaces> createState() => _AddplacesState();
}

class _AddplacesState extends State<Addplaces> {
  String storeType = '';
  String storeName = '';
  TextEditingController locationController = TextEditingController();
  String location = '';
  String address = '';
  String info = '';
  String accomodation = '';

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

  Future<void> _addPlaceToFirebase() async {
    try {
      await FirebaseFirestore.instance.collection('nearbyPlaces').add({
        'Accomodation': accomodation,
        'Address': address,
        'Info': info,
        'Location': locationController.text,
        'StoreName': storeName,
        'StoreType': storeType,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Place added Successfully')));
      Navigator.pop(context);
    } catch (e) {
      // Show error message
      print('Error adding Place: $e');
    }
  }

  String? selectedValue;
  final List<String> _options = [
    'Medicals',
    'Groceries',
    'Shelter',
    'Supermarket',
    'Hospital',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Places', style: appbar_Tstyle),
        backgroundColor: appblue,
        iconTheme: backButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Store Name :',
              style: heading_Tstlye(),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  storeName = value;
                });
              },
              decoration: t_boxdecor(hintText: "Enter Store Name:"),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text('Store Type:', style: heading_Tstlye()),
                SizedBox(width: 10),
                DropdownButton<String>(
                  hint: Text('Select an option', style: content_Tstlye()),
                  value: selectedValue,
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  },
                  items: _options.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text('Location :', style: heading_Tstlye()),
            TextFormField(
              controller: locationController,
              decoration: t_boxdecor(
                  hintText: "Click below button to Get your location"),
            ),
            SizedBox(height: 5),
            ElevatedButton(
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
            Text('Address :', style: heading_Tstlye()),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  address = value;
                });
              },
              decoration: t_boxdecor(hintText: "Enter store's address:"),
            ),
            SizedBox(height: 5),
            if (selectedValue == 'Shelter')
              Text('Accomodation :', style: heading_Tstlye()),
            if (selectedValue == 'Shelter')
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    accomodation = value;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: t_boxdecor(
                    hintText: "Number of people you can Accomodate:"),
              ),
            SizedBox(height: 5),
            Text('Additional Info about your service:',
                style: heading_Tstlye()),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  info = value;
                });
              },
              decoration:
                  t_boxdecor(hintText: "Enter any additional information:"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  // _addPlaceToFirebase;
                  addPlace(storeName, storeType, location, address, info,
                      accomodation);
                },
                style: buttonStyle(),
                child: Text(
                  'Add Place',
                  style: buttonTstyle(),
                ))
          ],
        ),
      ),
    );
  }
}
