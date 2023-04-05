import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:splash/splash.dart';

import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';
import '../extensions/widget_extension.dart';
import '../providers/game_provider.dart';
import '../screens/dashboard/loading_view.dart';
import '../services/sound_manager.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({
    required this.color,
    required this.imagePath,
    required this.title,
    required this.navigatePage,
    this.backgroundColor,
    this.isBtnBossMode = false,
    this.isBtnExit = false,
    super.key, 
  }) : assert(isBtnBossMode == false), assert(isBtnExit == false);

  const MenuButton.bossMode({
    super.key, 
    required this.color, 
    this.backgroundColor, 
    required this.imagePath, 
    required this.title, 
    this.navigatePage,
    this.isBtnBossMode = true,
    this.isBtnExit = false,
  }) : assert(isBtnBossMode == true), assert(isBtnExit == false) ;  
  
  const MenuButton.exit({
    super.key, 
    required this.color, 
    this.backgroundColor, 
    required this.imagePath, 
    required this.title, 
    this.navigatePage,
    this.isBtnBossMode = false,
    this.isBtnExit = true,
  }) : assert(isBtnBossMode == false), assert(isBtnExit == true), assert(navigatePage == null);

  final Color color;
  final Color? backgroundColor;
  final String imagePath;
  final String title;
  final Widget? navigatePage;
  final bool isBtnBossMode;
  final bool isBtnExit;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;

  @override
  void initState() {
    if (widget.isBtnBossMode) {
      controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 4000));
      animation = CurvedAnimation(parent: controller!, curve: Curves.linear);
      controller!.repeat();
    }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  void _goToGameScreen() {
    if (widget.navigatePage == null) return;
    SoundManager.instance.playLoadingSound();
    context.read<GameProvider>().resetTimer();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoadingView(page: widget.navigatePage!)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
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
        onPressed: widget.isBtnExit ? _closeApp : _goToGameScreen,
        child: buttonSurface(),
      ),
    );
  }

  Row buttonSurface() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.isBtnBossMode) 
          RotationTransition(
            turns: animation!, 
            child: circleImage(BoxFit.contain),
          ) 
        else if (widget.isBtnExit)
          circleImage(BoxFit.contain).scaleWidget(1.2)
        else 
          circleImage(BoxFit.cover),
        Text(
          '${widget.title}  ',
          style: TextStyle(fontSize: context.sp(16)),
        ),
      ],
    );
  }

  Container circleImage(BoxFit? fit) {
    return Container(
      height: context.dynamicHeight(0.1),
      width: context.dynamicWidth(0.12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: AssetImage(widget.imagePath),
        fit: fit,
        ),
      ),
    );
  }
}
