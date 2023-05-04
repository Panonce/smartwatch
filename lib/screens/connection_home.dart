import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:smart_watch/screens/notification/alert_notif.dart';
import 'package:smart_watch/screens/notification/countdown.dart';
import 'package:smart_watch/screens/notification/notification.dart';
import 'package:microphone/microphone.dart';

import 'notification/send_notif.dart';


Uuid _UART_UUID = Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
Uuid _UART_RX   = Uuid.parse("6E400002-B5A3-F393-E0A9-E50E24DCCA9E");
Uuid _UART_TX   = Uuid.parse("6E400003-B5A3-F393-E0A9-E50E24DCCA9E");

class Connection extends StatefulWidget {
  const Connection({Key? key}) :super(key: key);

  @override
  State<Connection> createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {

  final flutterReactiveBle = FlutterReactiveBle();

  int hrm = 0;

  void _sendHRM() async {
    final user = await FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection('hrm').add({
      'hrm': hrm,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
    });
  }


    void _sendloc() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
      final user = await FirebaseAuth.instance.currentUser!;
      FirebaseFirestore.instance.collection('location').add({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': Timestamp.now(),
        'uid': user.uid,
      });
    }

    List<DiscoveredDevice> _foundBleUARTDevices = [];
    late StreamSubscription<DiscoveredDevice> _scanStream;
    late Stream<ConnectionStateUpdate> _currentConnectionStream;
    late StreamSubscription<ConnectionStateUpdate> _connection;
    late QualifiedCharacteristic _txCharacteristic;
    late QualifiedCharacteristic _rxCharacteristic;
    late Stream<List<int>> _receivedDataStream;
    late TextEditingController _dataToSendText;
    bool _scanning = false;
    bool _connected = false;
    String _logTexts = "";

    String hrmst = "";
    List<String> _receivedData = [];


    void initState() {
      super.initState();
      _dataToSendText = TextEditingController();
    }

    void refreshScreen() {
      setState(() {});
    }

