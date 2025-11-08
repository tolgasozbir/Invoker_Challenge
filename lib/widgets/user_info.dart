import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/app_colors.dart';
import '../constants/locale_keys.g.dart';
import '../extensions/context_extension.dart';
import '../extensions/string_extension.dart';
import '../extensions/widget_extension.dart';
import '../models/user_model.dart';
import '../services/user_manager.dart';
import 'app_dialogs.dart';
import 'dialog_contents/login_register_dialog_content.dart';
import 'dialog_contents/profile_dialog_content.dart';
import 'sliders/progress_slider.dart';

class UserStatus extends StatelessWidget {
  const UserStatus({super.key, required this.user});

  final UserModel user;

  BoxDecoration get boxDecoration => BoxDecoration(
    color: AppColors.buttonBgColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: UserManager.instance.user.isPremium ? AppColors.amber.withValues(alpha: 0.32) : AppColors.black,
      width: 2,
    ),
  );
  
  String get username => user.username;
  double get currentExp => user.exp;
  double get nextLevelExp => UserManager.instance.nextLevelExp;
  String get level => '${LocaleKeys.mainMenu_level.locale} ${user.level}';
  bool get hasUid => user.uid != null;
  String? get miniMapIc => UserManager.instance.invokerType.miniMapIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      onTap: () => openDialog(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userIcon(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                username,
                maxLines: 1,
              ),
              expBar(),
              levelAndExp(),
            ],
          ).wrapPadding(const EdgeInsets.only(top: 8)).wrapExpanded(),
        ],
      ),
    );
  }

  void openDialog(BuildContext context) {
    AppDialogs.showSlidingDialog(
      dismissible: true,
      showBackButton: true,
      height: hasUid ? context.dynamicHeight(0.76) : 500,
      title:  hasUid ? LocaleKeys.mainMenu_profile.locale : '${LocaleKeys.formDialog_login.locale} & ${LocaleKeys.formDialog_register.locale}',
      uid: UserManager.instance.user.uid,
      content: hasUid
        ? const ProfileDialogContent()
        : const LoginRegisterDialogContent(),
    );
  }

  Container userIcon() {
    return Container(
      width: 64,
      height: 64,
      margin: const EdgeInsets.all(8),
      decoration: boxDecoration,
      child: hasUid && miniMapIc.isNotNullOrNoEmpty
        ? Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(miniMapIc!),
            if (UserManager.instance.user.isPremium)
              Positioned(
                top: 2,
                left: 0,
                child: Transform.rotate(
                  angle: 315 * pi / 180,
                  child: const Icon(
                    FontAwesomeIcons.crown, 
                    color: AppColors.amber,
                    size: 20,
                    shadows: [
                      Shadow(blurRadius: 8),
                      Shadow(blurRadius: 12),
                    ],
                  ).animate(onPlay: (controller) => controller.repeat()).shimmer(size: 1, duration: 1200.ms, delay: 3600.ms),
                ),
              ),
          ],
        )
        : const Icon(
            FontAwesomeIcons.userSecret, 
            shadows: [Shadow(blurRadius: 32)],
          ),
    );
  }

  Widget expBar() {
    return ProgressSlider(
      current: currentExp,
      max: nextLevelExp,
      activeColor: AppColors.expBarColor,
      inactiveColor: AppColors.expBarColor.withValues(alpha: 0.5),
    ).wrapPadding(const EdgeInsets.symmetric(vertical: 8));
  }

  Row levelAndExp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeText(
          level,
          maxLines: 1,
        ),
        AutoSizeText(
          '${currentExp.toStringAsFixed(0)}/${nextLevelExp.toStringAsFixed(0)}',
          maxLines: 1,
        ),
      ],
    );
  }

}
