import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SkyPainter extends CustomPainter {
  SkyPainter(this.radius, this.fraction, this.skyPaint) : super(repaint: fraction);

  final double radius;
  final ValueListenable<double> fraction;
  final Paint skyPaint;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, (size.height / 2) - 0);
    skyPaint.color = Colors.black.withValues(alpha: fraction.value);

    canvas.drawCircle(center, radius, skyPaint);
  }

  @override
  bool shouldRepaint(SkyPainter oldDelegate) {
    return oldDelegate.radius != radius
        || oldDelegate.fraction != fraction
        || oldDelegate.skyPaint != skyPaint;
  }
}
