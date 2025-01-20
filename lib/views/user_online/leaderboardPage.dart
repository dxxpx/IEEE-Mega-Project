import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Uicomponents.dart';
import 'package:share_plus/share_plus.dart';

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard', style: appbar_Tstyle),
        backgroundColor: appblue,
        iconTheme: backButton(color: Colors.white),
      ),
      body: LeaderboardList(),
    );
  }
}

class LeaderboardList extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<List<Map<String, dynamic>>> _fetchLeaderboardData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .orderBy('score', descending: true) // Order by score descending
        .get();
    return querySnapshot.docs.map((doc) {
      return {
        'name': doc['name'],
        'score': doc['score'],
        'userId': doc['userId'],
      };
    }).toList();
  }

  // Dummy data
  final List<Map<String, dynamic>> leaderboardData = [
    {'name': 'Soniya V', 'score': 100},
    {'name': 'Brahadeesh', 'score': 95},
    {'name': 'Pranav Aravindhan', 'score': 90},
    {'name': 'Deepiga Dharshini', 'score': 85},
    {'name': 'Ajitha B', 'score': 80},
    {'name': 'Tom', 'score': 75},
    {'name': 'John', 'score': 70},
    {'name': 'Jack', 'score': 65},
    {'name': 'Rose', 'score': 60},
    {'name': 'Leonardo', 'score': 55},
  ];

  Color _getTopPlayerColor(int index) {
    if (index == 0) return Colors.yellowAccent;
    if (index == 1) return Colors.grey;
    if (index == 2) return Colors.brown;
    return Colors.transparent;
  }

  String getNumberWithSuffix(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  Future<void> share({required int index}) async {
    final suffix = getNumberWithSuffix(index + 1);
    final result = await Share.share(
        'Heyy !! I\'m on $suffix Place For Donating to the Disaster affected Victims, Do your Part too !!');

    if (result.status == ShareResultStatus.success) {
      print(
          '\"Heyy !! I\'m on $suffix Place For Donating to Disaster affected Victims, Do your Part too !!\" is Shared');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchLeaderboardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final leaderboardData = snapshot.data ?? [];
        final currentUserIndex = leaderboardData
            .indexWhere((data) => data['userId'] == currentUserId);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: leaderboardData.length,
                itemBuilder: (context, index) {
                  final data = leaderboardData[index];
                  if (index == 0 || index == 1 || index == 2) {
                    return TopPlayerTile(
                      rank: index + 1,
                      name: data['name'],
                      score: data['score'],
                      color: _getTopPlayerColor(index),
                      icon: Icons.emoji_events,
                      isCurrentUser: data['userId'] == currentUserId,
                      index: index,
                    );
                  } else {
                    return StandardPlayerTile(
                      rank: index + 1,
                      name: data['name'],
                      score: data['score'],
                      isCurrentUser: data['userId'] == currentUserId,
                      index: index,
                    );
                  }
                },
              ),
            ),
            if (currentUserIndex != -1)
              Container(
                color: Colors.blueGrey[50],
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    leaderboardData[currentUserIndex]['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${leaderboardData[currentUserIndex]['score']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            // Implement sharing functionality
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class TopPlayerTile extends StatelessWidget {
  final int rank;
  final String name;
  final int score;
  final Color color;
  final int index;
  final bool isCurrentUser;
  final IconData icon;

  TopPlayerTile(
      {required this.rank,
      required this.name,
      required this.score,
      required this.color,
      required this.icon,
      required this.index,
      required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.2),
      child: Container(
        padding: EdgeInsets.all(5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          title: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$score',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(width: 20),
                if (isCurrentUser)
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      LeaderboardList().share(index: index);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StandardPlayerTile extends StatelessWidget {
  final int rank;
  final String name;
  final int index;
  final int score;
  final bool isCurrentUser;

  StandardPlayerTile(
      {required this.rank,
      required this.name,
      required this.score,
      required this.index,
      required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: ListTile(
        leading: Text(
          '$rank',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        title: Text(name),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              Text('$score'),
              SizedBox(width: 20),
              if (isCurrentUser)
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () async {
                    LeaderboardList().share(index: index);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
