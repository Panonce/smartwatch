import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? gUser;
  GoogleSignInAccount get user => gUser!;

  Future googleLogin () async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      gUser = googleUser;

      final gAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null){
        if (userCredential.additionalUserInfo!.isNewUser){
          await _firestore.collection('users')
              .doc(user.uid).set({
            'name': user.displayName,
            'email': user.email,
            'uid': user.uid,
            'profilePhoto': user.photoURL,
            'role': 'User',
            'hr': 'Please add',
            }
          );
        }
      }
    } catch (e){
      print(e.toString());
    }

    notifyListeners();
  }

  Future logout () async{
    FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
  }
}
