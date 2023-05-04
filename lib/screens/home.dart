import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_watch/screens/connection_home.dart';
import 'package:smart_watch/screens/location_home.dart';
import 'package:smart_watch/screens/profile_home.dart';

import '../widgets/icon_widget.dart';
import 'emergency_contact/emergency.dart';
import 'messages_home.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) :super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection('users').snapshots();
  User? user = FirebaseAuth.instance.currentUser;
  int index = 1;
  String? userRole;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      String userId = user!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            userRole = documentSnapshot.get('role');
            if (userRole == 'User') index = 2;
          });
        }
      });
    }
  }

  static const TextStyle optionStyle = TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [ChatScreen(), SizedBox(), Location(), ProfileHome()];
    } else {
      return [
        EmergencyContactList(),
        if (userRole == 'User') Connection(),
        Location(),
        ProfileHome(),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions()[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.deepPurple[200],
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(
                color: Colors.black45,
                fontSize: 14,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
          child: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: Duration(seconds: 2),
            height: 60,
            backgroundColor: Colors.deepPurple[50],
            selectedIndex: index,
            onDestinationSelected: (index) =>
                setState(() {
                  this.index = index;
                }),
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.contacts_outlined), //contact_emergency_outlined
                selectedIcon: Icon(Icons.quick_contacts_dialer), //contact_emergency
                label: 'Emergency\nContacts',
              ),
              if(userRole == 'User')
                NavigationDestination(
                  icon: Icon(Icons.bluetooth),
                  label: 'Bluetooth',
                ),
              NavigationDestination(
                icon: Icon(Icons.pin_drop_rounded),
                label: 'Location',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_rounded), //person_2_outlined
                selectedIcon: Icon(Icons.menu_open_outlined), //person_2_rounded
                label: 'Menu',
              ),
            ],
          ),
        ),
    );
  }
}