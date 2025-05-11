import 'package:flutter/material.dart';

abstract class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w700,
    fontSize: 38,
    height: 26 / 20,
    letterSpacing: -0.6,
  );

  static const TextStyle contentHeading = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w700,
    fontSize: 26,
    height: 26 / 20,
    letterSpacing: -0.6,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 26 / 18,
    letterSpacing: -0.36,
  );
}
