import 'dart:math';

import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';
import '../constants/app_image_paths.dart';
import '../constants/locale_keys.g.dart';
import '../extensions/widget_extension.dart';

enum SnackBarType{
  info,
  success,
  error,
}

class AppSnackBar {
  AppSnackBar._();

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBarMessage({
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

  final double snackBarHeight = 92;
  final double bgIconSize = 64;
  double get position => (snackBarHeight - bgIconSize) / 2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animation = animOffset.animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();

    switch (widget.type) {
      case SnackBarType.info:
        snackBarColor = AppColors.infoColor;
        snackBarTitle = LocaleKeys.snackbarMessages_sbInfo.locale;
      case SnackBarType.success:
        snackBarColor = AppColors.successColor;
        snackBarTitle = LocaleKeys.snackbarMessages_sbSuccess.locale;
      case SnackBarType.error:
        snackBarColor = AppColors.errorColor;
        snackBarTitle = LocaleKeys.snackbarMessages_sbError.locale;
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
          height: snackBarHeight,
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
                  ).wrapPadding(const EdgeInsets.only(left: 8)).wrapExpanded(),
                ],
              ).wrapPadding(const EdgeInsets.all(16)),
            ],
          ),
        ),
      ),
    );
  }

  Positioned invokerLogo() {
    final rnd = Random();
    final index = rnd.nextInt(ImagePaths.svgInvokerLogo.length);
    final svg = ImagePaths.svgInvokerLogo[index];
    return Positioned(
      right: 0,
      child: SvgPicture.asset(
        svg,
        colorFilter: ColorFilter.mode(
          AppColors.svgGrey.withOpacity(0.64), 
          BlendMode.srcIn,
        ),
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
        colorFilter: ColorFilter.mode(
          AppColors.svgGrey.withOpacity(0.24), 
          BlendMode.srcIn,
        ),
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
        colorFilter: ColorFilter.mode(
          AppColors.quasColor.withOpacity(0.72),
          BlendMode.srcIn,
        ),
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
        colorFilter: ColorFilter.mode(
          AppColors.wexColor.withOpacity(0.72),
          BlendMode.srcIn,
        ),
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
        colorFilter: ColorFilter.mode(
          AppColors.exortColor.withOpacity(0.72),
          BlendMode.srcIn,
        ),
        width: bgIconSize/2,
      ),
    );
  }  
  
}
