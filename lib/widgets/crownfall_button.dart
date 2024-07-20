import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../services/sound_manager.dart';

enum CrownfallButtonTypes {
  Azurite(
    gradientColors: [Color(0xFF2062b2), Color(0xFF041834),],
    innerLinesColors: [Colors.blue, Colors.transparent, Colors.transparent, Colors.blue],
  ),

  Jade(
    gradientColors: [Color(0xFF396D55), Color(0xFF1E3A33),],
    innerLinesColors: [Colors.green, Colors.transparent, Colors.transparent, Colors.green],
  ),

  Ruby(
    gradientColors: [Color(0xFFBF1F1F), Color(0xFF5E091A),],
    innerLinesColors: [Colors.red, Colors.transparent, Colors.transparent, Colors.red],
  ),

  Onyx(
    gradientColors: [Color(0xFF414747), Color(0xFF242726),],
    innerLinesColors: [Colors.grey, Colors.transparent, Colors.transparent, Colors.grey],
  );

  final List<Color> gradientColors;
  final List<Color> innerLinesColors;

  const CrownfallButtonTypes({required this.gradientColors, required this.innerLinesColors});
}

class CrownfallButton extends StatelessWidget {
  const CrownfallButton({
    super.key, 
    this.child,
    this.width = 200, 
    this.height = 48,
    this.buttonType = CrownfallButtonTypes.Azurite,
    this.onTap,
    this.isButtonActive = true,
  }) : this.protrusion = true;
  
  const CrownfallButton.normal({
    super.key, 
    this.child,
    this.width = 200, 
    this.height = 48,
    this.buttonType = CrownfallButtonTypes.Azurite,
    this.onTap,
    this.isButtonActive = true,
  }) : this.protrusion = false;

