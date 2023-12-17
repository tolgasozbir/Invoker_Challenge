import 'dart:math';

import 'package:dota2_invoker_game/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DashedCircle extends StatelessWidget {
  const DashedCircle({
    super.key, 
    required this.dashProgress, 
    required this.dashUnits, 
    required this.circleRadius, 
    this.circleColor = AppColors.circleColor, 
    required this.dashGap, 
    required this.reversedColor,
  });

  final double dashProgress;
  final int dashUnits;
  final double circleRadius;
  final Color circleColor;
  final double dashGap;
  final bool reversedColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(
        progress: dashProgress,
        units: dashUnits,
        radius: circleRadius,
        gap: dashGap,
        color: circleColor,
        reversedColor: reversedColor,
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;
  final int units;
  final double gap;
  final Color color;
  final double radius;
  final bool reversedColor;

  CirclePainter({
    required this.progress,
    required this.units,
    required this.radius,
    required this.gap,
    required this.color,
    this.reversedColor = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);
    const maskFiler = MaskFilter.blur(BlurStyle.solid, 2);

    // final gradient = new SweepGradient(
    //   startAngle: -pi / 2,
    //   endAngle: (-pi / 2) + (pi * 2),
    //   tileMode: TileMode.repeated,
    //   colors: this._gradient,
    // );

    final paintFilled = Paint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = maskFiler
      ..color = reversedColor ? color.withOpacity(0.2) : color;
    //..shader = gradient.createShader(rect);

    final paintEmpty = Paint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = maskFiler
      ..color = reversedColor ? color : color.withOpacity(0.2);

    for (var i = 0; i < units; i++) {
      final unit = 2 * pi / units;
      final start = unit * i;
      final to = ((2 * pi) / units) + unit;
      canvas.drawArc(
        rect, 
        -pi / 2 + start, 
        to * 2 * gap, 
        false,
        i < progress ? paintFilled : paintEmpty,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
