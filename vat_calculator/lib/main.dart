import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/routes.dart';
import 'package:vat_calculator/screens/splash/animated_splash.dart';
import 'package:vat_calculator/theme.dart';
import 'models/databundlenotifier.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



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
