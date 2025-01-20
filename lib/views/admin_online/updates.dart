import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/service_imp.dart';
import '../admin_online/add_warning_page.dart';
import '../Uicomponents.dart';

class Updates extends StatefulWidget {
  const Updates({Key? key}) : super(key: key);

  @override
  State<Updates> createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
  final geo = GeoFlutterFire();
  late Position userPosition;
  final double radiusInKm = 10.0;
  final firestore = FirebaseFirestore.instance;
  late Stream<List<DocumentSnapshot>> stream;

  Future<void> getCurrentLocationAndSave() async {
    print("Current Location loading...");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userPosition = position;
    location = '${position.latitude}, ${position.longitude}';
    print('Current Location: $location');
    setState(() {});
  }

  GeoPoint convertToGeoPoint(String location) {
    final latitude = double.parse(location.split(',')[0].split(':')[1].trim());
    final longitude = double.parse(location.split(',')[1].split(':')[1].trim());
    return GeoPoint(latitude, longitude);
  }

  Future<double> calculateDistance(GeoPoint docLocation) async {
    return Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      docLocation.latitude,
      docLocation.longitude,
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocationAndSave();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Disaster Updates"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('updates')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text("No updates available."),
            );
          }

          final updates = snapshot.data!.docs;

          //     return ListView.builder(
          //       itemCount: updates.length,
          //       itemBuilder: (BuildContext context, int index) {
          //         final update = updates[index];
          //         final bool isSevere = update['isSevere'];
          //
          //         return Updatetile(
          //             update['disasterType'],
          //             update['suggestion'],
          //             update['timestamp'].toDate().toString().substring(0, 16),
          //             isSevere,
          //             update['location'],
          //             context);
          //       },
          //     );
          //   },
          // ),
          return FutureBuilder(
            future: Future.wait(
              updates.map((update) async {
                String locationString = update.get('location');
                GeoPoint docLocation = convertToGeoPoint(locationString);
                final double distanceInMeters =
                    await calculateDistance(docLocation);
                return distanceInMeters <= (radiusInKm * 1000) ? update : null;
              }).toList(),
            ),
            builder: (BuildContext context,
                AsyncSnapshot<List<DocumentSnapshot?>> filteredSnapshot) {
              if (!filteredSnapshot.hasData || filteredSnapshot.data == null) {
                return Center(
                  child: Text("Updates are'nt available right Now."),
                );
              }

              final filteredUpdates = filteredSnapshot.data!
                  .where((update) => update != null)
                  .toList();

              return ListView.builder(
                itemCount: filteredUpdates.length,
                itemBuilder: (BuildContext context, int index) {
                  final update = filteredUpdates[index]!;
                  final bool isSevere = update['isSevere'];

                  return Updatetile(
                      update['disasterType'],
                      update['suggestion'],
                      update['timestamp'].toDate().toString().substring(0, 16),
                      isSevere,
                      update['location'],
                      context);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendNotification();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddWarningPage()));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
