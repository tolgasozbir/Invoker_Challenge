import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  //Specific colors
  static const Color quasColor    = Color(0xFF2196F3);
  static const Color wexColor     = Color(0xFFF48FB1);
  static const Color exortColor   = Color(0xFFFFC107);
  static const Color exitBtnColor = Colors.white70;

  //Snackbar colors
  static const Color errorColor   = Color(0xFFC72C41);
  static const Color successColor = Color(0xFF0C7040);
  static const Color warningColor = Color(0xFFE88B1D);
  static const Color infoColor    = Color(0xFF0070E0);
  
  //True false icon colors
  static const Color correctIconColor  = const Color(0xFF33CC33);
  static const Color wrongIconColor = const Color(0xFFCC3333);

  //Button colors
  static const Color outlinedBorder    = Color(0xFF9BBED7);
  static const Color outlinedSurface   = Color(0xFFDCF0FF);
  static const Color buttonBgColor = Color(0xFF545454);

  static const Color expBarColor       = Color(0xFFFFC000);
  static const Color scoreCounterColor = Color(0xFF4CAF50);
  static const Color orbsShadow        = Color(0x89000000);
  static const Color spellHelperShadow = Colors.black12;

  static const Color textFormFieldBg    = Color(0x2CFFFFFF);
  static const Color dialogBgColor      = Color(0xFF444444);
  static const Color resultsCardBg      = Color(0xFF666666);

  static List<Color> get gradientBlueYellow => const [
    Color(0x3300BBFF),
    Color(0x33FFCC00)
  ];

  //Common colors
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color white30 = Colors.white30;
  static const Color black = Colors.black;
  static const Color amber = Colors.amber;
  static const Color red = Colors.red;
  static const Color blue = Colors.blue;
  static const Color fullGreen = Color(0xFF00FF00);

}
