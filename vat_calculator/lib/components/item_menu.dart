import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants.dart';

class ItemMenu extends StatelessWidget {
  const ItemMenu({
    Key key,
    @required this.text,
    @required this.icon,
    this.press,
    this.showArrow,
    @required this.backgroundColor,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;
  final bool showArrow;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: kPrimaryColor,
          padding: const EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: backgroundColor,
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
            showArrow ? const Icon(Icons.arrow_forward_ios) : const SizedBox(width: 0,),
          ],
        ),
      ),
    );
  }
}
