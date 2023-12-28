import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';
import '../services/sound_manager.dart';

class AppDialogs {
  AppDialogs._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<T?> showSlidingDialog<T extends Object>({
    String? title,
    bool centerTitle = false,
    String? uid, 
    Widget? titleAct,
    required Widget content, 
    Widget? action, 
    double? height,
    bool showBackButton = false, 
    bool dismissible = false,
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
                } else {
                  SoundManager.instance.playMeepMerp();
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
                          Row(
                            children: [
                              if (showBackButton) const BackButton(),
                              if (title != null)
                                Expanded(
                                  child: Padding(
                                    padding: showBackButton ? EdgeInsets.zero : const EdgeInsets.fromLTRB(24, 20, 24, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: AutoSizeText(
                                            title,
                                            maxLines: 1,
                                            textAlign: centerTitle ? TextAlign.center : null,
                                            style: TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        if (uid != null) 
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: Text(
                                              uid.substring(0, 8), 
                                              style: TextStyle(
                                                fontSize: context.sp(16), 
                                                color: Colors.grey.withOpacity(0.6),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        if (uid == null && titleAct != null)
                                          Padding(
                                            padding: const EdgeInsets.only(right: 12, top: 12),
                                            child: titleAct,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Expanded(
                            flex: 9, 
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: content,
                              ),
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
    Color dialogBgColor = AppColors.dialogBgColor,
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
                  color: dialogBgColor,
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
                    if (action != null)
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
            child: child,
          ),
        );
      },
    );
  }

}
