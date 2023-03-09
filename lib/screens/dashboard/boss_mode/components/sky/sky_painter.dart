import 'package:flutter/material.dart';

class SkyPainter extends CustomPainter {
  final double radius;
  final double fraction;
  final Paint skyPaint;

  const SkyPainter(this.radius, this.fraction, this.skyPaint);

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, (size.height / 2) - 0);
    skyPaint.color = Colors.black.withOpacity(fraction);

    canvas.drawCircle(center, radius, skyPaint);
  }

  @override
  bool shouldRepaint(SkyPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
