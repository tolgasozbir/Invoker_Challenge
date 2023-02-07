import 'package:flutter/cupertino.dart';

extension MediaQueryExtension on Widget {
  Widget wrapAlign(Alignment alignment) => Align(child: this, alignment: alignment);
  Widget wrapPadding(EdgeInsets edgeInsets) => Padding(child: this, padding: edgeInsets);
  Widget wrapExpanded({int flex = 1}) => Expanded(child: this, flex: flex);
  Widget wrapCenter() => Center(child: this);
}