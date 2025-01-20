import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import '../../services/service_imp.dart';
import '../Uicomponents.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class GetMessages extends StatefulWidget {
  const GetMessages({Key? key}) : super(key: key);

  @override
  State<GetMessages> createState() => _GetMessagesState();
}

class _GetMessagesState extends State<GetMessages> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Request SMS permission when the app starts
    _requestSmsPermission();
  }

  // Function to request SMS permission
  Future<void> _requestSmsPermission() async {
    if (await Permission.sms.request().isGranted) {
      // Permission is granted, query SMS messages
      _querySmsMessages();
    }
  }

  // Function to query SMS messages
  Future<void> _querySmsMessages() async {
    print("Starting to query SMS messages...");
    try {
      final messages = await _query.querySms(
        kinds: [
          SmsQueryKind.inbox,
          SmsQueryKind.sent,
        ],
        count: 10,
      );
      print("Finished querying SMS messages.");
      debugPrint('sms inbox messages: ${messages.length}');

      // Filter messages that match the distress call pattern
      final filteredMessages = messages.where((message) =>
          message.body!.contains('DISTRESS CALL\nFrom User:') &&
          message.body!.contains('Type:') &&
          message.body!.contains('Location:'));

      setState(() => _messages = filteredMessages.toList());
    } catch (e) {
      print("Error querying SMS messages: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Distress Calls', style: appbar_Tstyle),
        backgroundColor: appblue,
        iconTheme: backButton(color: Colors.white),
      ),
      body: Container(
        child: _messages.isNotEmpty
            ? _MessagesListView(
                messages: _messages,
              )
            : Center(
                child: Text(
                  'No messages to show.\n Tap refresh button...',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _querySmsMessages,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _MessagesListView extends StatelessWidget {
  const _MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int i) {
        var message = messages[i];
        String _extractValue(String message, String key, String key2) {
          int startIndex = message.indexOf(key) + key.length;
          int endIndex = message.indexOf(key2);
          if (key2 == ' ') endIndex = message.length;
          print(startIndex);
          print(endIndex);
          return message.substring(startIndex, endIndex);
        }

        String userid = _extractValue(messages[i].body!, 'From User:', 'Type');
        // Extract type
        String type = _extractValue(messages[i].body!, 'Type:', 'Location');
        // Extract location
        String location = _extractValue(messages[i].body!, 'Location:', ' ');

        print('User ID: $userid');
        print('Type: $type');
        print('Location: $location');
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(userid.trim())
              .get(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return ListTile(
                title: Text(type.toString().toUpperCase()),
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
                    title: Text(type.toString().toUpperCase()),
                    subtitle: Text('Error fetching location'),
                  );
                }

                String humanReadableLocation =
                    locationSnapshot.data ?? 'Unknown location';

                return DistressCalls(
                  type.toString().toUpperCase(),
                  userData['name'],
                  userData['people'].toString(),
                  messages[i].date.toString().substring(0, 16),
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
  }
}
