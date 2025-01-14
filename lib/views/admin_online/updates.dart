import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackfest/services/service_imp.dart';
import 'package:hackfest/views/admin_online/add_warning_page.dart';
import '../Uicomponents.dart';

class Updates extends StatefulWidget {
  const Updates({Key? key}) : super(key: key);

  @override
  State<Updates> createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
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
