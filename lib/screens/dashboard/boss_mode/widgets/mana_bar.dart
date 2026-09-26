import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../extensions/context_extension.dart';
import '../../../../providers/boss_battle_provider.dart';

class ManaBar extends StatefulWidget {
  const ManaBar({super.key});

  @override
  State<ManaBar> createState() => _ManaBarState();
}

class _ManaBarState extends State<ManaBar> with SingleTickerProviderStateMixin {
  static const EdgeInsets _margin = EdgeInsets.symmetric(horizontal: 24);

  late final BossBattleProvider _provider;
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  late final ValueNotifier<double> _shownMana;
  final TextPainter _manaTextPainter = TextPainter(textDirection: TextDirection.ltr);
  final TextPainter _regenTextPainter = TextPainter(textDirection: TextDirection.ltr);

  double _from = 0;
  double _to = 0;

  @override
  void initState() {
    super.initState();
    _provider = context.read<BossBattleProvider>();
    _from = _to = _provider.currentMana;
    _shownMana = ValueNotifier(_to);
    _controller.addListener(_onTick);
    _provider.addListener(_onManaChanged);
  }

  @override
  void dispose() {
    _provider.removeListener(_onManaChanged);
    _controller.dispose();
    _shownMana.dispose();
    _manaTextPainter.dispose();
    _regenTextPainter.dispose();
    super.dispose();
  }

  void _onTick() => _shownMana.value = _from + ((_to - _from) * _controller.value);

  void _onManaChanged() {
    if (_provider.currentMana == _to) return;
    _from = _shownMana.value;
    _to = _provider.currentMana;
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = DefaultTextStyle.of(context).style.copyWith(
      fontSize: context.sp(12),
      fontWeight: FontWeight.bold,
    );

    return Padding(
      padding: _margin,
      child: Selector<BossBattleProvider, Tuple2<double, double>>(
        selector: (_, provider) => Tuple2(provider.maxMana, provider.manaRegen),
        builder: (_, value, __) => CustomPaint(
          size: Size(context.width, context.dynamicHeight(0.048)),
          painter: _ManaBarPainter(
            mana: _shownMana,
            maxMana: value.item1,
            manaRegen: value.item2,
            fillWidth: context.dynamicWidth(0.88),
            textStyle: textStyle,
            manaTextPainter: _manaTextPainter,
            regenTextPainter: _regenTextPainter,
          ),
        ),
      ),
    );
  }
}

class _ManaBarPainter extends CustomPainter {
  _ManaBarPainter({
    required this.mana,
    required this.maxMana,
    required this.manaRegen,
    required this.fillWidth,
    required this.textStyle,
    required this.manaTextPainter,
    required this.regenTextPainter,
  }) : super(repaint: mana);

  final ValueListenable<double> mana;
  final double maxMana;
  final double manaRegen;
  final double fillWidth;
  final TextStyle textStyle;
  final TextPainter manaTextPainter;
  final TextPainter regenTextPainter;

  static const Radius _radius = Radius.circular(6);
  static const Color _backgroundColor = Color(0xFF20385C);
  static const LinearGradient _fillGradient = LinearGradient(
    colors: [
      Color(0xFF385AB4),
      Color(0xFF4870E0),
      Color(0xFF385AB4),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  Shader? _fillShader;
  double? _shaderHeight;
  String? _manaText;
  String? _regenText;

  @override
  void paint(Canvas canvas, Size size) {
    final barRect = Offset.zero & size;

    canvas.drawRRect(
      RRect.fromRectAndRadius(barRect, _radius),
      Paint()..color = _backgroundColor,
    );

    _paintFill(canvas, size);

    canvas.drawRRect(
      RRect.fromRectAndRadius(barRect.deflate(0.6), _radius),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    _paintTexts(canvas, size);
  }

  void _paintFill(Canvas canvas, Size size) {
    final double width = (fillWidth * (mana.value / maxMana)).clamp(0.0, size.width);
    if (width <= 0) return;

    if (_fillShader == null || _shaderHeight != size.height) {
      _shaderHeight = size.height;
      _fillShader = _fillGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, width, size.height), _radius),
      Paint()..shader = _fillShader,
    );
  }

  void _paintTexts(Canvas canvas, Size size) {
    final double shownMana = mana.value > maxMana ? maxMana : mana.value;
    final manaText = '${shownMana.toStringAsFixed(0)}/${maxMana.toStringAsFixed(0)}';
    final regenText = '+${manaRegen.toStringAsFixed(1)}';

    if (_manaText != manaText) {
      _manaText = manaText;
      manaTextPainter
        ..text = TextSpan(text: manaText, style: textStyle)
        ..layout();
    }

    if (_regenText != regenText) {
      _regenText = regenText;
      regenTextPainter
        ..text = TextSpan(text: regenText, style: textStyle)
        ..layout();
    }

    manaTextPainter.paint(
      canvas,
      Offset((size.width - manaTextPainter.width) / 2, (size.height - manaTextPainter.height) / 2),
    );

    regenTextPainter.paint(
      canvas,
      Offset(size.width - 8 - regenTextPainter.width, (size.height - regenTextPainter.height) / 2),
    );
  }

  @override
  bool shouldRepaint(_ManaBarPainter oldDelegate) {
    return oldDelegate.mana != mana
        || oldDelegate.maxMana != maxMana
        || oldDelegate.manaRegen != manaRegen
        || oldDelegate.fillWidth != fillWidth
        || oldDelegate.textStyle != textStyle;
  }
}
