import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'drop.dart';
import 'rain_painter.dart';

class Rain extends StatefulWidget {
  const Rain({required this.width, required this.height});

  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => RainState();
}

class RainState extends State<Rain> with SingleTickerProviderStateMixin {
  final List<Drop> _drops = [];
  final ValueNotifier<int> _repaint = ValueNotifier(0);
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    _createDrops();
    _ticker = createTicker(_onTick)..start();
    super.initState();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _repaint.dispose();
    super.dispose();
  }

  void _createDrops() {
    final rng = Random();
    for (var i = 0; i < 150; i += 1) {
      _drops.add(
        Drop(
          x:        rng.nextDouble() * widget.width,
          y:        rng.nextDouble() * widget.height,
          length:   rng.nextDouble() * 20 + 2,
          speed:    (rng.nextDouble() * 10 + 10) * 60, //saniyedeki piksel
          opacity:  rng.nextDouble() * 0.5,
        ),
      );
    }
  }

  void _onTick(Duration elapsed) {
    //oyun duraklarsa biriken süre damlaları ışınlamasın
    final dt = ((elapsed - _lastElapsed).inMicroseconds / Duration.microsecondsPerSecond).clamp(0.0, 0.05);
    _lastElapsed = elapsed;

    for (final drop in _drops) {
      drop.y += drop.speed * dt;
      if (drop.y > widget.height) drop.y = 0;
    }

    _repaint.value++;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: RainPainter(drops: _drops, repaint: _repaint),
    );
  }
}
