import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';

/// -- BLUETOOTH PERMISSION

class PermPage3 extends StatefulWidget {
  @override
  _PermPage3 createState() => _PermPage3();
}

class _PermPage3 extends State<PermPage3> {
  Future<void> enableBT() async {
    BluetoothEnable.enableBluetooth.then((value) {
      print(value);
    });
  }

  Future<void> customEnableBT(BuildContext context) async {
    String dialogTitle = "Hey! Please give me permission to use Bluetooth!";
    bool displayDialogContent = true;
    String dialogContent = "This app requires Bluetooth to connect to device.";
    //or
    // bool displayDialogContent = false;
    // String dialogContent = "";
    String cancelBtnText = "Nope";
    String acceptBtnText = "Sure";
    double dialogRadius = 10.0;
    bool barrierDismissible = true; //

    BluetoothEnable.customBluetoothRequest(
        context,
        dialogTitle,
        displayDialogContent,
        dialogContent,
        cancelBtnText,
        acceptBtnText,
        dialogRadius,
        barrierDismissible)
        .then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Bluetooth Permission',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 25,
                ),
              ),
              Lottie.asset('assets/bluetooth.json'),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: (() {
                  enableBT();
                }),
                child: Text('Request Bluetooth Access'),
              ),
              SizedBox(height: 10.0)
            ],
          ),
        ),
      );
  }
}
