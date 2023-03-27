import 'package:flutter/material.dart';

class CooldownAnimation extends StatefulWidget {
  final Widget child;
  final double remainingCd;
  final Duration duration; 
  final double size;

  const CooldownAnimation({super.key, required this.child, required this.duration, required this.remainingCd, required this.size});

  @override
  _CooldownAnimationState createState() => _CooldownAnimationState();
}

class _CooldownAnimationState extends State<CooldownAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _opacity;
  late Animation<double> _durationText;

  double normalize(double a, double b) {
    var sum = a+b;
    var res = (sum-a) / sum;
    return res;
  }

  double calculateCooldown(double cooldownDuration, double remainingCd) {
    if (remainingCd <= 0) return 1.0;
    double result = 1 - (((remainingCd * 100) / cooldownDuration) / 100);
    return result;
  }

  void restart() {
    initState();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller);
    
    _opacity = Tween<double>(
      begin: 0.72,
      end: 0.24,
    ).animate(_controller);
  
    _durationText = Tween<double>(
      begin: widget.duration.inSeconds.toDouble(),
      end: 0.0,
    ).animate(_controller);
 
    _controller.value = calculateCooldown(widget.duration.inSeconds.toDouble(), widget.remainingCd);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CooldownAnimation oldWidget) {
    if (oldWidget.remainingCd != widget.remainingCd) {
      _controller.value = calculateCooldown(widget.duration.inSeconds.toDouble(), widget.remainingCd);
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            return Stack(
              children: [
                Opacity(
                  opacity: _opacity.value == 0.0 ? 1.0 : _opacity.value,
                  child: Container(
                    color: Colors.black,
                    height: _animation.value * widget.size,
                    width: widget.size,
                  ),
                ),
                AnimatedCrossFade(
                  sizeCurve: Curves.decelerate,
                  alignment: Alignment.center,
                  crossFadeState: _durationText.value != 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 400), 
                  firstChild: SizedBox.square(
                    dimension: widget.size,
                    child: Center(
                      child: Text(
                        _durationText.value.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          shadows: List.generate(6, (index) => Shadow(blurRadius: 8)),
                        ),
                      ),
                    ),
                  ),
                  secondChild: SizedBox.square(dimension: widget.size),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
