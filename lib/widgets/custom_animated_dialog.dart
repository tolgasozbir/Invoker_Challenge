import 'package:dota2_invoker/constants/app_colors.dart';
import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CustomAnimatedDialog {
  static void showCustomDialog({required BuildContext context, required Widget content}) {
    showGeneralDialog(
      context: context,
      barrierLabel: '',
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Center(
            child: Container(
              height: context.dynamicHeight(0.6),
              child: SizedBox.expand(child: content),
              margin: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.dialogBgColor, 
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        anim.status == AnimationStatus.reverse 
          ? tween = Tween(begin: Offset(-1, 0), end: Offset.zero)
          : tween = Tween(begin: Offset(1, 0), end: Offset.zero);

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}