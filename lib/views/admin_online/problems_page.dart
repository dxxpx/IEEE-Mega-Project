import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hackfest/views/Uicomponents.dart';

class AllProblemsPage extends StatelessWidget {
  Future<void> _markAsRectified(String docId) async {
    await FirebaseFirestore.instance.collection('problems').doc(docId).update({
      'rectified': true,
    });
  }

  Future<void> _launchMap(String location) async {
    final Uri uri =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$location');
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Problems', style: appbar_Tstyle),
        iconTheme: backButton(color: Colors.white),
        backgroundColor: appblue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('problems').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No problems posted.'));
          }
          final problems = snapshot.data!.docs;
          return ListView.builder(
            itemCount: problems.length,
            itemBuilder: (context, index) {
              final problem = problems[index];
              return Card(
                color: Colors.blue.shade50,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      if (problem['imageUrl'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            problem['imageUrl'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Icon(Icons.image_not_supported, size: 80),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              problem['description'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              problem['location'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await _markAsRectified(problem.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Problem marked as rectified'),
                                      ),
                                    );
                                  },
                                  style: buttonStyle(),
                                  child: Text('Rectified',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    print(problem['location']);
                                    final location = problem['location']
                                        .replaceAll('Latitude: ', '')
                                        .replaceAll(', Longitude: ', ',');
                                    await _launchMap(location);
                                  },
                                  style: buttonStyle(),
                                  child: Text(
                                    'View Map',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
