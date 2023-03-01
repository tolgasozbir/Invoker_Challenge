import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  const BouncingButton({super.key, required this.child, required this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  @override
  _BouncingButtonState createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _scale = 1;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 64),
      lowerBound: 0.0,
      upperBound: 0.2,
    )..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTap: widget.onPressed,
      child: Transform.scale(
        scale: _scale - _controller.value,
        child: widget.child,
      ),
    );
  }

  void _tapDown(TapDownDetails details) => _controller.forward();
  void _tapUp(TapUpDetails details) => _controller.reverse();
}