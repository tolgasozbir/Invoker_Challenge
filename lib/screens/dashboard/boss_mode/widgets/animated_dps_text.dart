import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AnimatedDPSText extends StatefulWidget {
  const AnimatedDPSText({super.key, required this.controller, required this.dps, this.isStarted});

  final ValueChanged<AnimationController> controller;
  final double dps;
  final isStarted;

  @override
  State<AnimatedDPSText> createState() => _AnimatedDPSTextState();
}

class _AnimatedDPSTextState extends State<AnimatedDPSText> with SingleTickerProviderStateMixin {

  final Duration _duration = const Duration(milliseconds: 1000);
  final _tween = Tween<double>(begin: 1, end: 0);
  late final Animation<double> _animation;
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: _duration);
    _animation = _tween.animate(_animationController)..addListener(() => setState(() { }));
    widget.controller.call(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: _duration,
      bottom: widget.isStarted ? _animation.value * context.dynamicHeight(0.32) : 0,
      child: Opacity(
        opacity: widget.isStarted ? _animation.value : 0,
        child: Text(widget.dps == 0 ? "Started" : widget.dps.toString())
      ),
    );
  }
}