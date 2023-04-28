import 'package:flutter/material.dart';

Route<dynamic> fadeInPageRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) => _PageAnimation(page: page),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

class _PageAnimation extends StatelessWidget {
  final Widget page;
  const _PageAnimation({required this.page});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: page,
        );
      },
    );
  }
}
