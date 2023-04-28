import 'package:flutter/material.dart';

import '../../../../../constants/app_colors.dart';

enum Corner {left, middle, right}

class SocialIcon extends StatefulWidget {
  const SocialIcon({super.key, required this.icon, this.corner = Corner.middle, required this.onTap});

  final IconData icon;
  final Corner corner;
  final VoidCallback onTap;

  @override
  State<SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<SocialIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  final _duration = const Duration(milliseconds: 1000);
  final double _size = 40;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this, 
      duration: _duration, 
      reverseDuration: _duration,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 4, end: 12).animate(_animationController);
    _animationController.addListener(() => setState(() { }));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  BorderRadius _getCornerRadius(Corner corner) {
    switch (corner) {
      case Corner.left:
        return const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(2),
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(4),
        );
      case Corner.middle:
        return const BorderRadius.all(Radius.circular(2));
      case Corner.right:
        return const BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(2),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: _size,
        height: _size,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: _getCornerRadius(widget.corner),
          border: Border.all(color: AppColors.white),
          gradient: const LinearGradient(
            colors: AppColors.aboutMeGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: _animation.value,
              color: AppColors.white,
            ),
          ],
        ),
        child: Icon(widget.icon),
      ),
    );
  }
}
