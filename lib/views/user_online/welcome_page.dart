import 'dart:convert';
import 'package:battery/battery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/service_imp.dart';
import '../Uicomponents.dart';
import '../admin_online/placeScreen.dart';
import '../dialog_flow.dart';
import '../disaster.dart';
import '../emergency_contact.dart';
import '../user_offline/user_offline.dart';
import '../user_online/battery.dart';
import '../user_online/buy.dart';
import '../user_online/leaderboardPage.dart';
import '../user_online/maps_markers.dart';
import '../user_online/my_problems.dart';
import '../user_online/register_page.dart';
import '../user_online/rescue.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../admin_online/add_provisions.dart';
import '../admin_online/showProvisions.dart';
import '../datascrape.dart';
import '../floodChecker.dart';
import 'insurancePage.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State with SingleTickerProviderStateMixin {
  final Battery _battery = Battery();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Position userPosition;
  final double radiusInKm = 10.0;
  late String currentloc = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _showBatteryAlert(BuildContext context) async {
    int batteryLevel = await _battery.batteryLevel;
    if (batteryLevel <= 100) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Battery Status'),
            actions: [
              BatteryIndicator(battery: _battery),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {}
  }

  final User? user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;
  Color _statusColor = Colors.green;

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

  static const List<String> _pageTitles = [
    'Updates',
    'Distress',
    'History',
    'Profile Details',
  ];

  Future<void> getCurrentLocationAndSave() async {
    print("Current Location loading...");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userPosition = position;
    // checkFloodConditions(
    //     latitude: '${position.latitude}', longitude: '${position.longitude}');
    currentloc = '${position.latitude}, ${position.longitude}';
    print('Current Location: $currentloc');
    setState(() {});
  }

  String deobfuscate_Mask_Aadhar(String obfuscatedAadhar) {
    String base64Encoded = obfuscatedAadhar.split('').reversed.join('');
    String deobfuscated = utf8.decode(base64.decode(base64Encoded));
    return maskAadhar(deobfuscated);
  }

  String maskAadhar(String aadharNumber) {
    // Ensure the Aadhar number is exactly 12 digits long
    if (aadharNumber.length == 12) {
      // Mask all but the last 3 digits
      return aadharNumber.replaceRange(0, 9, '*' * 9);
    } else {
      throw ArgumentError('Aadhar number must be 12 digits long');
    }
  }

  Widget _buildProfileDetails() {
    return Center(
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text("User not found");
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          String location = data['location'];

          return FutureBuilder<String>(
            future: getLocation(location),
            builder:
                (BuildContext context, AsyncSnapshot<String> locationSnapshot) {
              if (locationSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (locationSnapshot.hasError) {
                return Text("Error fetching location");
              }

              String humanReadableLocation =
                  locationSnapshot.data ?? 'Unknown location';

              return profilecard(
                  data['name'],
                  deobfuscate_Mask_Aadhar(data['adhar']),
                  data['people'].toString(),
                  humanReadableLocation,
                  getCurrentLocationAndSave,
                  data['primaryphno'],
                  data['secondaryphno']);
            },
          );
        },
      ),
    );
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

  Widget _buildUpdates() {
    return StreamBuilder<QuerySnapshot>(
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
            child: Text("Updates are'nt available right Now."),
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
        // );
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
            // print('filteredUpdates.length = ${filteredUpdates.length}');
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
    );
  }

  Widget _buildHistory() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('distress')
          .where('userID', isEqualTo: user!.uid)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong", style: TextStyle(fontSize: 20)),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
            "No distress signals found",
            style: TextStyle(fontSize: 20),
          ));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return Historytile(data['type'].toString().toUpperCase(),
                data['time'].toDate().toString().substring(0, 16));
          },
        );
      },
    );
  }

  Future<void> addLocationFieldToDocuments() async {
    await getCurrentLocationAndSave();
    List<String> parts = currentloc.split(',');
    String lat = parts[0].trim();
    String long = parts[1].trim();
    bool? isFlooded =
        await checkFloodConditions(latitude: lat, longitude: long);
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      CollectionReference distressCollection = firestore.collection('distress');
      QuerySnapshot querySnapshot = await distressCollection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        String docId = doc.id;
        await distressCollection.doc(docId).update({
          'isFlooded': isFlooded,
          'location': currentloc,
        });
      }

      print('Successfully added isFlooded field to all documents.');
    } catch (e) {
      print('Error adding location field: $e');
    }
  }

  void _addToDistressTable(String type) async {
    await getCurrentLocationAndSave();
    // addLocationFieldToDocuments();
    List<String> parts = currentloc.split(',');
    String lat = parts[0].trim();
    String long = parts[1].trim();
    bool? isFlooded =
        await checkFloodConditions(latitude: lat, longitude: long);
    print(
        'IS FLOODED : ${checkFloodConditions(latitude: lat, longitude: long)}');

    FirebaseFirestore.instance.collection('distress').add({
      'userID': user!.uid,
      'type': type,
      'time': DateTime.now(),
      'location': await currentloc,
      'isFlooded': isFlooded
    });
  }

  Widget _buildDistress() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          distressTile(
              "I am safe but I need food supply", Icons.food_bank_rounded, () {
            _showConfirmationDialog("food");
          }, Colors.green),
          SizedBox(height: 40),
          distressTile(
              "I need Medical Assistance", Icons.local_hospital_rounded, () {
            _showConfirmationDialog("Medical");
          }, Colors.blueAccent),
          SizedBox(height: 40),
          distressTile("I am at danger, Come and Save me", Icons.sos_rounded,
              () {
            _showConfirmationDialog("sos");
          }, Colors.red),
        ],
      ),
    );
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
                _addToDistressTable(type);
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

  Widget _buildPage(int index) {
    switch (index) {
      case 3:
        return _buildProfileDetails();
      case 0:
        return _buildUpdates();
      case 1:
        return _buildDistress();
      case 2:
        return _buildHistory();
      default:
        return Container();
    }
  }

  @override
  void initState() {
    _showBatteryAlert(context);
    super.initState();
    getCurrentLocationAndSave();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DisasterContactsApp()));
              },
              child: Icon(Icons.call),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => DialogFlow()));
            },
            child: Icon(Icons.chat_rounded),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(
          _pageTitles[_selectedIndex],
          style: appbar_Tstyle,
        ),
        backgroundColor: appblue,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => NewsPage()));
              },
              icon: Icon(Icons.newspaper_sharp)),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Insurancepage()));
              },
              icon: Icon(Icons.cases_rounded)),
          IconButton(
              onPressed: () {
                _showBatteryAlert(context);
              },
              icon: Icon(
                Icons.battery_alert_sharp,
                color: Colors.white,
              )),
          PopupMenuButton<int>(
            color: Colors.white,
            onSelected: (item) => _onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 6, child: Text('Inconveniences')),
              PopupMenuItem<int>(value: 8, child: Text('Nearby Help Stations')),
              PopupMenuItem<int>(value: 7, child: Text('Provisions')),
              PopupMenuItem<int>(value: 4, child: Text('Show on Map')),
              PopupMenuItem<int>(value: 0, child: Text('Go Offline')),
              PopupMenuItem<int>(value: 1, child: Text('Rescue Others')),
              PopupMenuItem<int>(value: 2, child: Text('Buy Products')),
              PopupMenuItem<int>(value: 5, child: Text('Disaster Guide')),
              PopupMenuItem<int>(value: 9, child: Text('LeaderBoard')),
              PopupMenuItem<int>(value: 3, child: Text('Logout')),
            ],
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: appblue,
        backgroundColor: Colors.black12,
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Distress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Switch Mode'),
              content: Text('Are you sure you want to switch to Offline Mode?'),
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
                            builder: (BuildContext context) => UserOffline()));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Switching to Offline Mode'),
                      ),
                    );
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Rescue()));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Buy()));
        break;
      case 3:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Register()));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GoogleMapScreen(
                  lat: 0,
                  long: 0,
                )));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DisasterInfoPage(
                  disasters: disasters,
                )));
        break;
      case 6:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MyProblemsPage()));
        break;
      case 7:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ProvisionListPage()));
      case 8:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => placeScreen1()));
      case 9:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LeaderboardPage()));
    }
  }
}
