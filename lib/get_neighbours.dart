import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class NearestLocationsFinder {
  Future<List<Map<String, dynamic>>> getNearestLocations(
      List<Map<String, dynamic>> storedLocations, int count) async {
    // Get current location
    LocationData currentLocation = await getCurrentLocation();
    double currentLatitude = currentLocation.latitude!;
    double currentLongitude = currentLocation.longitude!;

    // Calculate distances to each stored location
    for (var location in storedLocations) {
      double distance = calculateDistance(
        currentLatitude,
        currentLongitude,
        location['latitude'],
        location['longitude'],
      );
      location['distance'] = distance;
    }

    // Sort by distance
    storedLocations.sort((a, b) => a['distance'].compareTo(b['distance']));

    // Return the nearest locations
    return storedLocations.take(count).toList();
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Location permissions are denied');
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }
}

class NearestLocationsScreen extends StatefulWidget {
  @override
  _NearestLocationsScreenState createState() => _NearestLocationsScreenState();
}

class _NearestLocationsScreenState extends State<NearestLocationsScreen> {
  List<Map<String, dynamic>> nearestLocations = [];

  @override
  void initState() {
    super.initState();
    findNearestLocations();
  }

  Future<void> findNearestLocations() async {
    List<Map<String, dynamic>> locations = await fetchLocationsFromFirestore();
    NearestLocationsFinder finder = NearestLocationsFinder();
    List<Map<String, dynamic>> nearest =
        await finder.getNearestLocations(locations, 4);
    setState(() {
      nearestLocations = nearest;
    });
  }

  Future<List<Map<String, dynamic>>> fetchLocationsFromFirestore() async {
    List<Map<String, dynamic>> locations = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    for (var doc in snapshot.docs) {
      String locationString = doc['location'];
      List<String> latLng = locationString.split(', ');
      print(latLng);
      print("lkadjlgjldk");
      double latitude = double.parse(latLng[0].split(': ')[1]);
      double longitude = double.parse(latLng[1].split(': ')[1]);
      locations.add({
        'id': doc.id,
        'latitude': latitude,
        'longitude': longitude,
      });
    }
    return locations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearest Locations'),
      ),
      body: ListView.builder(
        itemCount: nearestLocations.length,
        itemBuilder: (context, index) {
          var location = nearestLocations[index];
          return ListTile(
            title: Text('User ID: ${location['id']}'),
            subtitle: Text(
                'Distance: ${location['distance'].toStringAsFixed(2)} meters'),
          );
        },
      ),
    );
  }
}
