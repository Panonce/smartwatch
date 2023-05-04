import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_watch/screens/profile/about%20page/about_ligtas.dart';
import 'package:smart_watch/screens/profile/about%20page/about_terms.dart';
import 'package:smart_watch/widgets/profile_menu.dart';

import 'about page/about_privacy.dart';

class ProfileAbout extends StatefulWidget{
  const ProfileAbout({Key? key}) : super(key: key);

  @override
  State<ProfileAbout> createState() => _ProfileAbout();
}

class _ProfileAbout extends State<ProfileAbout> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("About",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.chevron_left),
            color: Colors.black54),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              ProfileMenuWidget(title: "Privacy Policy", icon: Icons.lock, onPress: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                );
              }),
              ProfileMenuWidget(title: "Terms and Conditions", icon: Icons.feed_outlined, onPress: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => TandC()),
                );
              }),
              ProfileMenuWidget(title: "About Ligtas", icon: Icons.info_outline_rounded, onPress: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => About()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}


