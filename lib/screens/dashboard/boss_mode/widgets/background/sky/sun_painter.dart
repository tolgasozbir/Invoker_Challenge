import 'package:flutter/material.dart';

class SunPainter extends CustomPainter {
  final double radius;
  final double fraction;

  const SunPainter(this.radius, this.fraction);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..strokeWidth = 4.0
      ..color = Colors.white.withValues(alpha: fraction)
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 20);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(SunPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
