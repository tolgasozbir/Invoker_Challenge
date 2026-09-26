import 'package:flutter/material.dart';

class CooldownAnimation extends StatefulWidget {
  final Widget child;
  final DateTime lastPressedAt;
  final Duration duration;
  final double size;

  const CooldownAnimation({super.key, required this.child, required this.duration, required this.lastPressedAt, required this.size});

  @override
  State<CooldownAnimation> createState() => _CooldownAnimationState();
}

class _CooldownAnimationState extends State<CooldownAnimation> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: widget.duration);
  late final AnimationController _textFade = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  late final Listenable _repaint = Listenable.merge([_controller, _textFade]);
  final TextPainter _textPainter = TextPainter(textDirection: TextDirection.ltr);

  ///0.0 = cooldown yeni başladı, 1.0 = bitti
  double get _elapsedRatio {
    final totalMs = widget.duration.inMilliseconds;
    if (totalMs <= 0) return 1;
    final elapsedMs = DateTime.now().difference(widget.lastPressedAt).inMilliseconds;
    return (elapsedMs / totalMs).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener(_onControllerStatusChanged);
    _sync(isInitial: true);
  }

  @override
  void didUpdateWidget(covariant CooldownAnimation oldWidget) {
    if (oldWidget.lastPressedAt != widget.lastPressedAt) {
      _sync();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    _textFade.dispose();
    _textPainter.dispose();
    super.dispose();
  }

  void _sync({bool isInitial = false}) {
    final ratio = _elapsedRatio;
    if (ratio >= 1) {
      _controller.value = 1;
      if (isInitial) _textFade.value = 0;
      return;
    }
    _textFade.value = 1;
    _controller.value = ratio;
    _controller.forward();
  }

  void _onControllerStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && _textFade.value > 0) {
      _textFade.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        RepaintBoundary(
          child: CustomPaint(
            size: Size.square(widget.size),
            painter: _CooldownPainter(
              progress: _controller,
              textFade: _textFade,
              textPainter: _textPainter,
              totalSeconds: widget.duration.inSeconds,
              repaint: _repaint,
            ),
          ),
        ),
      ],
    );
  }
}

class _CooldownPainter extends CustomPainter {
  _CooldownPainter({
    required this.progress,
    required this.textFade,
    required this.textPainter,
    required this.totalSeconds,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final Animation<double> progress;
  final Animation<double> textFade;
  final TextPainter textPainter;
  final int totalSeconds;

  static final TextStyle _textStyle = TextStyle(
    fontSize: 24,
    color: Colors.white,
    shadows: List.generate(6, (index) => const Shadow(blurRadius: 8)),
  );

  int? _laidOutSeconds;

  @override
  void paint(Canvas canvas, Size size) {
    final double elapsed = progress.value;

    final double curtainHeight = (1 - elapsed) * size.height;
    if (curtainHeight > 0) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, curtainHeight),
        Paint()..color = Colors.black.withValues(alpha: 0.72 + ((0.24 - 0.72) * elapsed)),
      );
    }

    final double fade = textFade.value;
    if (fade <= 0) return;

    final int remainingSeconds = ((1 - elapsed) * totalSeconds).round();
    if (_laidOutSeconds != remainingSeconds) {
      _laidOutSeconds = remainingSeconds;
      textPainter
        ..text = TextSpan(text: '$remainingSeconds', style: _textStyle)
        ..layout();
    }

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    if (fade >= 1) {
      textPainter.paint(canvas, offset);
      return;
    }

    canvas.saveLayer(Offset.zero & size, Paint()..color = Colors.white.withValues(alpha: fade));
    textPainter.paint(canvas, offset);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CooldownPainter oldDelegate) {
    return oldDelegate.totalSeconds != totalSeconds
        || oldDelegate.progress != progress
        || oldDelegate.textFade != textFade;
  }
}
