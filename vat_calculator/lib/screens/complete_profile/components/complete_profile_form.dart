import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/components/custom_surfix_icon.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/form_error.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/landing/landing_page.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  final String email;
  final String password;

  const CompleteProfileForm({this.email, this.password});

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String firstName;
  String lastName;
  String phoneNumber;

  void addError({String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String error}) {
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
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(80)),
          DefaultButton(
            text: "Crea Profilo ed Accedi",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                KeyboardUtil.hideKeyboard(context);
                try{
                  final _auth = FirebaseAuth.instance;
                  final newUser = await _auth.createUserWithEmailAndPassword(email: widget.email, password: widget.password);


                  if(newUser != null){


                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        duration: const Duration(milliseconds: 5000),
                        backgroundColor: Colors.green,
                        content: Text('Grazie $firstName, il tuo profilo è stato creato e presto verrai reindirizzato alla home page.', style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));

                    ClientVatService clientService = ClientVatService();
                    var performSaveUser = clientService.performSaveUser(firstName, lastName, phoneNumber, widget.email);
                    Timer(Duration(seconds: 2),(){});

                    //print('Recupero info cliente da mail : ' + widget.email);
                    //var userRetrievedByEmail = clientService.retrieveUserByEmail(widget.email);
                    //print(userRetrievedByEmail);
                    Timer(const Duration(milliseconds: 2500), ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => const LandingScreen(),),),);

                  }else{
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                        duration: Duration(milliseconds: 5000),
                        backgroundColor: Colors.red,
                        content: Text('Abbiamo riscontrato qualche problema nel create la tua utenza. Riprova più tardi.', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                  }
                }catch(e){
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                      duration: const Duration(milliseconds: 5000),
                      backgroundColor: Colors.red,
                      content: Text('Abbiamo riscontrato qualche problema nel create la tua utenza. Riprova più tardi. Errore : $e', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Cellulare",
        hintText: "Numero di cellulare",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      decoration: const InputDecoration(
        labelText: "Cognome",
        hintText: "Inserisci il cognome",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Nome",
        hintText: "Inserisci il tuo nome",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
