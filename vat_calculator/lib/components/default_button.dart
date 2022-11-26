import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
    required this.textColor,
    required this.color
  }) : super(key: key);
  final String text;
  final Function press;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(45),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
          primary: Colors.white,
          backgroundColor: color ?? kPrimaryColor,
        ),
        onPressed: press as void Function(),
        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(16),
            color: textColor == null ? Colors.white : textColor,
          ),
        ),
      ),
    );
  }
}
