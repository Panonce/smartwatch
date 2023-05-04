import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:smart_watch/authentication/GoogleAuth.dart';
import 'package:smart_watch/authentication/auth_screen.dart';
import 'package:smart_watch/screens/home.dart';
import 'package:smart_watch/screens/notification/alert_notif.dart';
import 'package:smart_watch/screens/notification/notification.dart';
import 'package:smart_watch/widgets/widget_theme/theme.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Smartwatch',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("0cd37918-49fe-47c5-8559-3996fea9a420");
  OneSignal.shared.getDeviceState().then((deviceState) async {
    final user = await FirebaseAuth.instance.currentUser!;
    String? playerId = deviceState?.userId;
    FirebaseFirestore.instance.collection('playerId').add({
      'userId': user.uid,
      'playerId': playerId
    });
  });

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });


  OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
  });



  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp event received');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Notif()),);
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Alert()),
      );
    });

    return ChangeNotifierProvider(
      create: (context) => GoogleAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(stream:FirebaseAuth.instance.authStateChanges(), builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData){
            return Home();
          }
          return AuthScreen();
        }),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Home(),
    );
  }


}