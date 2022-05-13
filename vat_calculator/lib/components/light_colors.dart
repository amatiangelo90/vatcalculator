import 'dart:math';

import 'package:flutter/material.dart';

class LightColors  {

  static final _random = Random();

  static const Color kLightYellow = Color(0xFFFFF9EC);
  static const Color kLightYellow2 = Color(0xFFFFE4C7);
  static const Color kDarkYellow = Color(0xFFF9BE7C);
  static const Color kPalePink = Color(0xFFd68447);

  static const Color kRed = Color(0xFFE46472);
  static const Color kLavender = Color(0xFFc0adf0);
  static const Color kBlue = Color(0xFF6488E4);
  static const Color kLightGreen = Color(0xFF93b2a0);
  static const Color kGreen = Color(0xFF309397);

  static const Color kDarkBlue = Color(0xFF0D253F);

  static const List<Color> colors = [kLavender, kDarkYellow, kPalePink, kRed, kBlue, kGreen, kDarkBlue, kLightGreen];
  static Color getRandomColor(){
    return colors[_random.nextInt(colors.length)];
  }
}