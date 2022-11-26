import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/components/custom_surfix_icon.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/form_error.dart';
import 'package:vat_calculator/components/no_account_text.dart';
import 'package:vat_calculator/screens/sign_in/sign_in_screen.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Password dimenticata?",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Per favore, compila i dati con cui ti sei registrato. \nTi arriverà una mail con cui potrai cambiare la password;)",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                setState(() {
                  errors.remove(kEmailNullError);
                });
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }
              return null;
            },
            validator: (value) {
              if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                setState(() {
                  errors.add(kEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Inserisci la tua e-mail",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: "Continua",
            press: () async {

              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                try{
                  final _auth = FirebaseAuth.instance;
                  await _auth.sendPasswordResetEmail(email: email!);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                      duration: const Duration(milliseconds: 1500),
                      backgroundColor: Colors.green,
                      content: Text('Email per reset password inviata a $email', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                  Timer(const Duration(milliseconds: 2500), ()=> Navigator.pushNamed(context, SignInScreen.routeName));
                }catch (e){
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                      duration: const Duration(milliseconds: 2000),
                      backgroundColor: Colors.red,
                      content: Text('Errore invio mail per reset password. Errore: ${e}' , style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                }
              }
            }, textColor: Color(0xff121212), color: Color(0xff121212),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          const NoAccountText(),
        ],
      ),
    );
  }
}
