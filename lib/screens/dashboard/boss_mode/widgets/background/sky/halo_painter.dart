import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///Boss etrafındaki karanlık.
///Eskiden büyük blur'lu (400/200) MaskFilter'larla çiziliyordu; Impeller (iOS) bunu
///neredeyse görünmez çizdiği için Skia'daki (Android) görünüm radial gradient ile birebir çiziliyor.
class HaloPainter extends CustomPainter {
  HaloPainter(this.radius, this.fraction) : super(repaint: fraction);

  final double radius;
  final ValueListenable<double> fraction;

  ///Karanlık, yarıçapın bu katında tamamen kaybolur
  static const double _spread = 1.52;

  ///Android'deki eski görünümden ölçülen karanlık eğrisi (merkez → dış kenar)
  static const List<double> _stops = [0, 0.33, 0.46, 0.585, 0.66, 0.75, 0.835, 0.92, 1];
  static const List<double> _intensity = [1, 0.96, 0.83, 0.62, 0.42, 0.25, 0.125, 0.04, 0];

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final double alpha = fraction.value;
    if (alpha <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = radius * _spread;

    _paint.shader = RadialGradient(
      colors: [for (final i in _intensity) Colors.black.withValues(alpha: alpha * i)],
      stops: _stops,
    ).createShader(Rect.fromCircle(center: center, radius: outerRadius));

    canvas.drawCircle(center, outerRadius, _paint);
  }

  @override
  bool shouldRepaint(HaloPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.fraction != fraction;
  }
}
