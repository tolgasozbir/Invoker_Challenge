import '../../providers/boss_provider.dart';
import '../../screens/profile/boss_gallery/boss_gallery_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/widget_extension.dart';
import '../../providers/user_manager.dart';
import '../../screens/profile/achievements/achievement_manager.dart';
import '../../screens/profile/achievements/achievements_view.dart';
import '../../services/app_services.dart';
import '../app_outlined_button.dart';

class ProfileDialogContent extends StatelessWidget {
  const ProfileDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.64)-80,
      child: Column(
        children: [
          achievements(context),
          Divider(color: AppColors.amber),
          bossGallery(context),
          Divider(color: AppColors.amber),
          Spacer(),
          logoutbtn(context),
        ],
      ),
    );
  }

  InkWell achievements(BuildContext context) {
    AchievementManager.instance.updateAchievements();
    var totalCount = AchievementManager.instance.achievements.length;
    var current = AchievementManager.instance.achievements.where((e) => e.isDone == true).toList().length;
    return InkWell(
      child: SizedBox(
        height: context.dynamicHeight(0.14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(ImagePaths.icAchievements),
            Column(
              children: [
                Text(AppStrings.achievements)
                  .wrapFittedBox()
                  .wrapExpanded(flex: 2),
                Text('$current/$totalCount',)
                  .wrapFittedBox()
                  .wrapExpanded(flex: 1),
                Spacer(),
              ],
            ).wrapExpanded(flex: 2),
            Icon(Icons.chevron_right, color: AppColors.amber).wrapCenter()
          ],
        ),
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AchievementsView(),)),
    );
  }
  
  InkWell bossGallery(BuildContext context) {
    return InkWell(
      child: SizedBox(
        height: context.dynamicHeight(0.14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ImagePaths.icInvokerHead).wrapExpanded(flex: 2),
            FittedBox(child: Text(AppStrings.bossGallery)).wrapExpanded(flex: 3),
            Icon(Icons.chevron_right, color: AppColors.amber),
          ],
        ),
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BossGalleryView(),)),
    );
  }

  Widget logoutbtn(BuildContext context) {
    var isLoggedIn = UserManager.instance.isLoggedIn();
    if (!isLoggedIn) return EmptyBox();
    return AppOutlinedButton(
      width: double.infinity,
      onPressed: () async {
        await AppServices.instance.firebaseAuthService.signOut();
        context.read<BossProvider>().disposeGame(); //Reset Boss Mode Values
        AchievementManager.instance.reset(); //Reset achievements
        if (context.mounted) Navigator.pop(context);
      }, 
      title: AppStrings.logout
    );
  }

}