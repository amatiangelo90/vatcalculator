import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vat_calculator/screens/landing/components/landing_body.dart';
import 'package:vat_calculator/size_config.dart';

import '../../constants.dart';

class LandingScreen extends StatelessWidget {

  static String routeName = "/landing";
  final String email;
  const LandingScreen({Key key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.9,
      overlayWidget: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(130),
              width: getProportionateScreenWidth(250),
              child: Card(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: getProportionateScreenHeight(15),),
                        SpinKitRing(
                          lineWidth: 3,
                          color: kPrimaryColor,
                          size: getProportionateScreenHeight(50),
                        ),
                        SizedBox(height: getProportionateScreenHeight(4),),
                        const Text('Stiamo caricando i tuoi dati..'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: const Text("Login Success"),
        ),
        body: LandingBody(email: email,),
      ),
    );
  }
}
