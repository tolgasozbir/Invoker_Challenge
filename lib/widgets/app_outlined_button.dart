import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';
import '../extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:splash/splash.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key, 
    this.onPressed, 
    required this.title, 
    this.width, 
    this.height, 
    this.textStyle, 
    this.padding
  });

  final void Function()? onPressed;
  final String title;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed, 
      child: Text(title, style: textStyle ?? TextStyle(fontSize: context.sp(12))),
      style: OutlinedButton.styleFrom(
        splashFactory: WaveSplash.splashFactory,
        minimumSize: Size(
          width ?? 0, 
          height ?? 48
        ),
        //textStyle: TextStyle(fontSize: context.sp(12)),
        side: BorderSide(color: AppColors.outlinedBorder),
        foregroundColor: AppColors.outlinedSurface,
        backgroundColor: AppColors.buttonBgColor,
      ),
    ).wrapPadding(padding ?? EdgeInsets.zero);
  }
}
