import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/profile/components/profile_menu.dart';
import 'package:vat_calculator/screens/splash/splash_screen.dart';

import '../constants.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 3.0,
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Container(
            color: Colors.white12,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(height: 40.0,
                  child: Container(
                    color: Colors.white,

                  ),
                ),
                GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    color: Colors.white,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/Pattern Success.png"),
                            fit: BoxFit.cover),
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ),

                Column(
                  children: [
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProfileMenu(
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
                      ),
                      onTap: () {
                      },
                    ),
                  ],
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
