import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../extensions/context_extension.dart';
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
    border: Border.all(width: 2),
  );
  
  String get username => user.username;
  double get currentExp => user.exp;
  double get nextLevelExp => UserManager.instance.nextLevelExp;
  String get level => '${AppStrings.level} ${user.level}';
  bool get isLoggedIn => UserManager.instance.isLoggedIn();

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
              Text(username),
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
      height: isLoggedIn ? context.dynamicHeight(0.64) : 460,
      title:  isLoggedIn ? AppStrings.profile : '${AppStrings.login}&${AppStrings.register}',
      uid: UserManager.instance.user.uid,
      content: isLoggedIn
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
      child: const Icon(
        FontAwesomeIcons.userSecret, 
        shadows: [
          Shadow(blurRadius: 32,),
        ],
      ),
    );
  }

  Widget expBar() {
    return ProgressSlider(
      current: currentExp,
      max: nextLevelExp,
      activeColor: AppColors.expBarColor,
      inactiveColor: AppColors.expBarColor.withOpacity(0.5),
    ).wrapPadding(const EdgeInsets.symmetric(vertical: 8));
  }

  Row levelAndExp() {
    return Row(
      children: [
        Text(level).wrapFittedBox(),
        const Spacer(),
        Text('${currentExp.toStringAsFixed(0)}/${nextLevelExp.toStringAsFixed(0)}').wrapFittedBox()
      ],
    );
  }

}
