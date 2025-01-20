import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../ads.dart';
import '../../services/service_imp.dart';
import '../Uicomponents.dart';
import 'package:url_launcher/url_launcher.dart';

class Rescue extends StatefulWidget {
  @override
  State<Rescue> createState() => _RescueState();
}

class _RescueState extends State<Rescue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What do people around\n me need?', style: appbar_Tstyle),
        backgroundColor: appblue,
        iconTheme: backButton(color: Colors.white),
      ),
      body: Column(
        children: [
          MyBannerAdWidget(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('distress')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Something went wrong"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No distress signals found"));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> distress = snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>;

                    // Fetch user details using user ID
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(distress['userID'])
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!userSnapshot.hasData ||
                            !userSnapshot.data!.exists) {
                          return ListTile(
                            title:
                                Text(distress['type'].toString().toUpperCase()),
                            subtitle: Text('User not found'),
                          );
                        }

                        Map<String, dynamic> userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        String location = userData['location'];

                        return FutureBuilder<String>(
                          future: getLocation(location),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> locationSnapshot) {
                            if (locationSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (locationSnapshot.hasError) {
                              return ListTile(
                                title: Text(
                                    distress['type'].toString().toUpperCase()),
                                subtitle: Text('Error fetching location'),
                              );
                            }

                            String humanReadableLocation =
                                locationSnapshot.data ?? 'Unknown location';

                            return DistressCalls(
                              distress['type'].toString().toUpperCase(),
                              userData['name'],
                              userData['people'].toString(),
                              distress['time']
                                  .toDate()
                                  .toString()
                                  .substring(0, 16),
                              humanReadableLocation,
                              () {
                                List<String> latLng = location.split(', ');
                                double latitude = double.parse(latLng[0]);
                                double longitude = double.parse(latLng[1]);

                                Future<void> _launchUrl() async {
                                  if (!await launchUrl(Uri.parse(
                                      "https://www.google.com/maps/dir//$latitude,$longitude/@$latitude,$longitude,17z?entry=ttu"))) {
                                    throw Exception(
                                        'Could not launch https://www.google.com/maps/');
                                  }
                                }

                                _launchUrl();
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
