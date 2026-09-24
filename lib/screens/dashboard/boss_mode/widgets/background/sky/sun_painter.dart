import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SunPainter extends CustomPainter {
  SunPainter(this.radius, this.fraction) : super(repaint: fraction);

  final double radius;
  final ValueListenable<double> fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..strokeWidth = 4.0
      ..color = Colors.white.withValues(alpha: fraction.value)
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 20);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(SunPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.fraction != fraction;
  }
}
