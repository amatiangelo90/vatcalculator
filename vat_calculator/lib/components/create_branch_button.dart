import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/screens/branch_registration/branch_choice_registration.dart';
import 'package:vat_calculator/size_config.dart';

import 'default_button.dart';

class CreateBranchButton extends StatelessWidget {
  const CreateBranchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(50),
      child: OutlinedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith((states) => 5),
          backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
          side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey),),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
        ), onPressed: () {
        Navigator.pushNamed(context, BranchChoiceCreationEnjoy.routeName);
      }, child: Text('CREA ATTIVITA\'', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(15))),
      ),
    );
  }
}
