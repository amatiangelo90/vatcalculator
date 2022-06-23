import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vat_calculator/components/no_account_text.dart';
import 'package:vat_calculator/components/socal_card.dart';
import 'package:vat_calculator/screens/landing/landing_page.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {

  GoogleSignInAccount googleUser;
  GoogleSignInAuthentication googleAuth;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Benvenuto",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Ciao! Esegui la login con la tua mail e password, \n oppure continua tramite social network",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              SignForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialCard(
                    icon: "assets/icons/google-icon.svg",
                    press: () async {

                      try{
                        print('Authentication by google');
                        googleUser = await GoogleSignIn().signIn();
                        googleAuth = await googleUser.authentication;

                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );

                        UserCredential signInCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                        if(signInCredential != null){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LandingScreen(email: signInCredential.user.email,),),);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              duration: const Duration(milliseconds: 1700),
                              backgroundColor: Colors.green,
                              content: Text('Accesso con utenza ${signInCredential.user.email}', style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                        }

                      }catch(e){
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                            duration: const Duration(milliseconds: 2000),
                            backgroundColor: Colors.red,
                            content: Text('Errore accesso. ${e}' , style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                      }


                      },
                  ),
                  SocialCard(
                    icon: "assets/icons/facebook-2.svg",
                    press: () {

                    },
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              const NoAccountText(),
            ],
          ),
        ),
      ),
    );
  }
}
