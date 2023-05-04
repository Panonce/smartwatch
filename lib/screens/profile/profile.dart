import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_watch/screens/login.dart';
import 'package:smart_watch/widgets/profile_update.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final currentUser = FirebaseAuth.instance;

  void updateProfile(String email, String password, String name, bool isLogIn,
      Role role, BuildContext ctx, String hr) {
// implementation of the update function
  }

  late void Function(String email, String password, String name, bool isLogIn,
      Role role, BuildContext ctx, String hr) updateFn;

  @override
  void initState() {
    super.initState();
    updateFn = updateProfile;
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title:
            Text(
              "Profile",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
        centerTitle: true,
        backgroundColor: Colors.brown[300],
        elevation: 10,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.chevron_left),
            color: Colors.white),
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
                      child: Image.network(FirebaseAuth
                              .instance.currentUser!.photoURL ??
                          'https://cdn-icons-png.flaticon.com/512/219/219983.png'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              nameDisplay(),
              //roleDisplay(),
              emailDisplay(),
              numberDisplay(),
              addressDisplay(),
              hrDisplay(),
              const SizedBox(height: 50),
              SizedBox(
                width: 200, height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (updateFn != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileUpdate(updateFn),
                        ),
                      );
                    }
                  },

                  child: const Text("EDIT PROFILE",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[300],
                      side: BorderSide.none,
                      shape: StadiumBorder()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// -- NAME DISPLAY PROPERTIES
  Widget nameDisplay() => StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
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
        padding: EdgeInsets.only(left: 40, right: 40, bottom: 25, top: 25),
        child: Row(
          children: [
            Icon(Icons.person, color: Colors.brown[600]),
            SizedBox(width: 10),
            Text(
              userDocs.first['name'] ??
                  FirebaseAuth.instance.currentUser?.displayName ??
                  '',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 10),
            const Text('|'),
            const SizedBox(width: 10),
            Text(
              userDocs.first['role'] ?? '',
              style: TextStyle( fontSize: 18 ),
            )
          ],
        ),
      );
    },
  );



  /// EMAIL DISPLAY
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
            padding: EdgeInsets.only(left: 40, right: 40, bottom: 25),
            child: Row(
              children: [
                Icon(
                  Icons.email,
                  color: Colors.brown[600]
                ),
                SizedBox(width: 10),
                Text(
                  userDocs.first['email'] ??
                      FirebaseAuth.instance.currentUser?.email ?? '',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 15

                  )
                ),
              ],
            ),
          );
        },
      );


  /// ROLE DISPLAY
  Widget roleDisplay() => StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
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
                Text('Role: '),
                Text(
                  userDocs.first['role'] ??
                      FirebaseAuth.instance.currentUser?.displayName ??
                      '',
                ),
              ],
            ),
          );
        },
      );

  /// HEART RATE DISPLAY
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
            padding: EdgeInsets.only(left: 40, right: 40, bottom: 25),
            child: Row(
              children: [
                Icon(
                    Icons.monitor_heart_outlined,
                    color: Colors.brown[600]
                ),
                SizedBox(width: 10),
                Text(
                  userDocs.first['hr'] ?? 'NA',
                  style: TextStyle( fontSize: 18 ),
                ),
              ],
            ),
          );
        },
      );


  /// ADDRESS DISPLAY
  Widget addressDisplay() => StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
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
        padding: EdgeInsets.only(left: 40, right: 40, bottom: 25),
        child: Row(
          children: [
            Icon(
                Icons.home_outlined,
                color: Colors.brown[600]
            ),
            SizedBox(width: 10),
            Text(
              userDocs.isNotEmpty? userDocs[0] ['address'] ?? 'N/A' : 'N/A',

              style: TextStyle( fontSize: 18 ),
            ),
          ],
        ),
      );
    },
  );


  /// CONTACT NUMBER DISPLAY
  Widget numberDisplay() => StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
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
      final phoneNumber = userDocs.isNotEmpty ? userDocs[0]['number'] : 'N/A'; // di mo work
      return Container(
        padding: EdgeInsets.only(left: 40, right: 40, bottom: 25),
        child: Row(
          children: [
            Icon(
              Icons.phone_android_outlined,
              color: Colors.brown[600]
            ),
            SizedBox(width: 10),
            Text(
              phoneNumber ?? 'N/A',
              style: TextStyle( fontSize: 18 ),
            ),
          ],
        ),
      );
    },
  );

}
