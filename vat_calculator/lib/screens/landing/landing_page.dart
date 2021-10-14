import 'package:flutter/material.dart';
import 'package:vat_calculator/screens/landing/components/landing_body.dart';

class LandingScreen extends StatelessWidget {

  static String routeName = "/landing";
  final String email;
  const LandingScreen({Key key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text("Login Success"),
      ),
      body: LandingBody(email: email,),
    );
  }
}
