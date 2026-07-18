import 'package:flutter/material.dart';

/// Bir elementten klavyedeki tuşuna uzanan kabloyu çizer.
/// Kablo üstte [startX], altta [endX] noktasında birer fişle sonlanır.
class CablePainter extends CustomPainter {
  CablePainter({
    required this.color,
    required this.startX,
    required this.endX,
    required this.isEmphasized,
  });

  final Color color;

  /// Kablonun üst ucunun (element portu) X koordinatı.
  final double startX;

  /// Kablonun alt ucunun (klavye tuşu) X koordinatı.
  final double endX;

  /// Seçili elementin kablosu daha kalın ve opak çizilir.
  final bool isEmphasized;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.height <= 0) return;

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = isEmphasized ? 2.4 : 1.6
      ..color = color.withValues(alpha: isEmphasized ? 0.9 : 0.4);

    // Uçları dikey başlayıp biten S kıvrımlı bezier.
    final path = Path()
      ..moveTo(startX, 3)
      ..cubicTo(
        startX,
        size.height * 0.45,
        endX,
        size.height * 0.55,
        endX,
        size.height - 2,
      );
    canvas.drawPath(path, stroke);

    final plug = Paint()..color = color.withValues(alpha: isEmphasized ? 1 : 0.55);
    canvas.drawCircle(Offset(startX, 3), 3.2, plug);
    canvas.drawCircle(Offset(endX, size.height - 2), 3.2, plug);
  }

  @override
  bool shouldRepaint(covariant CablePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.startX != startX ||
      oldDelegate.endX != endX ||
      oldDelegate.isEmphasized != isEmphasized;
}
