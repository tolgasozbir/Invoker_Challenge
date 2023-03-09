import 'package:flutter/material.dart';

class SunPainter extends CustomPainter {
  final double radius;
  final double fraction;

  const SunPainter(this.radius, this.fraction);

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);

    Paint paint = Paint()
      ..strokeWidth = 4.0
      ..color = Colors.white.withOpacity(fraction)
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 20);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(SunPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
