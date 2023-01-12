import 'package:flutter/material.dart';
import 'package:vat_calculator/components/socal_card.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'sign_up_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.01), // 4%
                Text("Registrati"),
                const Text(
                  "Immetti la tua mail o continua tramite social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                SignUpForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: SizedBox(
                    width: getProportionateScreenWidth(400),
                    height: getProportionateScreenHeight(50),
                    child: OutlinedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.resolveWith((states) => 5),
                        backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
                        side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.white),),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                      ),
                      child: Text('ACCEDI', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(20))),
                      onPressed: () async {
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () {},
                    ),
                    SocialCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () {},
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  'By continuing your confirm that you agree \nwith our Term and Condition',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
