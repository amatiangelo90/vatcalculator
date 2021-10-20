import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/registration_company/components/company_registration.dart';
import 'package:vat_calculator/screens/splash/splash_screen.dart';

import '../../../constants.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class BodyProfile extends StatelessWidget {
  const BodyProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child){
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const ProfilePic(),
                const SizedBox(height: 20),
                ProfileMenu(
                  text: "Gestione account",
                  icon: "assets/icons/User Icon.svg",
                  press: () => {},
                  showArrow: true,
                ),
                ProfileMenu(
                  text: "Crea Attività",
                  icon: "assets/icons/Shop Icon.svg",
                  press: () {
                    Navigator.pushNamed(context, CompanyRegistration.routeName);
                  },
                  showArrow: true,
                ),
                ProfileMenu(
                  text: "Hai bisogno di aiuto?",
                  icon: "assets/icons/Question mark.svg",
                  press: () {
                  },
                  showArrow: true,
                ),
                ProfileMenu(
                  text: "Log Out",
                  icon: "assets/icons/Log out.svg",
                  showArrow: true,
                  press: () {
                    FirebaseAuth _auth = FirebaseAuth.instance;
                    if(_auth!=null){
                      _auth.signOut();
                    }
                    dataBundleNotifier.clearAll();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                        duration: Duration(milliseconds: 2700),
                        backgroundColor: kPinaColor,
                        content: Text('Logging out...', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                    Navigator.pushNamed(context, SplashScreen.routeName);
                  },
                ),
              ],
            ),
          );
        });
    }
}
