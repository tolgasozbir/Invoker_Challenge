import 'package:flutter/cupertino.dart';

extension MediaQueryExtension on Widget {
  Widget wrapAlign(Alignment alignment) => Align(child: this, alignment: alignment);
}