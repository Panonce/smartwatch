import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_watch/authentication/auth_screen.dart';
import 'package:smart_watch/screens/login.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            Image.asset(
              'assets/welcome.png',
              width: 300,
              height: 300,
            ),
            SizedBox(height: 30.0),
            Text(
              'Your personal guardian.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 50,
                fontWeight: FontWeight.w800,
                color: Colors.deepOrange.shade200,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Don\'t let fear hold you back. Use\nLigtas to stay safe!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => AuthScreen()));
                  },
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  color: Colors.deepOrange.shade200,
                  shape: StadiumBorder(
                      side: BorderSide.none
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
