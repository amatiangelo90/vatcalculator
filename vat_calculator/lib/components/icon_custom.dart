import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../size_config.dart';

class CustomIcon {

  static Widget buildIconWidget(String icon, Color iconColor, Color backgroundColor, IconData iconBanner, Color iconBannerColor, String message) {
    return Tooltip(
      message: message,
      child: Stack(
        children: [
          Container(
            height: getProportionateScreenWidth(40),
            decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle
            ),
            width: getProportionateScreenWidth(50),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(icon, color: iconColor,),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Center(
              child: Icon(
                iconBanner,
                color: iconBannerColor,
                size: getProportionateScreenHeight(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
