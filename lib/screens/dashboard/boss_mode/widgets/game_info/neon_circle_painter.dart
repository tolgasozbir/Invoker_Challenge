import 'package:flutter/material.dart';

class NeonCirclesPainter extends CustomPainter {
  const NeonCirclesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final List<Map<String, dynamic>> circles = [
      {
        'radius': size.width * 0.46,
        'color': Colors.red,
        'glowBlur': 12.0,
      },
      {
        'radius': size.width * 0.34,
        'color': Colors.amber,
        'glowBlur': 12.0,
      },
      {
        'radius': size.width * 0.22,
        'color': Colors.green,
        'glowBlur': 12.0,
      },
    ];

    for (final circle in circles) {
      final Color baseColor = circle['color'] as Color;
      final double radius = circle['radius'] as double;
      final double glowBlur = circle['glowBlur'] as double;

      // Glow effect
      final glowPaint = Paint()
        ..color = baseColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowBlur);
      canvas.drawCircle(center, radius, glowPaint);

      // Main circle
      final mainPaint = Paint()
        ..color = baseColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      canvas.drawCircle(center, radius, mainPaint);
    }

    // Center dot
    final centerDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 5, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant NeonCirclesPainter oldDelegate) => false;
}
