import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';

class AppDialogs {
  AppDialogs._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<T?> showSlidingDialog<T extends Object>({
    String? title, 
    required Widget content, 
    Widget? action, 
    double? height, 
    bool dismissible = false
  }) {
    return showGeneralDialog<T?>(
      context: navigatorKey.currentContext!,
      barrierLabel: '',
      barrierDismissible: dismissible,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, __, ___) {
        return Scaffold(
          backgroundColor: AppColors.transparent,
          resizeToAvoidBottomInset: false,
          body: AnimatedPadding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            child: InkWell(
              splashColor: AppColors.transparent,
              highlightColor: AppColors.transparent,
              onTap: () {
                if (dismissible) {
                  Navigator.pop(context);
                }
              },
              child: SafeArea(
                child: Center(
                  child: InkWell(
                    splashColor: AppColors.transparent,
                    highlightColor: AppColors.transparent,
                    onTap: () { },
                    child: Container(
                      height: height ?? context.dynamicHeight(0.6),
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
                              child: Text(
                                title, 
                                style: TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.w500),
                              ),
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

  static Future<T?> showScaleDialog<T extends Object>({
    required Widget content,
    Widget? action,
    String? title,
    double? height,
    Duration duration = const Duration(milliseconds: 400),
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
  }) {
    return showGeneralDialog<T?>(
      context: navigatorKey.currentContext!,
      transitionDuration: duration,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: '',
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) { 
        return Material(
          type: MaterialType.transparency, 
          child: SafeArea(
            child: Center(
              child: Container(
                height: height ?? context.dynamicHeight(0.6),
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
                        child: Text(
                          title, 
                          style: TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.w500),
                        ),
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
        return Transform.scale(
          scaleX: 1,
          scaleY: anim.value,
          child: Opacity(
            opacity: anim.value,
            child: child
          ),
        );
      },
    );
  }




}
