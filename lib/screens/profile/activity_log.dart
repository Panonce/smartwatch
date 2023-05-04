import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLogScreen extends StatefulWidget {
  const ActivityLogScreen({Key? key}) : super(key: key);

  @override
  _ActivityLogScreenState createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  get user => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Log'),
        centerTitle: true,
        backgroundColor: Colors.brown[300],
        elevation: 10,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('activityLogs').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final activityLogs = snapshot.data!.docs.map((doc) => ActivityLog.fromJson(user.docs())).toList();
          return ListView.builder(
            itemCount: activityLogs.length,
            itemBuilder: (context, index) {
              final activityLog = activityLogs[index];
              return ListTile(
                title: Text(activityLog.user),
                subtitle: Text(activityLog.activity),
                trailing: Text(activityLog.dateTime.toString()),
              );
            },
          );
        },
      ),
    );
  }
}

class ActivityLog {
  String user;
  String activity;
  DateTime dateTime;

  ActivityLog({
    required this.user,
    required this.activity,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
    'user': user,
    'activity': activity,
    'dateTime': dateTime.toIso8601String(),
  };

  factory ActivityLog.fromJson(Map<String, dynamic> json) => ActivityLog(
    user: json['user'],
    activity: json['activity'],
    dateTime: DateTime.parse(json['dateTime']),
  );
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: ActivityLogScreen(),
  ));
}


  


