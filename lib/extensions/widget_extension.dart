import 'package:flutter/cupertino.dart';

extension MediaQueryExtension on Widget {
  Widget wrapAlign(Alignment alignment) => Align(alignment: alignment, child: this);
  Widget wrapPadding(EdgeInsets edgeInsets) => Padding(padding: edgeInsets, child: this);
  Widget wrapExpanded({int flex = 1}) => Expanded(flex: flex, child: this);
  Widget wrapCenter() => Center(child: this);
  Widget scaleWidget(double scale) => Transform.scale(scale: scale, child: this);
}

class EmptyBox extends SizedBox {
  const EmptyBox() : super(width: 0, height: 0);

  const EmptyBox.w4() : super(width: 4);
  const EmptyBox.w8() : super(width: 8);
  const EmptyBox.w12() : super(width: 12);
  const EmptyBox.w16() : super(width: 16); 
  const EmptyBox.w24() : super(width: 24); 
  const EmptyBox.w32() : super(width: 32); 

  const EmptyBox.h4() : super(height: 4);
  const EmptyBox.h8() : super(height: 8);
  const EmptyBox.h12() : super(height: 12);
  const EmptyBox.h16() : super(height: 16);
  const EmptyBox.h24() : super(height: 24);
  const EmptyBox.h32() : super(height: 32);
}
