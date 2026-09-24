import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MoonPainter extends CustomPainter {
  MoonPainter(this.radius, this.fraction) : super(repaint: fraction);

  final double radius;
  final ValueListenable<double> fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..strokeWidth = 4.0
      ..color = Colors.white.withValues(alpha: fraction.value)
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 5);

    final rect = Rect.fromCircle(center: center, radius: radius);

    final path = Path()
      ..arcTo(rect, pi / 2, pi, false)
      ..cubicTo(center.dx - 18, center.dy - 10, center.dx - 18, center.dy + 12, center.dx, center.dy + radius)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MoonPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.fraction != fraction;
  }
}
