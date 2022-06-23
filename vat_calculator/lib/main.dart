import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/routes.dart';
import 'package:vat_calculator/screens/splash/animated_splash.dart';
import 'package:vat_calculator/theme.dart';
import 'models/databundlenotifier.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebasePushHandler);

  FirebaseMessaging.onMessage.listen((event) {
    _firebasePushHandler;
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    _firebasePushHandler;
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => DataBundleNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '20m2',
        theme: theme(),
        initialRoute: SplashAnim.routeName,
        routes: routes,
        //builder: EasyLoading.init(),
      ),
    );
  }
}

Future<void> _firebasePushHandler(RemoteMessage message) {
  print('Cazzone');
  //AwesomeNotifications().createNotificationFromJsonData(
  //    message.data,
  //);
}
