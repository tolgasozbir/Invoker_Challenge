import 'dart:async';

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
  static const Duration _transition = Duration(milliseconds: 2000);
  static const Duration _thunderInterval = Duration(seconds: 5);
  static const Duration _flashDuration = Duration(milliseconds: 300);

  late final AnimationController _sunShine = AnimationController(vsync: this, value: 1);
  late final AnimationController _moonShine = AnimationController(vsync: this, value: 0);
  late final AnimationController _brightness = AnimationController(vsync: this, value: 0.33);
  late final AnimationController _flash = AnimationController(vsync: this, duration: _flashDuration);

  ///Şimşek değeri sadece parlama anlarında değişir, painter da sadece o an boyanır
  final ValueNotifier<double> _thunder = ValueNotifier(0);
  Timer? _thunderTimer;

  Paint haloOuter = Paint()
    ..strokeWidth = 4.0
    ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 400);

  Paint haloInner = Paint()
    ..strokeWidth = 4.0
    ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 200);

  Paint thunder = Paint()
    ..color = Colors.white.withValues(alpha: 1)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

  @override
  void initState() {
    _flash.addListener(_onFlashTick);
    _updateSky();
    super.initState();
  }

  @override
  void dispose() {
    _thunderTimer?.cancel();
    _moonShine.dispose();
    _sunShine.dispose();
    _brightness.dispose();
    _flash.dispose();
    _thunder.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Sky oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSky();
  }

  void _updateSky() {
    switch (widget.skyType) {
      case SkyType.normal:
        _brightness.animateTo(widget.skyLight == SkyLight.light ? 0.0 : 0.5, duration: _transition);
        _moonShine.animateTo(0, duration: _transition);
        _sunShine.animateTo(0, duration: _transition);
        _stopThunder();
      case SkyType.sunny:
        _brightness.animateTo(0.2, duration: _transition);
        _setSunAndMoon();
        _stopThunder();
      case SkyType.thunderstorm:
        _brightness.animateTo(0.5, duration: _transition);
        _setSunAndMoon();
        _startThunder();
    }
  }

  void _setSunAndMoon() {
    final bool isLight = widget.skyLight == SkyLight.light;
    _moonShine.animateTo(isLight ? 0 : 1, duration: _transition);
    _sunShine.animateTo(isLight ? 1 : 0, duration: _transition);
  }

  void _startThunder() {
    _thunderTimer ??= Timer.periodic(_thunderInterval, (_) => _flash.forward(from: 0));
  }

  void _stopThunder() {
    _thunderTimer?.cancel();
    _thunderTimer = null;
    _flash.stop();
    _thunder.value = 0;
  }

  ///Tek bir parlamada üç kısa çakış olur
  void _onFlashTick() {
    final double t = _flash.value;
    final bool isFlashing = t < 1 / 6 || (t > 1 / 3 && t < 1 / 2) || (t > 2 / 3 && t < 1);
    final double value = isFlashing ? 0.40 + (0.06 * t) : 0.0;
    if (_thunder.value != value) {
      _thunder.value = value;
    }
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
            RepaintBoundary(
              child: CustomPaint(painter: SkyPainter(constraints.maxHeight * 0.3, _thunder, thunder)),
            ),
            CustomPaint(painter: SkyPainter(constraints.maxHeight * 0.4, _brightness, haloInner)),
          ],
        );
    },);
  }
}
