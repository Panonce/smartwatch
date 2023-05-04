import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword(this.submitFn);

  final void Function(
      String email,
      bool isLogIn,
      BuildContext ctx,
      ) submitFn;


  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  // getting text input
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';

  void _trySubmit(){
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      widget.submitFn(
        _userEmail.trim(),
        _isLogin,
        context,
      );
    }
  }

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Password reset link sent! Please check your email"),
            );
          },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("No user is in our data base."),
            );
          },
        );
      } else {
        Fluttertoast.showToast(msg: "Error: ${e.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.chevron_left),
            color: Colors.black54),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Enter your email and we will send you a password reset link.',
          textAlign: TextAlign.center,
          ),

          /// -- EMAIL INPUT
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  key: ValueKey('email'),
                  validator: (value){
                    if(value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: 'Email Address',
                      hintText: 'Email Address',
                      border: OutlineInputBorder()
                  ),
                ),
              ],
            ),
          ),

          /// -- RESET PASSWORD BUTTON
          ElevatedButton(
            onPressed: () {
              passwordReset(emailController.text);
            },
            child: const Text("Reset Password",
              style: TextStyle(color: Colors.black54),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange[200],
              side: BorderSide.none,
              shape: StadiumBorder()
            ),
          )
        ],
      )
    );
  }

}