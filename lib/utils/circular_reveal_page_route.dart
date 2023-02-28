import 'package:flutter/material.dart';

Route circularRevealPageRoute(Widget routePage) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 1200),
    reverseTransitionDuration: const Duration(milliseconds: 1200),
    opaque: false,
    barrierDismissible: false,
    pageBuilder: (context, animation, secondaryAnimation) => routePage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final screenSize = MediaQuery.of(context).size;
      final center = Offset(screenSize.width/2, screenSize.height/2);
      final beginRadius = 0.0;
      final endRadius = screenSize.height * 0.8;
      final borderWidth = 16.0;

      final tween = Tween(begin: beginRadius, end: endRadius);
      final radiusTweenAnimation = animation.drive(tween);

      final borderRect = Rect.fromCircle(
        radius: radiusTweenAnimation.value + borderWidth, 
        center: center
      );

      final clipRect = Rect.fromCircle(
        radius: radiusTweenAnimation.value, 
        center: center
      );

      return CustomPaint(
        painter: _BorderPainter(rect: borderRect, color: Colors.grey.shade700),
        child: ClipPath(
          clipper: _CircleRevealClipper(rect: clipRect),
          child: child,
        ),
      );
    },
  );
}

class _BorderPainter extends CustomPainter {
  final Rect rect;
  final Color color;

  _BorderPainter({required this.rect, required this.color,});

  @override
  void paint(Canvas canvas, Size size) {

    final border = Paint();
    border.color = color;
    border.maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawOval(rect, border);
  }

  @override
  bool shouldRepaint(_BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_BorderPainter oldDelegate) => false;
}

class _CircleRevealClipper extends CustomClipper<Path> {
  final Rect rect;

  _CircleRevealClipper({required this.rect});

  @override
  Path getClip(Size size) {
    return Path()..addOval(rect);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
