import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_watch/screens/profile/settings/account_page.dart';
import 'package:smart_watch/widgets/profile_menu.dart';

import '../../../widgets/icon_widget.dart';


class SettingsPage extends StatefulWidget{
  @override
  State<SettingsPage> createState() => _SettingsPageState();

}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("Settings",
            style: Theme.of(context).textTheme.headlineSmall),
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
              SettingsGroup(
                title: 'GENERAL',
                children: <Widget>[
                  IconWidget(title: 'Account Settings', subtitle: 'Privacy, Security, Account Information', icon: Icons.settings, onPress: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()),
                    );
                  }),
                  ProfileMenuWidget(title: 'Delete Account',icon: Icons.delete_outline_rounded, onPress: () {}),
                ],
              ),
              const SizedBox(height: 10),
              SettingsGroup(
                title: 'FEEDBACK',
                children: <Widget>[
                  ProfileMenuWidget(title: 'Send Feedback', icon: Icons.feedback_rounded, onPress: () {
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
