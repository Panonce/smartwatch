import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_watch/screens/notification/notification.dart';

class Countdown extends StatefulWidget{

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown>{

  /// variables
  int timeLeft = 5;


  /// timer countdown method
  void _startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if(timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        setState(() {
          timer.cancel(
            
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('NOTIFYING VOLUNTEERS/\LAW ENFORCEMENT',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w800,
              ),
            ),
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.deepOrange.shade200,
              ),
            ),
            Text(timeLeft.toString(),
              style: TextStyle(fontSize: 70),
            ),
            MaterialButton(
              onPressed: _startCountdown,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.close_rounded),
              )
            ),
          ],
        ),
      ),
    );
  }

}

