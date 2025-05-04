import 'package:flutter/material.dart';

import 'drop.dart';

class DropPainter extends CustomPainter {
  final Drop drop;

  const DropPainter(this.drop);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(this.drop.x, this.drop.y),
      Offset(this.drop.x, this.drop.y + this.drop.length),
      Paint()
        ..color = Colors.black.withValues(alpha: this.drop.opacity)
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
