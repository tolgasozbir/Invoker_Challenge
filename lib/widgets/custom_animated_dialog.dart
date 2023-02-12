import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';
import '../main.dart';

class CustomAnimatedDialog {
  static Future<T?> showCustomDialog<T extends Object>({String? title, required Widget content, Widget? action, double? height, bool dismissible = false}) {
    return showGeneralDialog<T>(
      context: navigatorKey.currentContext!,
      barrierLabel: '',
      barrierDismissible: dismissible,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: Center(
              child: Container(
                height: height ?? navigatorKey.currentContext!.dynamicHeight(0.6),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: AppColors.dialogBgColor, 
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Text(title, style: TextStyle(fontSize: navigatorKey.currentContext?.sp(16) ?? 20, fontWeight: FontWeight.w500,),),
                      ),
                    Expanded(
                      flex: 9, 
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                        child: SingleChildScrollView(child: content),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight, 
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: action,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        anim.status == AnimationStatus.reverse 
          ? tween = Tween(begin: const Offset(-1, 0), end: Offset.zero)
          : tween = Tween(begin: const Offset(1, 0), end: Offset.zero);

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
