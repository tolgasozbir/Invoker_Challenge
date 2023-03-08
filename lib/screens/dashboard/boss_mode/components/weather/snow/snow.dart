import 'dart:math';
import 'package:flutter/material.dart';

import '../rain/drop_painter.dart';
import 'flake.dart';
import 'flake_painter.dart';

class Snow extends StatefulWidget {
  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => SnowState();

  const Snow({required this.width, required this.height});
}

class SnowState extends State<Snow> with TickerProviderStateMixin {
  var _snowPainters = <Widget>[];
  var _flakes = <Flake>[];
  AnimationController? snowAnimationController;

  @override
  void initState() {
    _createFlakes();
    _startAnimation();
    super.initState();
  }

  @override
  void didUpdateWidget(Snow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this._flakes.length == 0) {
      _createFlakes();
      _startAnimation();
    }

    if (oldWidget.height != widget.height) {
      this.snowAnimationController?.dispose();
      _createFlakes();
      _startAnimation();
    }
  }

  @override
  void dispose() {
    this.snowAnimationController?.dispose();
    super.dispose();
  }

  _createFlakes() {
    this._flakes = [];
    var rng = new Random();
    for (var i = 0; i < 200; i += 1) {
      final drop = Flake(
          rng.nextDouble() * widget.width,
          rng.nextDouble() * widget.height,
          rng.nextDouble() * (widget.height / 20),
          rng.nextDouble() + (widget.height / 100),
          rng.nextDouble() * 0.6 
        );
      var painter = CustomPaint(
          painter: DropPainter(drop.x, drop.y, 2, drop.opacity, 0.0));
      this._flakes.add(drop);
      this._snowPainters.add(painter);
    }
  }

  _startAnimation() {
    this.snowAnimationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    var rng = new Random();
    Tween(begin: 0.0, end: 1.0).animate(this.snowAnimationController!)
      ..addListener(() {
        setState(() {
          this._snowPainters = [];
          this._flakes.forEach((flake) {
            flake.y = flake.y += flake.speed / 2;
            flake.x = flake.x += flake.speed / 20;

            if (flake.y > widget.height) {
              flake.y = 0 + widget.height / 20;
              flake.x = rng.nextDouble() * widget.width;
            }

            var painter = CustomPaint(
                painter: FlakePainter(flake.x, flake.y, flake.radius,
                    flake.speed, flake.opacity));
            this._snowPainters.add(painter);
          });
        });
      });
    this.snowAnimationController?.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: this._snowPainters);
  }
}