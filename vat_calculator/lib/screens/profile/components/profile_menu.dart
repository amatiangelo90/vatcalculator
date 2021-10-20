import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    this.press,
    this.showArrow,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: kPrimaryColor,
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: kCustomWhite,
        ),
        onPressed: press,
        child: Row(
          children: [
            icon == '' ? const SizedBox(width: 0,) : SvgPicture.asset(
              icon,
              color: kPrimaryColor,
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            showArrow ? const Icon(Icons.arrow_forward_ios) : SizedBox(width: 0,),
          ],
        ),
      ),
    );
  }
}
