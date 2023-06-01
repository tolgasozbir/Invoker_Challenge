import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_image_paths.dart';
import '../../constants/app_strings.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/widget_extension.dart';
import '../../providers/boss_battle_provider.dart';
import '../../services/user_manager.dart';
import '../../services/achievement_manager.dart';
import '../../screens/profile/achievements/achievements_view.dart';
import '../../screens/profile/boss_gallery/boss_gallery_view.dart';
import '../../services/app_services.dart';
import '../app_outlined_button.dart';
import '../app_snackbar.dart';
import '../empty_box.dart';

class ProfileDialogContent extends StatelessWidget {
  const ProfileDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.64)-80,
      child: Column(
        children: [
          achievements(context),
          const Divider(color: AppColors.amber),
          bossGallery(context),
          const Divider(color: AppColors.amber),
          const Spacer(),
          syncDataBtn(context),
          const EmptyBox.h8(),
          logoutbtn(context),
        ],
      ),
    );
  }

  InkWell achievements(BuildContext context) {
    AchievementManager.instance.updateAchievements();
    final totalCount = AchievementManager.instance.achievements.length;
    final current = AchievementManager.instance.achievements.where((e) => e.isDone == true).toList().length;
    return InkWell(
      child: SizedBox(
        height: context.dynamicHeight(0.14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(ImagePaths.icAchievements),
            Column(
              children: [
                const Text(AppStrings.achievements)
                  .wrapFittedBox()
                  .wrapExpanded(flex: 2),
                Text('$current/$totalCount',)
                  .wrapFittedBox()
                  .wrapExpanded(flex: 1),
                const Spacer(),
              ],
            ).wrapExpanded(flex: 2),
            const Icon(Icons.chevron_right, color: AppColors.amber).wrapCenter()
          ],
        ),
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AchievementsView(),)),
    );
  }
  
  InkWell bossGallery(BuildContext context) {
    return InkWell(
      child: SizedBox(
        height: context.dynamicHeight(0.14),
        child: Row(
          children: [
            Image.asset(ImagePaths.icInvokerHead).wrapExpanded(flex: 2),
            const FittedBox(child: Text(AppStrings.bossGallery)).wrapExpanded(flex: 3),
            const Icon(Icons.chevron_right, color: AppColors.amber),
          ],
        ),
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BossGalleryView(),)),
    );
  }

  Widget syncDataBtn(BuildContext context) {
    return AppOutlinedButton(
      width: double.infinity,
      onPressed: () async {
        final hasConnection = await InternetConnectionChecker().hasConnection;
        if (!hasConnection) {
          AppSnackBar.showSnackBarMessage(text: AppStrings.errorConnection, snackBartype: SnackBarType.error);
          return;
        }
        
        if (DateTime.now().difference(UserManager.instance.lastSyncedDate) < UserManager.instance.waitSyncDuration) {
          AppSnackBar.showSnackBarMessage(text: AppStrings.syncDataWait, snackBartype: SnackBarType.info);
          return;
        }

        UserManager.instance.updateSyncedDate();
        await AppServices.instance.databaseService.createOrUpdateUser(UserManager.instance.user);
        AppSnackBar.showSnackBarMessage(text: AppStrings.syncDataSuccess, snackBartype: SnackBarType.success);
        if (context.mounted) Navigator.pop(context);
      }, 
      title: AppStrings.syncData,
    );
  }
  
  Widget logoutbtn(BuildContext context) {
    return AppOutlinedButton(
      width: double.infinity,
      onPressed: () async {
        await AppServices.instance.firebaseAuthService.signOut();
        context.read<BossBattleProvider>().disposeGame(); //Reset Boss Mode Values
        AchievementManager.instance.reset(); //Reset achievements
        if (context.mounted) Navigator.pop(context);
      }, 
      title: AppStrings.logout,
    );
  }

}
