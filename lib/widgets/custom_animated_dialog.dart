import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';
import '../main.dart';
import 'package:flutter/material.dart';

class CustomAnimatedDialog {
  static void showCustomDialog({required String title, required Widget content, Widget? action}) {
    showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierLabel: '',
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Scaffold(
          //resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: Container(
                height: navigatorKey.currentContext!.dynamicHeight(0.6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,),),
                    ),
                    Expanded(
                      flex: 9, 
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 12.0),
                        child: SingleChildScrollView(child: content),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight, 
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: action,
                      )
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: AppColors.dialogBgColor, 
                  borderRadius: BorderRadius.circular(16),
                ),
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