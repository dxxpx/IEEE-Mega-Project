import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/service_imp.dart';
import '../Uicomponents.dart';

class GoogleMapScreen extends StatefulWidget {
  final double lat;
  final double long;
  const GoogleMapScreen({Key? key, required this.lat, required this.long})
      : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    getCurrentLocationAndSave();
    fetchMarkersFromFirestore();
  }

  Future<void> getCurrentLocationAndSave() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    location = '${position.latitude}, ${position.longitude}';
    print(location);
    Service_Imp().storelocation(location);
    setState(() {
      markers.add(Marker(
        markerId: MarkerId('user_location'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: 'Your Location',
          snippet: 'This is your current location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen), // Customize this icon
      ));
      mapController.moveCamera(CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ));
    });
  }

  GeoPoint convertToGeoPoint(String location) {
    final latitude = double.parse(location.split(',')[0].split(':')[1].trim());
    final longitude = double.parse(location.split(',')[1].split(':')[1].trim());
    return GeoPoint(latitude, longitude);
  }

  Future<void> fetchMarkersFromFirestore() async {
    GeoFlutterFire geo = GeoFlutterFire();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double radius = 10; // 10 km radius

    FirebaseFirestore.instance
        .collection('updates')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String locationString = doc.get('location');
        GeoPoint point = convertToGeoPoint(locationString);
        String positionString = doc['location'];
        double distance = Geolocator.distanceBetween(position.latitude,
                position.longitude, point.latitude, point.longitude) /
            1000; // in kilometers

        List<String> latLng = positionString.split(', ');
        double latitude = double.parse(latLng[0].split(': ')[1]);
        double longitude = double.parse(latLng[1].split(': ')[1]);
        if (distance <= radius) {
          setState(() {
            markers.add(Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(point.latitude, point.longitude),
              infoWindow: InfoWindow(
                title: doc['disasterType'],
                snippet: doc['suggestion'],
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
            ));
          });
        }
      });
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Disaster Prone Areas", style: appbar_Tstyle),
        iconTheme: backButton(color: Colors.white),
        backgroundColor: appblue,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.lat == 0 ? 13.007481 : widget.lat,
                widget.long == 0 ? 77.598656 : widget.long),
            zoom: 10,
          ),
          mapToolbarEnabled: true,
          buildingsEnabled: false,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          markers: markers,
          onMapCreated: onMapCreated,
          zoomControlsEnabled: true,
        ),
      ),
    );
  }
}
