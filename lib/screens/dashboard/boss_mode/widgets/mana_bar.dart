import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../extensions/context_extension.dart';
import '../../../../extensions/widget_extension.dart';
import '../../../../providers/boss_provider.dart';

class ManaBar extends StatefulWidget {
  const ManaBar({super.key});

  @override
  State<ManaBar> createState() => _ManaBarState();
}

class _ManaBarState extends State<ManaBar> {
  @override
  Widget build(BuildContext context) {
    const margin = EdgeInsets.symmetric(horizontal: 24);
    final TextStyle textStyle = TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.bold);
    final double height = context.dynamicHeight(0.048);
    final double width = context.width;
    return Stack(
      children: [
        Container(
          margin: margin,
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xFF20385C),
          ),
        ),
        Consumer<BossProvider>(
          builder: (context, provider, child) {
            final double manaBarWidth = context.dynamicWidth(0.88) * provider.manaBarWidthMultiplier;
            return AnimatedContainer(
              duration: const Duration(seconds: 1),
              margin: margin,
              width: manaBarWidth < 0 ? 0 : manaBarWidth,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF385AB4),
                    Color(0xFF4870E0),
                    Color(0xFF385AB4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            );
          },
        ),
        Container(
          margin: margin,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(width: 1.2),
          ),
          child: Consumer<BossProvider>(
            builder: (context, provider, child) => Row(
              children: [
                const Spacer(),
                Row(
                  children: [
                    NumberAnimation(
                      key: ObjectKey(provider.currentMana),
                      initialValue: provider.currentMana, 
                      increment: provider.manaRegen,
                      maxValue: provider.maxMana,
                      textStyle: textStyle,
                    ),
                    Text('/', style: textStyle),
                    Text(provider.maxMana.toStringAsFixed(0), style: textStyle),
                  ],
                ),
                Text('+${provider.manaRegen.toStringAsFixed(1)}', style: textStyle).wrapAlign(Alignment.centerRight).wrapExpanded(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NumberAnimation extends StatefulWidget {
  final double initialValue;
  final double increment;
  final double maxValue;
  final TextStyle textStyle;

  const NumberAnimation({super.key, required this.initialValue, required this.increment, required this.textStyle, required this.maxValue});

  @override
  State<NumberAnimation> createState() => _NumberAnimationState();
}

class _NumberAnimationState extends State<NumberAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _currentValue;

  @override
  void initState() {
    super.initState();

    _currentValue = widget.initialValue;

    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);

    _animation = Tween(begin: _currentValue, end: _currentValue + widget.increment)
        .animate(_controller)..addListener(() { 
          setState(() {});
        });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Text(
        _animation.value > widget.maxValue 
          ? widget.maxValue.toStringAsFixed(0)
          : _animation.value.toStringAsFixed(0),
        style: widget.textStyle,
      ),
    );
  }
}