    /// SMARTWATCH CONNECTION TUTORIAL
    void _showConnectTutDialog () {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text('Smartwatch Connection Guide'),
          //shadowColor: Colors.black45,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('1. Press the "PLAY" button to find your smartwatch.'),
              Text('2. Wait for your smartwatch to be detected.'),
              Text('3. Once your smartwatch has been found, press the "STOP" button.'),
              Text('4. Press on your smartwatch in the "Device Found" box'),
              Text('5. Your smartwatch has successfully connected to Ligtas!'),
              const SizedBox(height: 20),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('CLOSE'),
                color: Colors.red[300],
              ),
            ],
          ),
        );
      });
    }

    /// -- MICROPHONE RECORDING (not working)
  /*bool _shouldStartRecording = false;

  Future<void> _startRecording() async {
    try {
      String tempDirPath = (await getTemporaryDirectory()).path;
      String filePath = '$tempDirPath/recording.wav';

      if (_shouldStartRecording) {
        await _recorder.start(filePath, audioSource: AudioSource.MIC);
        setState(() {
          _isRecording = true;
        });
        await Future.delayed(Duration(seconds: 5));
        _stopRecording(filePath);
      }
    } catch (e) {
      print('Error: $e');
    }
  }*/

    void _sendData() async {
      await flutterReactiveBle.writeCharacteristicWithResponse(
          _rxCharacteristic, value: _dataToSendText.text.codeUnits);
    }

    void onNewReceivedData(List<int> data) {
      _receivedData.add("${String.fromCharCodes(data).substring(4)}");

      if (String.fromCharCodes(data).substring(4, 6) == "SS") {
        Timer(Duration(seconds: 10), () {
          showDialog(context: context, builder: (builder) {
            return PushNotificationWidget(message: "I need help");;
          });
        });
      }
      if (String.fromCharCodes(data).substring(4, 6) == "L")  {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Countdown()),
        );
      }

      hrmst = String.fromCharCodes(data).replaceAll(new RegExp(r'[^0-9]'), '');
      hrm = int.parse(hrmst);
      _sendHRM();
      _sendloc();
      refreshScreen();
    }

    void _disconnect() async {
      await _connection.cancel();
      _connected = false;
      refreshScreen();
    }

    void _stopScan() async {
      await _scanStream.cancel();
      _scanning = false;
      refreshScreen();
    }

    /// --- BLUETOOTH PERMISSION
    Future<void> showNoPermissionDialog() async =>
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) =>
              AlertDialog(
                title: const Text('No location permission '),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      const Text('No location permission granted.'),
                      const Text(
                          'Location permission is required for BLE to function.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Acknowledge'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
        );

    /// --- SCANNING FOR BLE DEVICES
    void _startScan() async {
      bool goForIt = false;
      PermissionStatus permission;
      if (Platform.isAndroid) {
        permission = await LocationPermissions().requestPermissions();
        if (permission == PermissionStatus.granted)
          goForIt = true;
      } else if (Platform.isIOS) {
        goForIt = true;
      }
      if (goForIt) { //TODO replace True with permission == PermissionStatus.granted is for IOS test
        _foundBleUARTDevices = [];
        _scanning = true;
        refreshScreen();
        _scanStream =
            flutterReactiveBle.scanForDevices(withServices: [_UART_UUID])
                .listen((device) {
              if (_foundBleUARTDevices.every((element) =>
              element.id != device.id)) {
                _foundBleUARTDevices.add(device);
                refreshScreen();
              }
            }, onError: (Object error) {
              _logTexts =
              "${_logTexts}ERROR while scanning:$error \n";
              refreshScreen();
            }
            );
      }
      else {
        await showNoPermissionDialog();
      }
    }

    /// --- WHEN BLE DEVICE IS CONNECTED
    void onConnectDevice(index) {
      _currentConnectionStream = flutterReactiveBle.connectToAdvertisingDevice(
        id: _foundBleUARTDevices[index].id,
        prescanDuration: Duration(seconds: 1),
        withServices: [_UART_UUID, _UART_RX, _UART_TX],
      );
      _logTexts = "";
      refreshScreen();
      _connection = _currentConnectionStream.listen((event) {
        var id = event.deviceId.toString();
        switch (event.connectionState) {
          case DeviceConnectionState.connecting:
            {
              _logTexts = "${_logTexts}Connecting to $id\n";
              break;
            }
          case DeviceConnectionState.connected:
            {
              _connected = true;
              _logTexts = "${_logTexts}Connected to $id\n";
              _receivedData = [];
              _txCharacteristic = QualifiedCharacteristic(serviceId: _UART_UUID,
                  characteristicId: _UART_TX,
                  deviceId: event.deviceId);
              _receivedDataStream =
                  flutterReactiveBle.subscribeToCharacteristic(
                      _txCharacteristic);
              _receivedDataStream.listen((data) {
                onNewReceivedData(data);
              }, onError: (dynamic error) {
                _logTexts = "${_logTexts}Error:$error$id\n";
              });
              _rxCharacteristic = QualifiedCharacteristic(serviceId: _UART_UUID,
                  characteristicId: _UART_RX,
                  deviceId: event.deviceId);
              break;
            }
          case DeviceConnectionState.disconnecting:
            {
              _connected = false;
              _logTexts = "${_logTexts}Disconnecting from $id\n";
              break;
            }
          case DeviceConnectionState.disconnected:
            {
              _logTexts = "${_logTexts}Disconnected from $id\n";
              break;
            }
        }
        refreshScreen();
      });
    }

    @override
    Widget build(BuildContext context) =>
        Scaffold(
          extendBodyBehindAppBar: false,
          appBar: AppBar(
            title: Text(
              "Bluetooth",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.brown[300],
            elevation: 10,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30),
                Text(
                  'Connect your smartwatch',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Colors.brown[600],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showConnectTutDialog();
                  },
                  child: Text(
                      'How to connect your smartwatch?',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black45
                    ),
                  ),
                ),
                SizedBox(height: 20),
                const Text("Devices found:"),
                Container(
                    margin: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.deepOrange,
                            width: 2
                        )
                    ),
                    height: 100,
                    child: ListView.builder(
                        itemCount: _foundBleUARTDevices.length,
                        itemBuilder: (context, index) =>
                            Card(
                                child: ListTile(
                                  dense: true,
                                  enabled: !((!_connected && _scanning) ||
                                      (!_scanning && _connected)),
                                  trailing: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      (!_connected && _scanning) ||
                                          (!_scanning && _connected)
                                          ? () {}
                                          : onConnectDevice(index);
                                    },
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.bluetooth_connected_rounded),
                                    ),
                                  ),
                                  subtitle: Text(
                                      _foundBleUARTDevices[index].id),
                                  title: Text(
                                      "$index: ${_foundBleUARTDevices[index]
                                          .name}"),
                                ))
                    )
                ),
                SizedBox(height: 40),
                const Text("Status messages:"),
                Container(
                    margin: const EdgeInsets.all(3.0),
                    width: 1400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.deepOrange,
                            width: 2
                        )
                    ),
                    height: 90,
                    child: Scrollbar(

                        child: SingleChildScrollView(
                            child: Text(_logTexts)
                        )
                    )
                ),
                SizedBox(height: 40,),
                Text("Received data:"),
                Container(
                  margin: const EdgeInsets.all(3.0),
                  width: 1400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.deepOrange,
                          width: 2
                      )
                  ),
                  height: 90,
                  child: Scrollbar(
                      child: SingleChildScrollView(
                          child: Text(_receivedData.join(""))
                      )
                  ),
                ),
              ],
            ),
          ),

          persistentFooterButtons: [
            Container(
              height: 35,
              child: Column(
                children: [
                  if (_scanning) const Text("Scanning: Scanning") else
                    const Text("Scanning: Idle"),
                  if (_connected) const Text("Connected") else
                    const Text("disconnected."),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: !_scanning && !_connected ? _startScan : () {},
              child: Icon(
                Icons.play_arrow,
                color: !_scanning && !_connected
                    ? Colors.deepOrange[200]
                    : Colors.white,
              ),
            ),
            ElevatedButton(
                onPressed: _scanning ? _stopScan : () {},
                child: Icon(
                  Icons.stop,
                  color: _scanning ? Colors.deepOrange[200] : Colors.white,
                )
            ),
            ElevatedButton(
                onPressed: _connected ? _disconnect : () {},
                child: Icon(
                  Icons.cancel,
                  color: _connected ? Colors.deepOrange[200] : Colors.white,
                )
            )
          ],
        );
  }



