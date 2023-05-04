import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

/// -- MICROPHONE PERMISSION

class PermPage2 extends StatefulWidget {
  @override
  _PermPage2 createState() => _PermPage2();
}

class _PermPage2 extends State<PermPage2> {
  late PermissionStatus _microphonePermissionStatus;

  @override
  void initState() {
    super.initState();
    _checkMicrophonePermission();
  }

  Future<void> _checkMicrophonePermission() async {
    final permissionStatus = await Permission.microphone.status;
    setState(() {
      _microphonePermissionStatus = permissionStatus;
    });
  }

  Future<void> _requestMicrophonePermission() async {
    final permissionStatus = await Permission.microphone.request();
    setState(() {
      _microphonePermissionStatus = permissionStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Microphone Permission',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 40),
            Lottie.asset('assets/microphone.json'),
            if (_microphonePermissionStatus == PermissionStatus.denied)
              Text('Microphone permission is denied.'),
            if (_microphonePermissionStatus == PermissionStatus.granted)
              Text('Microphone permission is granted.'),
            ElevatedButton(
              onPressed: _requestMicrophonePermission,
              child: Text('Request Microphone Permission'),
            ),
          ],
        ),
      ),
    );
  }
}
