import 'package:flutter/material.dart';

import 'moon_painter.dart';
import 'sky_painter.dart';
import 'sun_painter.dart';

enum SkyLight { light, dark }
enum SkyType { normal, sunny, thunderstorm }

class Sky extends StatefulWidget {
  const Sky({required this.skyLight, required this.skyType});

  final SkyLight skyLight;
  final SkyType skyType;

  @override
  State<StatefulWidget> createState() => SkyState();
}

class SkyState extends State<Sky> with TickerProviderStateMixin {
  double _brightness = 0.33;
  double _sunShine = 1.0;
  double _moonShine = 0.0;
  double _thunder = 0.0;
  final int _duration = 2000;

  AnimationController? sunAnimationController;
  AnimationController? moonAnimationController;
  AnimationController? skyAnimationController;
  AnimationController? thunderAnimationController;

  Animation<double>? sunAnimation;
  Animation<double>? moonAnimation;
  Animation<double>? skyAnimation;
  Animation<double>? thunderAnimation;

  Paint haloOuter = Paint()
    ..strokeWidth = 4.0
    ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 400);

  Paint haloInner = Paint()
    ..strokeWidth = 4.0
    ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 200);

  Paint thunder = Paint()
    ..color = Colors.white.withOpacity(1)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

  @override
  void initState() {
    _updateSky();
    super.initState();
  }

  @override
  void dispose() {
    moonAnimationController?.dispose();
    sunAnimationController?.dispose();
    skyAnimationController?.dispose();
    thunderAnimationController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Sky oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSky();
  }

  void _updateSky() {
    if (sunAnimationController != null && sunAnimationController!.isAnimating) {
      sunAnimationController!.stop();
    }

    if (moonAnimationController != null && moonAnimationController!.isAnimating) {
      moonAnimationController!.stop();
    }

    if (skyAnimationController != null && skyAnimationController!.isAnimating) {
      skyAnimationController!.stop();
    }

    if (thunderAnimationController != null && thunderAnimationController!.isAnimating) {
      thunderAnimationController!.stop();
    }

    switch (widget.skyType) {
      case SkyType.normal:
        if (widget.skyLight == SkyLight.light) {
          setCloudy(_brightness, 0.0, _duration);
        } else {
          setCloudy(_brightness, 0.5, _duration);
        }
        setMoon(_moonShine, 0.0, _duration);
        setSun(_sunShine, 0.0, _duration);
      case SkyType.sunny:
        setCloudy(_brightness, 0.2, _duration);
        if (widget.skyLight == SkyLight.light) {
          setMoon(_moonShine, 0, _duration);
          setSun(_sunShine, 1, _duration);
        } else {
          setMoon(_moonShine, 1, _duration);
          setSun(_sunShine, 0, _duration);
        }
      case SkyType.thunderstorm:
        setCloudy(_brightness, 0.5, _duration);
        setThunder();
        if (widget.skyLight == SkyLight.light) {
          setMoon(_moonShine, 0, _duration);
          setSun(_sunShine, 1, _duration);
        } else {
          setMoon(_moonShine, 1, _duration);
          setSun(_sunShine, 0, _duration);
        }
    }
  }

  void setSun(double from, double to, int duration) {
    sunAnimationController = AnimationController(duration: Duration(milliseconds: duration), vsync: this);
    sunAnimation = Tween(begin: from, end: to).animate(sunAnimationController!)..addListener(() {
      setState(() {
        _sunShine = sunAnimation!.value;
      });
    });
    sunAnimationController?.forward();
  }

  void setMoon(double from, double to, int duration) {
    moonAnimationController = AnimationController(duration: Duration(milliseconds: duration), vsync: this);
    moonAnimation = Tween(begin: from, end: to).animate(moonAnimationController!)..addListener(() {
      setState(() {
        _moonShine = moonAnimation!.value;
      });
    });
    moonAnimationController?.forward();
  }

  void setCloudy(double from, double to, int duration) {
    skyAnimationController = AnimationController(duration: Duration(milliseconds: duration), vsync: this);
    skyAnimation = Tween(begin: from, end: to).animate(skyAnimationController!)..addListener(() {
      setState(() {
        _brightness = skyAnimation!.value;
      });
    });
    skyAnimationController?.forward();
  }

  void setThunder() {
    thunderAnimationController = AnimationController(duration: const Duration(milliseconds: 5000), vsync: this);
    thunderAnimation = Tween(begin: 0.0, end: 1.0).animate(thunderAnimationController!)..addListener(() {
      setState(() {
        if ((thunderAnimation!.value > 0.9 && thunderAnimation!.value < 0.91) ||
            (thunderAnimation!.value > 0.92 && thunderAnimation!.value < 0.93) ||
            (thunderAnimation!.value > 0.94 && thunderAnimation!.value < 0.96)) {
          _thunder = thunderAnimation!.value - 0.5;
        } else {
          _thunder = 0.0;
        }
      });
    });
    thunderAnimationController?.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: SunPainter(constraints.maxHeight / 12, _sunShine)),
            CustomPaint(painter: MoonPainter(constraints.maxHeight / 14, _moonShine)),
            CustomPaint(painter: SkyPainter(constraints.maxHeight * 0.4, _brightness, haloOuter)),
            CustomPaint(painter: SkyPainter(constraints.maxHeight * 0.3, _thunder, thunder)),
            CustomPaint(painter: SkyPainter(constraints.maxHeight * 0.4, _brightness, haloInner)),
          ],
        );
    },);
  }
}
