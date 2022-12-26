import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/screens/landing/components/landing_body.dart';

class LandingScreen extends StatelessWidget {

  static String routeName = "/landing";
  final String email;
  const LandingScreen({Key? key,required  this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.9,
      overlayWidget: const LoaderOverlayWidget(message: 'Caricamento dati...',),
      child: Scaffold(
        body: LandingBody(email: email,),
      ),
    );
  }
}
