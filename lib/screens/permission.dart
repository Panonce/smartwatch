import 'package:flutter/material.dart';
import 'package:smart_watch/screens/home.dart';

class Permission extends StatefulWidget {
  const Permission({Key? key}) :super(key: key);

  @override
  State<Permission> createState() => _PermissionState();
}

class _PermissionState extends State<Permission> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
            children: <Widget>[
              SizedBox(height: 100),

              //title
              Padding(
                padding: EdgeInsets.all(20.0),
                child:
                Text(
                  'This application requires the following permissions:',
                  style: TextStyle(fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange[200]
                  ),
                ),
              ),
              SizedBox(height: 30),

              //camera
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                child:
                  Row(
                  children: [
                    Icon(
                      Icons.camera_enhance_outlined,
                      size: 50.0,
                      color: Colors.deepOrange[200],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text(
                        'Camera',
                      style: TextStyle(fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                      Text(
                        '                Take pictures or videos',
                        style: TextStyle(fontSize: 12.0,
                          wordSpacing: 3.0,
                          color: Colors.white,
                      ),
                      ),
                    ]
                    ),
                  ],
                ),
              ),

              //microphone
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                child:
                Row(
                  children: [
                    Icon(
                      Icons.mic_none_rounded,
                      size: 50.0,
                      color: Colors.deepOrange[200],
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '       Microphone',
                            style: TextStyle(fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            'Record voice',
                            style: TextStyle(fontSize: 12.0,
                              wordSpacing: 3.0,
                              color: Colors.white,
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
              ),

              //location
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                child:
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 50.0,
                      color: Colors.deepOrange[200],
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '       Location',
                            style: TextStyle(fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            '       Turn on GPS',
                            style: TextStyle(fontSize: 12.0,
                              wordSpacing: 3.0,
                              color: Colors.white,
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
              ),

              //bluetooth
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                child:
                Row(
                  children: [
                    Icon(
                      Icons.bluetooth_connected_outlined,
                      size: 50.0,
                      color: Colors.deepOrange[200],
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '       Bluetooth',
                            style: TextStyle(fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            '            Turn on bluetooth',
                            style: TextStyle(fontSize: 12.0,
                              wordSpacing: 3.0,
                              color: Colors.white,
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
              ),

              //data
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                child:
                Row(
                  children: [
                    Icon(
                      Icons.four_g_mobiledata,
                      size: 50.0,
                      color: Colors.deepOrange[200],
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '       Mobile Data',
                            style: TextStyle(fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            '         Turn on mobile data',
                            style: TextStyle(fontSize: 12.0,
                              wordSpacing: 3.0,
                              color: Colors.white,
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
              ),

              //accept button
              SizedBox(height: 50),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.orangeAccent),
                ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),);
                  },
                  child: const Text('Accept')
              ),


            ]
        ),
      ),
    );
  }
}