import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import '../../../widgets/icon_widget.dart';
import '../../../widgets/profile_menu.dart';
import 'account page/account_info.dart';
import 'account page/account_privacy.dart';
import 'account page/account_security.dart';

class AccountPage extends StatelessWidget {
  static const keyLanguage = 'key-language';
  static const keyLocation = 'key-location';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("Account Settings",
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
              SettingsContainer(
                children: <Widget>[
                  ProfileMenuWidget(title: 'Privacy', icon: Icons.lock_open_rounded, onPress: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Privacy()),
                    );
                  }),
                  ProfileMenuWidget(title: 'Security', icon: Icons.security_rounded, onPress: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Security()),
                    );
                  }),
                  ProfileMenuWidget(title: 'Account Information', icon: Icons.text_snippet_rounded, onPress: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AccInfo()),
                    );
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

