import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/boss_provider.dart';

class ManaBar extends StatefulWidget {
  const ManaBar({super.key});

  @override
  State<ManaBar> createState() => _ManaBarState();
}

class _ManaBarState extends State<ManaBar> {
  final margin = EdgeInsets.symmetric(horizontal: 24);
  TextStyle get textStyle => TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.bold);
  double get height => context.dynamicHeight(0.048);
  double get width => context.width;
  double get manaBarWidth => context.dynamicWidth(0.88) * context.watch<BossProvider>().manaBarWidthMultiplier;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: margin,
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Color(0xFF20385C),
          ),
        ),
        AnimatedContainer(
          duration: Duration(seconds: 1),
          margin: margin,
          width: manaBarWidth < 0 ? 0 : manaBarWidth,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              colors: [
                Color(0xFF385AB4),
                Color(0xFF4870E0),
                Color(0xFF385AB4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Container(
          margin: margin,
          padding: EdgeInsets.symmetric(horizontal: 8),
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(width: 1.2)
          ),
          child: Row(
            children: [
              Spacer(),
              Row(
                children: [
                  NumberAnimation(
                    key: UniqueKey(),
                    initialValue: context.watch<BossProvider>().currentMana, 
                    increment: context.watch<BossProvider>().baseManaRegen,
                    maxValue: context.watch<BossProvider>().totalMana,
                    textStyle: textStyle,
                  ),
                  Text("/", style: textStyle),
                  Text(context.watch<BossProvider>().totalMana.toStringAsFixed(0), style: textStyle),
                ],
              ),
              Text("+"+context.watch<BossProvider>().baseManaRegen.toStringAsFixed(1), style: textStyle).wrapAlign(Alignment.centerRight).wrapExpanded(),
            ],
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

  NumberAnimation({super.key, required this.initialValue, required this.increment, required this.textStyle, required this.maxValue});

  @override
  _NumberAnimationState createState() => _NumberAnimationState();
}

class _NumberAnimationState extends State<NumberAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _currentValue;

  @override
  void initState() {
    super.initState();

    _currentValue = widget.initialValue;

    _controller = AnimationController(duration: Duration(seconds: 1), vsync: this);

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

  void update({required double initialValue, required double increment}) {
    setState(() {
      _currentValue = initialValue;
      _animation = Tween(begin: _currentValue, end: _currentValue + increment)
          .animate(_controller)
            ..addListener(() {
              setState(() {});
            });
    });

    _controller.reset();
    _controller.forward();
  }
}