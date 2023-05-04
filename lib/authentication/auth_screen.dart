import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_watch/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  String token = '';

  void _submitLogIn(
      String email,
      String password,
      String name,
      bool isLogIn,
      Role role,
      BuildContext ctx,
      String hr,
      ) async {

    if (email.isEmpty || password.isEmpty) {
      // Show an error message if any of the fields are empty
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Please fill in all the required fields'),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ),
      );
      return;
    }

    UserCredential authResult;

    try {
      if (isLogIn) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final user = await FirebaseAuth.instance.currentUser!;
        FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user?.uid)
            .set({
          'name': name,
          'email': email,
          'uid': user.uid,
          'role': role.toString().substring(5),
          'hr': hr,
          'address': "N/A",
          'number': "N/A",
          'token' : token,
        });
      }

      // Get the token after the user has been authenticated successfully
      token = await authResult.user!.getIdToken();

      // Add the token to the user's document in the Firestore database
      FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .update({
        'token': token,
      });

    } on PlatformException catch (err) {
      String? message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(message!),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: LogIn(_submitLogIn),
      ),
    );
  }
}
