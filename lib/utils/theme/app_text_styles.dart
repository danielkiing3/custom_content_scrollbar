import 'package:flutter/material.dart';

abstract class AppTextStyles {
  static const heading = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w700,
    fontSize: 38,
    height: 26 / 20,
    letterSpacing: -0.6,
  );

  static const contentHeading = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w700,
    fontSize: 26,
    height: 26 / 20,
    letterSpacing: -0.6,
  );

  static const bodyLarge = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 26 / 18,
    letterSpacing: -0.36,
  );
}
