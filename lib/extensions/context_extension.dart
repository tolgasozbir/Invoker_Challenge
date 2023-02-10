import 'package:dota2_invoker/providers/services_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension MediaQueryExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  ThemeData get theme => Theme.of(this);

  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;

  double dynamicWidth(double val) => width * val;
  double dynamicHeight(double val) => height * val;
  double sp(double val) => val * (width / 3) / 100;

  ServicesProvider get services => this.read<ServicesProvider>();
}
