import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/components/custom_surfix_icon.dart';
import 'package:vat_calculator/components/form_error.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/screens/forgot_password/forgot_password_screen.dart';
import 'package:vat_calculator/screens/landing/landing_page.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {


  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool remember = false;
  final List<String> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error!);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Password dimenticata?",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continua",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                print('user: ' + email.toString());
                print('password: ' + password.toString());
                try{
                  final user = await _auth.signInWithEmailAndPassword(email: email.toString(), password: password.toString());
                  if(user != null){
                    KeyboardUtil.hideKeyboard(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LandingScreen(email: email,),),);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        duration: const Duration(milliseconds: 1700),
                        backgroundColor: Colors.green,
                        content: Text('Accesso con utenza $email', style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                  }
                }catch (e){
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                      duration: const Duration(milliseconds: 2000),
                      backgroundColor: Colors.red,
                      content: Text('Errore accesso. ${e}' , style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                }
              }
            }, textColor: kPrimaryColor, color: kBeigeColor,
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value!.length < 6) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Inserisci la password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Inseriscia la email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try{
      final user = await _auth.currentUser;
      if(user != null){
          print('Email logged in : ' + user!.email!);
          Navigator.push(context, MaterialPageRoute(builder: (context) => LandingScreen(email: user!.email!),),);

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
              duration: const Duration(milliseconds: 700),
              backgroundColor: Colors.green,
              content: Text('Accesso con utenza ${loggedInUser.email}...', style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));

      }else{
        print('No user authenticated');
      }
    }catch(e){
      print('Exception : ' + e.toString());
    }
  }
}
