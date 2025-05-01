import 'package:flutter/material.dart';
extension MediaQueryExtension on Widget {
  Widget wrapAlign(Alignment alignment) => Align(alignment: alignment, child: this);
  Widget wrapPadding(EdgeInsets edgeInsets) => Padding(padding: edgeInsets, child: this);
  Widget wrapExpanded({int flex = 1}) => Expanded(flex: flex, child: this);
  Widget wrapCenter() => Center(child: this);
}
