import 'package:battery/battery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hackfest/services/service_imp.dart';
import 'package:hackfest/views/Uicomponents.dart';
import 'package:hackfest/views/admin_online/placeScreen.dart';
import 'package:hackfest/views/dialog_flow.dart';
import 'package:hackfest/views/disaster.dart';
import 'package:hackfest/views/emergency_contact.dart';
import 'package:hackfest/views/user_offline/user_offline.dart';
import 'package:hackfest/views/user_online/battery.dart';
import 'package:hackfest/views/user_online/buy.dart';
import 'package:hackfest/views/user_online/leaderboardPage.dart';
import 'package:hackfest/views/user_online/maps_markers.dart';
import 'package:hackfest/views/user_online/my_problems.dart';
import 'package:hackfest/views/user_online/register_page.dart';
import 'package:hackfest/views/user_online/rescue.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../admin_online/add_provisions.dart';
import 'package:hackfest/views/admin_online/showProvisions.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State with SingleTickerProviderStateMixin {
  final Battery _battery = Battery();

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
  Color _statusColor = Colors.green; // Default color is red
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _getCurrentLocationAndSave() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String location = '${position.latitude}, ${position.longitude}';
    Service_Imp().storelocation(location);
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'location': location,
      });
      setState(() {
        // Update the UI with the new location
      });
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
                  data['adhar'],
                  data['people'].toString(),
                  humanReadableLocation,
                  _getCurrentLocationAndSave,
                  data['primaryphno'],
                  data['secondaryphno']);
            },
          );
        },
      ),
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
            child: Text("No updates available."),
          );
        }

        final updates = snapshot.data!.docs;

        return ListView.builder(
          itemCount: updates.length,
          itemBuilder: (BuildContext context, int index) {
            final update = updates[index];
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

  void _addToDistressTable(String type) {
    FirebaseFirestore.instance.collection('distress').add({
      'userID': user!.uid,
      'type': type,
      'time': DateTime.now(),
      // Add more fields as needed
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
    // TODO: implement initState
    _showBatteryAlert(context);
    super.initState();
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
        unselectedItemColor: Colors.grey, //
        selectedItemColor: appblue, // <-- add this

        backgroundColor: Colors.black12,
        currentIndex: _selectedIndex,
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
