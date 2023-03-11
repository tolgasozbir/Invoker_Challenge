import 'package:flutter/material.dart';

class AnimatedDPSText extends StatefulWidget {
  const AnimatedDPSText({super.key, required this.controller});

  final ValueChanged<AnimationController> controller;

  @override
  State<AnimatedDPSText> createState() => _AnimatedDPSTextState();
}

class _AnimatedDPSTextState extends State<AnimatedDPSText> with SingleTickerProviderStateMixin {

  final Duration _animDuration = const Duration(milliseconds: 1000);
  final _opacityTween = Tween<double>(begin: 1, end: 0);
  late final Animation<double> _opacityAnim;
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: _animDuration);
    _opacityAnim = _opacityTween.animate(_animationController)..addListener(() => setState(() { }));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.call(_animationController);
    return AnimatedPositioned(
      duration: _animDuration,
      bottom: _opacityAnim.value * 300,
      child: Opacity(
        opacity: _opacityAnim.value,
        child: Text("100")
      )
    );
  }
}