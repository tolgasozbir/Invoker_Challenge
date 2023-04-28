import 'package:flutter/material.dart';
import 'package:splash/splash.dart';

import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';
import '../extensions/widget_extension.dart';
import '../services/sound_manager.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key, 
    this.onPressed, 
    required this.title, 
    this.width, 
    this.height, 
    this.bgColor,
    this.textStyle, 
    this.padding,
    this.isButtonActive = true,
  });

  final void Function()? onPressed;
  final String title;
  final double? width;
  final double? height;
  final Color? bgColor;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final bool isButtonActive;

  Color _buttonStateColor(Color color) => isButtonActive ? color : color.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isButtonActive ? onPressed : () => SoundManager.instance.playMeepMerp(),
      style: OutlinedButton.styleFrom(
        splashFactory: WaveSplash.splashFactory,
        minimumSize: Size(
          width ?? 0, 
          height ?? 48,
        ),
        //textStyle: TextStyle(fontSize: context.sp(12)),
        side: BorderSide(color: _buttonStateColor(AppColors.outlinedBorder)),
        foregroundColor: _buttonStateColor(AppColors.outlinedSurface),
        backgroundColor: _buttonStateColor(bgColor ?? AppColors.buttonBgColor),
      ), 
      child: FittedBox(
        child: Text(
          title, 
          style: textStyle ?? TextStyle(fontSize: context.sp(12)),
        ),
      ),
    ).wrapPadding(padding ?? EdgeInsets.zero);
  }
}
