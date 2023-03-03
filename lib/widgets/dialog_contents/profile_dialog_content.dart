import 'package:dota2_invoker/constants/app_colors.dart';
import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:dota2_invoker/screens/profile/achievements/achievements_view.dart';
import 'package:flutter/material.dart';

import '../../screens/profile/achievements/achievement_manager.dart';

class ProfileDialogContent extends StatelessWidget {
  const ProfileDialogContent({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        achievements(context),
        Divider(color: AppColors.amber)
      ],
    );
  }

  InkWell achievements(BuildContext context) {
    final ic_achievements = "assets/images/achievements/ic_achievements.png";
    var totalCount = AchievementManager.instance.achievements.length;
    var current = AchievementManager.instance.achievements.where((e) => e.isDone == true).toList().length;
    return InkWell(
      child: SizedBox(
        height: context.dynamicHeight(0.16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(ic_achievements),
            Column(
              children: [
                FittedBox(child: Text(AppStrings.achievements)).wrapExpanded(flex: 2),
                FittedBox(child: Text('$current/$totalCount',)).wrapExpanded(flex: 1),
                Spacer(),
              ],
            ).wrapExpanded(flex: 2),
            Icon(Icons.chevron_right, color: Color.fromARGB(255, 251, 138, 176),).wrapCenter()
          ],
        ),
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AchievementsView(),)),
    );
  }

}