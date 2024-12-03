import 'dart:async';

import 'package:flutter/material.dart';

//TODO 3
class CountdownOverlay extends StatefulWidget {
  final String totalTime;
  final String remainingTime;

  const CountdownOverlay({super.key, required this.totalTime, required this.remainingTime});
  
  @override
  State<CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay> with TickerProviderStateMixin {
  late final AnimationController _overlayController;
  late final Animation<double> _overlayAnimation;

  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;

  final _dismissibleKey = GlobalKey();
  
  final overlayHeight = 128.0;
  final animationDuration = const Duration(seconds: 1);
  final displayDuration = const Duration(seconds: 10);
  final overlayGradient = const LinearGradient(
    colors: [
      Color(0xFF546E7A), 
      Colors.black,
    ],
  );
  final overlayShadow = const [
    BoxShadow(
      color: Color(0xFF1565C0), 
      offset: Offset(0.0, 2.0), 
      blurRadius: 3.0,
    ),
  ];

  void _configureProgressIndicatorAnimation() {
    _progressController = AnimationController(
      vsync: this, 
      duration: displayDuration,
    )..forward();
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(_progressController);
  }

  void _configureOverlayAnimation() {
    _overlayController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    _overlayAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.fastEaseInToSlowEaseOut),
    );
    _overlayController.forward().then((_) {
      Future.delayed(displayDuration, () {
        if (_overlayController.status == AnimationStatus.completed && OverlayManager.isShowing) {
          _overlayController.reverse().then((_) => _hideOverlay());
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _configureOverlayAnimation();
    _configureProgressIndicatorAnimation();
  }

  @override
  void dispose() {
    _overlayController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _buildAnimation(),
    );
  }

  Widget _buildAnimation() {
    return AnimatedBuilder(
      animation: _overlayAnimation, 
      builder: (context, child) => Transform.translate(
        offset: Offset(0.0, overlayHeight * _overlayAnimation.value),
        child: _buildGestureDetector(),
      ),
    );
  }

  Widget _buildGestureDetector() {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _reverseAnimationAndHideOverlay();
        }
      },
      onTap: () {
        _reverseAnimationAndHideOverlay();
      },
      child: _buildOverlayBody(),
    );
  }

  Widget _buildOverlayBody() {
    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.topCenter,
        child: Dismissible(
          key: _dismissibleKey,
          direction: DismissDirection.horizontal,
          resizeDuration: null,
          onDismissed: (direction) {
            _hideOverlay();
          },
          child: Container(
            width: double.maxFinite,
            height: overlayHeight,
            decoration: BoxDecoration(
              gradient: overlayGradient,
              boxShadow: overlayShadow,
            ),
            child: _buildBodyView(),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyView() {
    return Column(
      children: [
        _buildProgressbar(),
        const Expanded(
          child: Row(
            children: [

            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressbar() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) => LinearProgressIndicator(
        backgroundColor: Colors.blueGrey,
        color: Colors.amber,
        value: _progressAnimation.value,
      ),
    );
  }


  void _reverseAnimationAndHideOverlay() {
    _overlayController.reverse().then((value) => _hideOverlay());
  }

  void _hideOverlay() {
    OverlayManager.hideOverlay();
  }

}

class OverlayManager {
  static OverlayEntry? _overlayEntry;

  static bool isShowing = false; 

  static void showOverlay(BuildContext context, CountdownOverlay overlay) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => overlay,
      );
      isShowing = true;
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  static void hideOverlay() {
    isShowing = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
