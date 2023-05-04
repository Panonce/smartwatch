import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart';

/// -- LOCATION PERMISSION

class PermPage1 extends StatefulWidget {
  @override
  _PermPage1State createState() => _PermPage1State();
}

class _PermPage1State extends State<PermPage1> {
  late PermissionStatus _locationPermissionStatus;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final permissionStatus = await Permission.locationAlways.status;
    setState(() {
      _locationPermissionStatus = permissionStatus;
    });
  }

  Future<void> _requestLocationPermission() async {
    final permissionStatus = await Permission.locationAlways.request();
    setState(() {
      _locationPermissionStatus = permissionStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Location Permission',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 40),
            Lottie.asset('assets/location.json'),
            if(_locationPermissionStatus == PermissionStatus.denied)
              Text('Location permission is denied.'),
            if(_locationPermissionStatus == PermissionStatus.granted)
              Text('Location permission is granted.'),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
            ),
            ElevatedButton(
                onPressed: _requestLocationPermission,
                child: Text('Request Location Permission'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange[200],
                  side: BorderSide.none,
                  shape: StadiumBorder()
                ),
            ),
          ],
        ),
      ),
    );
  }
}