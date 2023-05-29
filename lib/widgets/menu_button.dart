import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splash/splash.dart';

import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';
import '../providers/game_provider.dart';
import '../screens/dashboard/loading_view.dart';
import '../services/sound_manager.dart';
import '../utils/ads_helper.dart';
import '../utils/fade_in_page_animation.dart';

enum AnimType {
  Rotation,
  Scale,
  None,
}

class MenuButton extends StatefulWidget {
  const MenuButton({
    super.key, 
    required this.color,
    required this.imagePath,
    required this.title,
    required this.navigatePage,
    this.bannerTitle,
    this.backgroundColor,
    this.animType = AnimType.None, 
    this.fit = BoxFit.cover, 
  });

  final Color color;
  final Color? backgroundColor;
  final String imagePath;
  final BoxFit? fit;
  final String title;
  final Widget? navigatePage;
  final AnimType animType;
  final String? bannerTitle;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;

  void _initAnimation() {
    switch (widget.animType) {
      case AnimType.Rotation:
        controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 4000));
        animation = CurvedAnimation(parent: controller!, curve: Curves.linear);
        controller!.repeat();
        return;
      case AnimType.Scale:
        controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
        animation = Tween(begin: 1.0, end: 0.9).animate(controller!);
        controller!.repeat(reverse: true);
        return;
      case AnimType.None: return;
    }
  }

  @override
  void initState() {
    _initAnimation();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _goToGameScreen() async {
    if (widget.navigatePage == null) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    context.read<GameProvider>().resetTimer();

    AdsHelper.instance.adCounter++;
    if (AdsHelper.instance.interstitialAd != null && AdsHelper.instance.adCounter % 3 == 0) {
      await AdsHelper.instance.interstitialAd!.show();
      Navigator.push(context, fadeInPageRoute(widget.navigatePage!));
      return;
    }

    SoundManager.instance.playLoadingSound();
    Navigator.push(context, fadeInPageRoute(LoadingView(page: widget.navigatePage!)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: widget.bannerTitle == null
        ? button()
        : widget.animType == AnimType.Scale
          ? ScaleTransition(
              scale: animation!,
              child: withBanner(),
            )
          : withBanner(),
    );
  }

  Banner withBanner() {
    return Banner(
      message: widget.bannerTitle!,
      location: BannerLocation.bottomEnd,
      child: button(),
    );
  }

  SizedBox button() {

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: widget.backgroundColor ?? AppColors.buttonBgColor,
      elevation: 10,
      shadowColor: widget.color,
      splashFactory: WaveSplash.splashFactory,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: widget.color),
      ),
    );

    return SizedBox(
      width: context.dynamicWidth(0.8),
      child:  ElevatedButton(
        style: buttonStyle,
        onPressed: _goToGameScreen,
        child: buttonSurface(),
      ),
    );
  }

  Row buttonSurface() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.animType == AnimType.Rotation)
          RotationTransition(
            turns: animation!, 
            child: circleImage(),
          )
        else circleImage(),
        Text(
          '${widget.title}  ',
          style: TextStyle(fontSize: context.sp(16)),
        ),
      ],
    );
  }

  Container circleImage() {
    return Container(
      height: context.dynamicHeight(0.1),
      width: context.dynamicWidth(0.12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(widget.imagePath),
          fit: widget.fit,
        ),
      ),
    );
  }
}
