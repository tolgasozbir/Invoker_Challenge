import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../extensions/widget_extension.dart';

enum SnackBarType{
  info,
  success,
  error,
}

class AppSnackBar {
  AppSnackBar._();

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBarMessage({
    required String text, 
    Duration duration = const Duration(milliseconds: 2400), 
    required SnackBarType snackBartype,
  }) {
    return scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        clipBehavior: Clip.none,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.transparent,
        elevation: 0,
        content: _SnacBarContent(message: text, type: snackBartype),
      ),
    );
  }
}

class _SnacBarContent extends StatefulWidget {
  const _SnacBarContent({required this.type,required this.message,});

  final SnackBarType type;
  final String message;

  @override
  State<_SnacBarContent> createState() => _SnacBarContentState();
}

class _SnacBarContentState extends State<_SnacBarContent> with TickerProviderStateMixin {
  late final String snackBarTitle;
  late final Color snackBarColor;

  late final AnimationController _controller;
  late final Animation<Offset> _animation;
  final animOffset = Tween<Offset>(begin: const Offset(0, 10), end: Offset.zero);

  final double SnackBarHeight = 92;
  final double bgIconSize = 64;
  double get position => (SnackBarHeight - bgIconSize) / 2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animation = animOffset.animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();

    switch (widget.type) {
      case SnackBarType.info:
        snackBarColor = AppColors.infoColor;
        snackBarTitle = AppStrings.sbInfo;
        break;
      case SnackBarType.success:
        snackBarColor = AppColors.successColor;
        snackBarTitle = AppStrings.sbSuccess;
        break;
      case SnackBarType.error:
        snackBarColor = AppColors.errorColor;
        snackBarTitle = AppStrings.sbError;
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      child: SlideTransition(
        position: _animation,
        child: Container(
          height: SnackBarHeight,
          decoration: BoxDecoration(
            color: snackBarColor,
            border: Border.all(width: 1.6),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(5),
            ),
          ),
          child: Stack(
            children: [
              quas(),
              wex(),
              exort(),
              invokerLogo(),
              dota2Logo(),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$snackBarTitle!',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.message,
                        style: const TextStyle(fontSize: 14,color: AppColors.white), 
                        maxLines: 2, 
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ).wrapPadding(EdgeInsets.only(left: 8)).wrapExpanded(),
                ],
              ).wrapPadding(const EdgeInsets.all(16)),
            ],
          ),
        ),
      ),
    );
  }

  Positioned invokerLogo() {
    var rnd = Random();
    var index = rnd.nextInt(ImagePaths.svgInvokerLogo.length);
    var svg = ImagePaths.svgInvokerLogo[index];
    return Positioned(
      right: 0,
      child: SvgPicture.asset(
        svg,
        color: AppColors.svgGrey.withOpacity(0.64),
        width: bgIconSize+32,
      ),
    );
  }

  Positioned dota2Logo() {
    return Positioned(
      left: position,
      top: position,
      child: SvgPicture.asset(
        ImagePaths.svgDota2Logo,
        color: AppColors.svgGrey.withOpacity(0.24),
        width: bgIconSize,
      ),
    );
  }
  
  Positioned quas() {
    return Positioned(
      left: 0,
      right: 64,
      top: position/2,
      child: SvgPicture.asset(
        ImagePaths.svgQuas,
        color: AppColors.quasColor.withOpacity(0.72),
        width: bgIconSize/2,
      ),
    );
  }
  
  Positioned wex() {
    return Positioned(
      left: 0,
      right: 0,
      top: position/2,
      child: SvgPicture.asset(
        ImagePaths.svgWex,
        color: AppColors.wexColor.withOpacity(0.72),
        width: bgIconSize/2,
      ),
    );
  }
  
  Positioned exort() {
    return Positioned(
      left: 64,
      right: 0,
      top: position/2,
      child: SvgPicture.asset(
        ImagePaths.svgExort,
        color: AppColors.exortColor.withOpacity(0.72),
        width: bgIconSize/2,
      ),
    );
  }  
  
}
