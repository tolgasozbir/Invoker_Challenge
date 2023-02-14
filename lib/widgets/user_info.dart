import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:dota2_invoker/services/firebase_auth_service.dart';
import 'package:dota2_invoker/widgets/custom_animated_dialog.dart';
import 'package:dota2_invoker/widgets/login_register_dialog_content.dart';
import '../extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';
import '../utils/user_records.dart';

class UserStatus extends StatefulWidget {
  UserStatus({super.key});

  @override
  State<UserStatus> createState() => _UserStatusState();
}

class _UserStatusState extends State<UserStatus> {
  final boxDecoration = BoxDecoration(
    color: AppColors.buttonSurfaceColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(width: 2),
  );

  @override
  Widget build(BuildContext context) {
    final username = UserRecords.user?.nickname ?? '${AppStrings.guest}';
    final currentExp = UserRecords.user?.exp ?? 0;
    final nextLevelExp = ((UserRecords.user?.level ?? 0) * 25) + 100;
    final minExp = 0;
    final level = 'Level ${(UserRecords.user?.level ?? 0)}';

    return InkWell(
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      onTap: () async {
        await CustomAnimatedDialog.showCustomDialog(
          dismissible: true,
          content: FirebaseAuthService.instance.getCurrentUser == null 
            ? LoginRegisterDialogContent()
            : ElevatedButton( //TODO:
              onPressed: () async {
                await FirebaseAuthService.instance.signOut();
                if (mounted) Navigator.pop(context);
              }, 
              child: Text("logout")
            )
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
