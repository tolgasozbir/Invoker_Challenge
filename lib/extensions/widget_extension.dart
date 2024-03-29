import 'package:flutter/material.dart';
//TODO: REMOVE ALL
extension MediaQueryExtension on Widget {
  Widget wrapAlign(Alignment alignment) => Align(alignment: alignment, child: this);
  Widget wrapPadding(EdgeInsets edgeInsets) => Padding(padding: edgeInsets, child: this);
  Widget wrapExpanded({int flex = 1}) => Expanded(flex: flex, child: this);
  Widget wrapCenter() => Center(child: this);
  Widget wrapClipRRect(BorderRadiusGeometry borderRadius) => ClipRRect(borderRadius: borderRadius, child: this);
  Widget wrapFittedBox() => FittedBox(child: this);
  Widget scaleWidget(double scale) => Transform.scale(scale: scale, child: this);
}
