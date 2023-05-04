import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotificationWidget extends StatefulWidget {
  final String message;

  const PushNotificationWidget({required this.message});

  @override
  _PushNotificationWidgetState createState() => _PushNotificationWidgetState();
}

class _PushNotificationWidgetState extends State<PushNotificationWidget> {
  List<String> _playerIds = [];

  @override
  void initState() {
    super.initState();
    // initialize OneSignal
    OneSignal.shared.setAppId("0cd37918-49fe-47c5-8559-3996fea9a420");


    // get all player ids
    getAllPlayerIds().then((playerIds) {
      setState(() {
        _playerIds = playerIds;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _playerIds.isNotEmpty,
      child: FutureBuilder(
        future: sendPushNotification(_playerIds, widget.message),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error sending push notification.');
            } else {
              return Text('Push notification sent successfully.');
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

Future<List<String>> getAllPlayerIds() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('playerId')
      .get();

  final playerIds = snapshot.docs
      .map((doc) => doc.data()['playerId'].toString())
      .toList();
  print('Player IDs retrieved: $playerIds');
  return playerIds;
}

Future<void> sendPushNotification(List<String> playerIds, String message) async {
  if (playerIds.isEmpty) {
    throw Exception('Error: playerIds list is empty.');
  }

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'YjAxNjg1M2UtZTFhOC00OTg0LTk3NjAtZWFhNGMyMDJhODM5'
  };

  var request = http.Request(
      'POST',
      Uri.parse('https://onesignal.com/api/v1/notifications'));


    request.body = json.encode({
      'app_id': '0cd37918-49fe-47c5-8559-3996fea9a420',
      'template_id': '3b01a9dd-0837-4904-9658-6d9976580d4d',
      'include_player_ids': playerIds,
      'contents': {'en': message},
      'content_available': true,
      'data': {'foo': 'bar'}
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Push notification sent successfully.');
    } else {
      throw Exception('Error sending push notification.');
    }
  }