  final Widget? child;
  final double width;
  final double height;
  final CrownfallButtonTypes buttonType;
  final VoidCallback? onTap;
  final bool isButtonActive;
  final bool protrusion;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isButtonActive ? onTap : () => SoundManager.instance.playMeepMerp(),
      child: CustomPaint(
        foregroundPainter: _CrownfallPainter(buttonType: buttonType, protrusion: this.protrusion),
        child: ClipPath(
          clipper: _CrownfallClipper(protrusion: this.protrusion),
          child: AnimatedContainer(
            duration: Durations.medium4,
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: buttonType.gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _CrownfallClipper extends CustomClipper<Path> {
  const _CrownfallClipper({required this.protrusion});

  final bool protrusion;

  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;

    final normal = Path()
      ..moveTo(w * 0.14, 0)
      ..lineTo(w * 0.05, h / 2)
      ..lineTo(w * 0.14, h)
      ..lineTo(w * 0.86, h)
      ..lineTo(w * 0.95, h / 2)
      ..lineTo(w * 0.86, 0)
      ..close();

    final base = Path()
      ..moveTo(w * 0.86, 0)
      ..lineTo(w * 0.14, 0)
      ..lineTo(w * 0.12, h * 0.1)
      ..lineTo(w * 0.08, h * 0.1)
      ..lineTo(0, h * 0.5)
      ..lineTo(w * 0.08, h * 0.9)
      ..lineTo(w * 0.12, h * 0.9)
      ..lineTo(w * 0.14, h)
      ..lineTo(w * 0.86, h)
      ..lineTo(w * 0.88, h * 0.9)
      ..lineTo(w * 0.92, h * 0.9)
      ..lineTo(w, h * 0.5)
      ..lineTo(w * 0.92, h * 0.1)
      ..lineTo(w * 0.88, h * 0.1)
      ..close();

    return protrusion ? base : normal;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _CrownfallPainter extends CustomPainter {
  _CrownfallPainter({required this.buttonType, required this.protrusion,});

  final CrownfallButtonTypes buttonType;
  final bool protrusion;

  final double scaleFactor = 0.8;

  final outerBorderGradientStart = const Color(0xffe8e3d5);
  final outerBorderGradientEnd = const Color(0xffad7f30);

  final protrusionGradientStart = const Color(0xff9a887c);
  final protrusionGradientEnd = const Color(0xff966f2b);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final outerBorderPaint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..shader = ui.Gradient.linear(
        Offset(w / 2, 0),
        Offset(w / 2, h),
        [outerBorderGradientStart, outerBorderGradientEnd],
      );

    final Paint innerLinePaint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        colors: buttonType.innerLinesColors,
        stops: const [0.2, 0.3, 0.7, 0.8],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final Paint innerLineLongPaint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        colors: buttonType.innerLinesColors,
        stops: const [0.2, 0.3, 0.6 ,0.8],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    if (protrusion) drawSideBorders(canvas, w, h);

    final Path outerBorderPath = Path()
      ..moveTo(w * 0.14, 0)
      ..lineTo(w * 0.05, h / 2)
      ..lineTo(w * 0.14, h)
      ..lineTo(w * 0.86, h)
      ..lineTo(w * 0.95, h / 2)
      ..lineTo(w * 0.86, 0)
      ..close();
    canvas.drawPath(outerBorderPath, outerBorderPaint);

    final innerLinePath = Path()
      ..moveTo(w * 0.14+4, 12)
      ..lineTo(w * 0.06+8, h/2)
      ..lineTo(w * 0.14+4, h-12)
      ..lineTo(w * 0.86-4, h-12)
      ..lineTo(w * 0.94-8, h/2)
      ..lineTo(w * 0.86-4, 12)
      ..close();
    if (protrusion) canvas.drawPath(innerLinePath, innerLinePaint);

    final Path innerLinePathScaled = Path()
      ..moveTo(
        w * 0.14 + (w * 0.5 - w * 0.14) * (1 - scaleFactor),
        (h * 0.5) * (1 - scaleFactor),
      )
      ..lineTo(
        w * 0.05 + (w * 0.5 - w * 0.05) * (1 - scaleFactor),
        h / 2,
      )
      ..lineTo(
        w * 0.14 + (w * 0.5 - w * 0.14) * (1 - scaleFactor),
        h - (h * 0.5) * (1 - scaleFactor),
      )
      ..lineTo(
        w * 0.86 - (w * 0.86 - w * 0.5) * (1 - scaleFactor),
        h - (h * 0.5) * (1 - scaleFactor),
      )
      ..lineTo(
        w * 0.95 - (w * 0.95 - w * 0.5) * (1 - scaleFactor),
        h / 2,
      )
      ..lineTo(
        w * 0.86 - (w * 0.86 - w * 0.5) * (1 - scaleFactor),
        (h * 0.5) * (1 - scaleFactor),
      )
      ..close();
    if (protrusion) canvas.drawPath(innerLinePathScaled, innerLineLongPaint);
  }

  void drawSideBorders(Canvas canvas, double w, double h) {
    final Paint sideBorderPaint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..shader = ui.Gradient.linear(
        Offset(w / 2, 0),
        Offset(w / 2, h),
        [outerBorderGradientStart, outerBorderGradientEnd],
      );

    final Paint sideBorderFillPaint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(w / 2, 0),
        Offset(w / 2, h),
        [protrusionGradientStart, protrusionGradientEnd],
      );

    final Path leftBorderPath = Path()
      ..moveTo(w * 0.12, h * 0.1)
      ..lineTo(w * 0.08, h * 0.1)
      ..lineTo(0, h / 2)
      ..lineTo(w * 0.08, h * 0.9)
      ..lineTo(w * 0.12, h * 0.9);
    canvas.drawPath(leftBorderPath, sideBorderPaint);

    final Path leftBorderFillPath = Path()
      ..moveTo(w * 0.12, h * 0.1)
      ..lineTo(w * 0.08, h * 0.1)
      ..lineTo(0, h / 2)
      ..lineTo(w * 0.08, h * 0.9)
      ..lineTo(w * 0.12, h * 0.9)
      ..lineTo(w * 0.05, h / 2)
      ..lineTo(w * 0.12, h * 0.1)
      ..close();
    canvas.drawPath(leftBorderFillPath, sideBorderFillPaint);

    final Path rightBorderPath = Path()
      ..moveTo(w * 0.88, h * 0.1)
      ..lineTo(w * 0.92, h * 0.1)
      ..lineTo(w, h / 2)
      ..lineTo(w * 0.92, h * 0.9)
      ..lineTo(w * 0.88, h * 0.9);
    canvas.drawPath(rightBorderPath, sideBorderPaint);

    final Path rightBorderFillPath = Path()
      ..moveTo(w * 0.88, h * 0.1)
      ..lineTo(w * 0.92, h * 0.1)
      ..lineTo(w, h / 2)
      ..lineTo(w * 0.92, h * 0.9)
      ..lineTo(w * 0.88, h * 0.9)
      ..lineTo(w * 0.95, h / 2)
      ..lineTo(w * 0.88, h * 0.1)
      ..close();
    canvas.drawPath(rightBorderFillPath, sideBorderFillPaint);
  }

  @override
  bool shouldRepaint(_CrownfallPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_CrownfallPainter oldDelegate) => false;
}
