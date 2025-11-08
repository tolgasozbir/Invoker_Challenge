import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../enums/achievements.dart';
import '../extensions/iterable_extension.dart';
import 'empty_box.dart';

class OverlayManager {
  static OverlayEntry? _overlayEntry;

  static bool get isShowing => _overlayEntry?.mounted ?? false; 

  static void showOverlay(BuildContext context, Widget overlay) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (BuildContext context) => overlay);
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  static void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class AchievementsOverlay extends StatefulWidget {
  const AchievementsOverlay({super.key, required this.achievements});

  final List<Achievements> achievements;
  
  @override
  State<AchievementsOverlay> createState() => _AchievementsOverlayState();
}

class _AchievementsOverlayState extends State<AchievementsOverlay> with TickerProviderStateMixin {
  late final AnimationController _overlayController;
  late final Animation<double> _overlayAnimation;

  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;

  final _dismissibleKey = GlobalKey();
  
  final overlayHeight = 92.0;
  final animationDuration = const Duration(seconds: 1);
  final displayDuration = const Duration(seconds: 4);
  final displayW8Duration = const Duration(seconds: 3);
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

  void _reverseAnimationAndHideOverlay() {
    _overlayController.reverse().then((value) => _hideOverlay());
  }

  void _hideOverlay() {
    OverlayManager.hideOverlay();
  }

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
      Future.delayed(displayW8Duration, () {
        if (_overlayController.status == AnimationStatus.completed && OverlayManager.isShowing && mounted) {
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
            height: overlayHeight *  widget.achievements.length,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              gradient: overlayGradient,
              boxShadow: overlayShadow,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
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
        ...widget.achievements.mapIndexed((e, i) => _buildDetails(e, i)).toList()
          .animate(interval: 200.ms, delay: 200.ms)
          .fadeIn(curve: Curves.easeOutExpo, duration: 1000.ms)
          .blurXY(begin: 32, duration: 1000.ms)
          .slideY(begin: -0.4, duration: 1000.ms)
          //.shimmer(size: 1, duration: 4000.ms, delay: 2000.ms)
          .then(delay: 3000.ms)
          .fadeOut()
          ,
      ],
    );
  }

  Expanded _buildDetails(Achievements achievement, int index) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(achievement.getIconPath, width: 56, height: 56,).animate().shimmer(duration: 1000.ms, delay: 1000.ms, color: Colors.white),
                const EmptyBox.w8(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Virgil',
                        ),
                      ),
                      const EmptyBox.h8(),
                      const Text(
                        'Congratzz!!!', 
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Virgil',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (index != widget.achievements.length -1)
            const Divider(
              thickness: 1.6,
              indent: 16,
              endIndent: 16,
            ),
        ],
      ),
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




}
