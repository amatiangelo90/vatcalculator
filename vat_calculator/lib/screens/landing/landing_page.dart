import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
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
      overlayWidget: LoaderOverlayWidget(),
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
