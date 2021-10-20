import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/routes.dart';
import 'package:vat_calculator/screens/splash/splash_screen.dart';
import 'package:vat_calculator/theme.dart';
import 'models/databundlenotifier.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        title: 'Ivano',
        theme: theme(),
        initialRoute: SplashScreen.routeName,
        routes: routes,
        builder: EasyLoading.init(),
      ),
    );
  }
}