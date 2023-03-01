import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/app_colors.dart';
import '../extensions/widget_extension.dart';
import '../models/user_model.dart';
import '../providers/user_manager.dart';
import 'app_dialogs.dart';
import 'dialog_contents/login_register_dialog_content.dart';
import 'dialog_contents/profile_dialog_content.dart';

class UserStatus extends StatefulWidget {
  UserStatus({super.key, required this.user});

  final UserModel user;

  @override
  State<UserStatus> createState() => _UserStatusState();
}

class _UserStatusState extends State<UserStatus> {
  final boxDecoration = BoxDecoration(
    color: AppColors.buttonBgColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(width: 2),
  );

  @override
  Widget build(BuildContext context) {
    final username = widget.user.username;
    final currentExp = widget.user.exp;
    final nextLevelExp = widget.user.level * 25;
    final minExp = 0;
    final level = 'Level ${widget.user.level}';

    return InkWell(
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      onTap: () async {
        await AppDialogs.showSlidingDialog(
          dismissible: true,
          content: UserManager.instance.isLoggedIn() 
            ? ProfileDialogContent()
            : LoginRegisterDialogContent()
        );
        if (mounted) setState(() { });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: SliderComponentShape.noThumb,
                  overlayShape: SliderComponentShape.noThumb,
                  activeTrackColor: AppColors.expBarColor,
                  inactiveTrackColor: AppColors.expBarColor.withOpacity(0.5),
                ),
                child: Slider(
                  value: currentExp,
                  max: nextLevelExp.toDouble(),
                  min: minExp.toDouble(),
                  onChanged: (value) { },
                ),
              ).wrapPadding(const EdgeInsets.symmetric(vertical: 8)),
              Row(
                children: [
                  Text(level),
                  Spacer(),
                  Text(currentExp.toStringAsFixed(0) + '/' + '$nextLevelExp')
                ],
              )
            ],
          ).wrapPadding(const EdgeInsets.only(top: 8)).wrapExpanded(),
        ],
      ),
    );
  }

}
