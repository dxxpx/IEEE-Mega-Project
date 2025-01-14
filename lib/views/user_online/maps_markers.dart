import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    fetchMarkersFromFirestore();
  }

  Future<void> fetchMarkersFromFirestore() async {
    FirebaseFirestore.instance
        .collection('updates')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String positionString = doc['location'];
        List<String> latLng = positionString.split(', ');
        double latitude = double.parse(latLng[0].split(': ')[1]);
        double longitude = double.parse(latLng[1].split(': ')[1]);
        setState(() {
          markers.add(Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: doc['disasterType'],
              snippet: doc['suggestion'],
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor
                .hueAzure), // Customize this to add flood symbol
          ));
        });
      });
    });
  }

  @override
  void dispose() {
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
