import 'package:flutter/material.dart';

import 'drop.dart';

class RainPainter extends CustomPainter {
  RainPainter({required this.drops, super.repaint});

  final List<Drop> drops;

  final Paint _paint = Paint()
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    for (final drop in drops) {
      _paint.color = Colors.black.withValues(alpha: drop.opacity);
      canvas.drawLine(
        Offset(drop.x, drop.y),
        Offset(drop.x, drop.y + drop.length),
        _paint,
      );
    }
  }

  ///Yeniden boyamayı [repaint] listenable'ı tetikliyor
  @override
  bool shouldRepaint(RainPainter oldDelegate) => false;
}
