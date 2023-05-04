import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_watch/authentication/GoogleAuth.dart';
import 'package:smart_watch/screens/login.dart';
import 'package:smart_watch/screens/profile/activity_log.dart';
import 'package:smart_watch/screens/profile/profile_about.dart';
import 'package:smart_watch/widgets/profile_menu.dart';
import 'package:smart_watch/screens/profile/settings/settings_page.dart';
import 'package:smart_watch/widgets/profile_update.dart';
import 'package:smart_watch/screens/profile/profile.dart';
import 'package:url_launcher/url_launcher.dart';


class ProfileHome extends StatefulWidget {
  const ProfileHome({Key? key}) : super(key: key);

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {

  final currentUser = FirebaseAuth.instance;


  void updateProfile(String email, String password, String name, bool isLogIn,
      Role role, BuildContext ctx, String hr) {
    // implementation of the update function
  }

  late void Function(String email, String password, String name, bool isLogIn, Role role, BuildContext ctx, String hr) updateFn;

  @override
  void initState() {
    super.initState();
    updateFn = updateProfile;
  }


  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery
        .of(context)
        .platformBrightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text(
          "Menu",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[200],
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// -- PROFILE PICTURE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                          FirebaseAuth.instance.currentUser!.photoURL ??
                              'https://cdn-icons-png.flaticon.com/512/219/219983.png'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              nameDisplay(),
              //roleDisplay(),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: "Profile", icon: Icons.person, onPress: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  }),
              ProfileMenuWidget(
                  title: "Settings", icon: Icons.settings_rounded, onPress: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              }),
              ProfileMenuWidget(title: "Activity Log",
                  icon: Icons.my_library_books_outlined,
                  onPress: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityLogScreen()),
                    );
                  }),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title: "Information", icon: Icons.info_outline_rounded, onPress: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileAbout()),
                );
              }),
              ProfileMenuWidget(title: "Contact Us", icon: Icons.phone, onPress: () {
                launch('https://forms.gle/KMZrzcubqy3iHPZSA');
                  }),
              ProfileMenuWidget(title: "Send Feedback", icon: Icons.feedback_rounded, onPress: () {
                launch('https://forms.gle/esTDYY8DTqhp1DURA');
              }),
              const SizedBox(height: 20),
              const Divider(),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: Icons.logout_rounded,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    final provider = Provider.of<GoogleAuth>(
                        context, listen: false);
                    provider.logout();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  /// -- NAME DISPLAY PROPERTIES
  Widget nameDisplay() =>
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .where("uid", isEqualTo: currentUser.currentUser?.uid)
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
          return Center(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userDocs.first['name'] ??
                        FirebaseAuth.instance.currentUser?.displayName ?? '',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('|',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.amber[600],
                    ),
                  ),
                  // Text(
                  //   '|',
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.bold, fontSize: 16
                  //   ),
                  // ),
                  const SizedBox(width: 10),
                  Text(
                    userDocs.first['role'] ?? '',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );





  Widget emailDisplay() =>
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .where("uid", isEqualTo: currentUser.currentUser?.uid)
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
            padding: EdgeInsets.all(15),
            child: Text(
              userDocs.first['email'] ??
                  FirebaseAuth.instance.currentUser?.displayName ?? '',


            ),
          );
        },
      );

  // Widget roleDisplay() =>
  //     StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance.collection('users')
  //           .where("uid", isEqualTo: currentUser.currentUser?.uid)
  //           .snapshots(),
  //       builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
  //         if (snapshot.hasError) {
  //           return Text('Something went wrong');
  //         }
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //         final userDocs = snapshot.data!.docs;
  //         return Container(
  //           //padding: EdgeInsets.all(15),
  //           child: Text(
  //             userDocs.first['role'] ??
  //                 FirebaseAuth.instance.currentUser?.displayName ?? '',
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold, fontSize: 18 )
  //
  //           ),
  //         );
  //       },
  //     );

  Widget hrDisplay() =>
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .where("uid", isEqualTo: currentUser.currentUser?.uid)
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
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(
                    Icons.accessibility_new_rounded,
                    color: Colors.deepOrange[200]
                ),
                SizedBox(width: 10),
                Text(
                  userDocs.first['hr'] ?? 'NA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      );


  Widget addressDisplay() =>
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .where("uid", isEqualTo: currentUser.currentUser?.uid)
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
            padding: EdgeInsets.all(15),
            child: Text(
              userDocs.isNotEmpty ? userDocs[0]['address'] ?? 'N/A' : 'N/A',
            ),
          );
        },
      );

  Widget numberDisplay() =>
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .where("uid", isEqualTo: currentUser.currentUser?.uid)
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
            padding: EdgeInsets.all(15),
            child: Text(
              userDocs.isNotEmpty ? userDocs[0]['number'] ?? 'N/A' : 'N/A',
            ),
          );
        },
      );
}
