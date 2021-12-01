import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/screens/branch_registration/branch_choice_registration.dart';

import 'default_button.dart';

class CreateBranchButton extends StatelessWidget {
  const CreateBranchButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultButton(
      color: Colors.green.withOpacity(0.9),
      text: "Crea Attività",
      press: () async {
        Navigator.pushNamed(context, BranchChoiceCreationEnjoy.routeName);
      },
    );
  }
}
