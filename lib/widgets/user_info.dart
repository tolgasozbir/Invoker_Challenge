import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:dota2_invoker/utils/user_records.dart';
import 'package:dota2_invoker/widgets/custom_animated_dialog.dart';
import 'package:dota2_invoker/widgets/login_register_dialog_content.dart';

import '../extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';

class UserStatus extends StatelessWidget {
  UserStatus({super.key});

  final boxDecoration = BoxDecoration(
    color: AppColors.buttonSurfaceColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(width: 2),
  );

  final username = UserRecords.userModel?.nickname ?? '${AppStrings.guest}';
  final currentExp = UserRecords.userModel?.exp ?? 0;
  final nextLevelExp = ((UserRecords.userModel?.level ?? 0) * 25) + 100;
  final minExp = 0;
  final level = 'Level ${(UserRecords.userModel?.level ?? 0)}';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      onTap: () async {
        await CustomAnimatedDialog.showCustomDialog(
          dismissible: true,
          content: LoginRegisterDialogContent()
        );
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
