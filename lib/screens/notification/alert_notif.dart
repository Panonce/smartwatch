import 'package:flutter/material.dart';
import 'package:smart_watch/screens/notification/notification.dart';

class Alert extends StatefulWidget {
  @override
  State<Alert> createState() => _AlertState();
}

/// alert dialog shows when alert is received
class _AlertState extends State<Alert>{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ALERT'),
      content: Text('Someone may be in danger!'),
      actions: [
        MaterialButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (builder) => Notif())
              );
            },
            child: Text('View Alert'),
          color: Colors.deepOrange.shade200,
        ),
      ],
    );
  }
}