import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_watch/screens/notification/notif_decline.dart';



class Notif extends StatefulWidget {

  const Notif( {Key? key}) :super(key: key);

  @override
  State<Notif > createState() => _NotificationState();
}
class _NotificationState extends State<Notif> {
  //Firebase
  final currentUser = FirebaseAuth.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;


  //Notification
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  //location variables
  //location variables
  late GoogleMapController _controller;
  Set<Marker> _markers = {};

  double? lat;
  double? lang;

  Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    getLoc();
  }

  Future<void> getLoc() async {
    FirebaseFirestore.instance.collection('location').orderBy('timestamp', descending: true)
        .limit(1)
        .get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        print("Documents found");
        var doc = querySnapshot.docs.first;
        print(doc.data());
        lat = doc['latitude'];
        lang = doc['longitude'];
        var uid = doc['uid'];
        var timestamp = doc['timestamp'];
        print("Latitude: $lat Longitude: $lang, uid: $uid, timestamp: $timestamp");

        setState(() {
          _markers = {Marker(
            markerId: MarkerId('1'),
            position: LatLng(lat ?? 0, lang ?? 0),
          )};
        });

        // Animate the camera to center on the marker
        _controller.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(lat ?? 0, lang ?? 0), 60),
        );

      } else {
        print("No documents found");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 150,
      width: 50,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          notif_content(),
          SizedBox(height: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat ?? 0, lang ?? 0),
                  zoom: 15,
                ),
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          buttons(),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  void _onMarkerPositionChanged(MarkerId markerId, LatLng newPosition) {
    // Update the position of the marker
    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId('1'),
          position: LatLng(lat ?? 0, lang ?? 0),
          draggable: true,
          onDragEnd: (LatLng newPosition) {
            _onMarkerPositionChanged(MarkerId('1'), newPosition);
          },
        ),
      };
    });

    // Move the camera to follow the marker
    final CameraPosition newPositionCamera = CameraPosition(
      target: newPosition,
      zoom: 30,
    );
    _controller.animateCamera(CameraUpdate.newCameraPosition(newPositionCamera));
  }

  /// UI FOR NOTIFICATION CONTENTS
  Widget notif_content() {
    return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 10),
              notif_text(),
            SizedBox(height: 10),
              notif_hrm(),
              notif_datetime(),
          ],
        );
  }

  Widget notif_text() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notification_important_sharp,size: 30, color: Colors.deepOrange[200]),
          SizedBox(width: 5),
          Column(
            children: [
              Text(
                'Alert',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange[200],
                ),
              ),
              SizedBox(height: 10,),
              Text(
                "I'm in danger! ",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.deepOrange[200]),
              ),
            ],
          ),
          SizedBox(width: 5),
          Icon(Icons.notification_important_sharp, size: 30, color: Colors.deepOrange[200]),
        ],
      ),
    );
  }

  Widget notif_hrm() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('hrm')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final userDocs = snapshot.data!.docs;
        final hrmValue = userDocs.first['hrm'].toString();
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Heart Rate: ',
                style: TextStyle(fontSize: 20.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange[200]),
              ),
              Text(hrmValue,
                style: TextStyle(fontSize: 20.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange[200]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget notif_datetime() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('hrm')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final userDocs = snapshot.data!.docs;
        return Container(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: userDocs.length,
            itemBuilder: (ctx, index) =>
                Text(DateFormat.yMMMMd().add_jm().format(
                    userDocs[index]['createdAt'].toDate()),
                  style: TextStyle(fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange[200]),
                  textAlign: TextAlign.center,
                ),
          ),
        );
      },
    );
  }

  Widget buttons() {
    return Decline();
  }
}


