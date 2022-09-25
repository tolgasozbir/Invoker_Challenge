import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData get appTheme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  double get keyboardPadding => MediaQuery.of(this).viewInsets.bottom;
}

extension MediaQueryExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;

  double dynamicWidth(double val) => width * val;
  double dynamicHeight(double val) => height * val;
  
  double get lowValue => height * 0.005;
  double get normalValue => height * 0.01;
  double get mediumValue => height * 0.02;
  double get highValue => height * 0.03;
}

extension DurationExtension on BuildContext {
  Duration get durationVeryLow => const Duration(milliseconds: 1000);
  Duration get durationLow => const Duration(milliseconds: 1500);
  Duration get durationMedium => const Duration(milliseconds: 2000);
  Duration get durationHigh => const Duration(milliseconds: 2500);
  Duration get durationVeryHigh => const Duration(milliseconds: 3000);
  Duration get durationTest => const Duration(milliseconds: 10000);
}

extension BorderExtension on BuildContext {
  BorderRadius get borderRadiusAll4 => const BorderRadius.all(Radius.circular(4));
  BorderRadius get borderRadiusAll8 => const BorderRadius.all(Radius.circular(8));
  BorderRadius get borderRadiusAll12 => const BorderRadius.all(Radius.circular(12));
  BorderRadius get borderRadiusHighAll16 => const BorderRadius.all(Radius.circular(16));
}