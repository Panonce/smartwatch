import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

/// -- CAMERA PERMISSIONS

class PermPage4 extends StatefulWidget {
  @override
  _PermPage4 createState() => _PermPage4();
}

class _PermPage4 extends State<PermPage4> {
  late PermissionStatus _cameraPermissionStatus;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    // Request camera permission
    final permissionStatus = await Permission.camera.request();
    setState(() {
      _cameraPermissionStatus = permissionStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
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
            Lottie.asset('assets/camera.json'),
            if(_cameraPermissionStatus == PermissionStatus.denied)
              Text('Camera permission is denied.'),
            if(_cameraPermissionStatus == PermissionStatus.granted)
              Text('Camera permission is granted.'),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
            ),
            ElevatedButton(
              onPressed: requestPermission,
              child: Text('Request Camera Permission'),
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

