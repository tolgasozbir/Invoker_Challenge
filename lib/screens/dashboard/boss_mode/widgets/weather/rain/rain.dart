import 'dart:math';

import 'package:flutter/material.dart';

import 'drop.dart';
import 'drop_painter.dart';

class Rain extends StatefulWidget {
  const Rain({required this.width, required this.height});

  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => RainState();
}

class RainState extends State<Rain> with TickerProviderStateMixin {
  List<Widget> _dropPainters = [];
  List<Drop> _drops = [];
  late AnimationController rainAnimationController;

  @override
  void initState() {
    _createDrops();
    _startAnimation();
    super.initState();
  }

  @override
  void dispose() {
    rainAnimationController.dispose();
    super.dispose();
  }

  void _createDrops() {
    var rng = Random();
    for (var i = 0; i < 150; i += 1) {
      final drop = Drop(
        x:        rng.nextDouble() * widget.width,
        y:        rng.nextDouble() * widget.height,
        length:   rng.nextDouble() * 20 + 2,
        speed:    rng.nextDouble() * 10 + 10,
        opacity:  rng.nextDouble() * 0.5
      );
      var painter = CustomPaint(painter: DropPainter(drop));
      _drops.add(drop);
      _dropPainters.add(painter);
    }
  }

  void _startAnimation() {
    rainAnimationController = AnimationController(duration: Duration(milliseconds: 15000), vsync: this);
    Tween(begin: 0.0, end: 1.0).animate(rainAnimationController)..addListener(() {
      _dropPainters.clear();
      _drops.forEach((drop) {
        drop.y = drop.y += drop.speed;

        if (drop.y > widget.height) drop.y = 0;

        var painter = CustomPaint(painter:DropPainter(drop));
        _dropPainters.add(painter);
      });
      setState(() { });
    });
    rainAnimationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: _dropPainters
    );
  }
}
