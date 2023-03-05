import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/widget_extension.dart';
import '../../screens/profile/achievements/achievements_view.dart';
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
    var totalCount = AchievementManager.instance.achievements.length;
    var current = AchievementManager.instance.achievements.where((e) => e.isDone == true).toList().length;
    return InkWell(
      child: SizedBox(
        height: context.dynamicHeight(0.16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(ImagePaths.icAchievements),
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