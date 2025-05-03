import 'package:auto_size_text/auto_size_text.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/screens/profile/invoker_style/invoker_style_view.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_image_paths.dart';
import '../../constants/locale_keys.g.dart';
import '../../enums/Bosses.dart';
import '../../extensions/context_extension.dart';
import '../../providers/boss_battle_provider.dart';
import '../../screens/profile/achievements/achievements_view.dart';
import '../../screens/profile/boss_gallery/boss_gallery_view.dart';
import '../../services/achievement_manager.dart';
import '../../services/user_manager.dart';
import '../app_outlined_button.dart';
import '../app_snackbar.dart';
import '../empty_box.dart';

class ProfileDialogContent extends StatelessWidget {
  const ProfileDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.64),
      child: Column(
        children: [
          achievements(context),
          const Divider(color: AppColors.amber, thickness: 1, height: 8),
          bossGallery(context),
          const Divider(color: AppColors.amber, thickness: 1, height: 8),
          invokerForm(context),
          const Divider(color: AppColors.amber, thickness: 1, height: 8),
          const EmptyBox.h8(),
          syncDataBtn(context),
          if (!context.isSmallPhone) const EmptyBox.h8(),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(ImagePaths.icAchievements, width: context.dynamicWidth(0.24),),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AutoSizeText(
                    LocaleKeys.mainMenu_achievements.locale,
                    style: TextStyle(fontSize: context.sp(18)),
                    maxLines: 1,
                  ),
                  AutoSizeText(
                    '$current/$totalCount',
                    style: TextStyle(fontSize: context.sp(14)),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.amber),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(Bosses.wraith_king.getImage, width: context.dynamicWidth(0.24),),
            Expanded(
              child: AutoSizeText(
                LocaleKeys.mainMenu_bossGallery.locale,
                style: TextStyle(fontSize: context.sp(18)),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.amber),
          ],
        ),
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BossGalleryView(),)),
    );
  }
  
  InkWell invokerForm(BuildContext context) {
    return InkWell(
      child: SizedBox(
        height: context.dynamicHeight(0.14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(ImagePaths.icInvokerHead, width: context.dynamicWidth(0.24),),
            Expanded(
              child: AutoSizeText(
                LocaleKeys.InvokerPersona_invokerPersona.locale,
                style: TextStyle(fontSize: context.sp(18)),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.amber),
          ],
        ),
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InvokerStyleView(),)),
    );
  }

  Widget syncDataBtn(BuildContext context) {
    return AppOutlinedButton(
      width: double.infinity,
      height: context.isSmallPhone ? 36 : null,
      onPressed: () async {
        final hasConnection = await InternetConnectionChecker().hasConnection;
        if (!hasConnection) {
          AppSnackBar.showSnackBarMessage(text: LocaleKeys.snackbarMessages_errorConnection.locale, snackBartype: SnackBarType.error);
          return;
        }
        
        if (DateTime.now().difference(UserManager.instance.lastSyncedDate) < UserManager.instance.waitSyncDuration) {
          AppSnackBar.showSnackBarMessage(
            text: LocaleKeys.snackbarMessages_syncDataWait.locale, 
            snackBartype: SnackBarType.info,
          );
          return;
        }

        UserManager.instance.updateSyncedDate();
        await UserManager.instance.saveUserToDb(UserManager.instance.user);
        AppSnackBar.showSnackBarMessage(
          text: LocaleKeys.snackbarMessages_syncDataSuccess.locale, 
          snackBartype: SnackBarType.success,
        );
        if (context.mounted) Navigator.pop(context);
      }, 
      title: LocaleKeys.commonGeneral_syncData.locale,
    );
  }
  
  Widget logoutbtn(BuildContext context) {
    return AppOutlinedButton(
      width: double.infinity,
      height: context.isSmallPhone ? 36 : null,
      onPressed: () async {
        await UserManager.instance.signOut();
        context.read<BossBattleProvider>().disposeGame(); //Reset Boss Mode Values
        AchievementManager.instance.updateAchievements(); //Reset achievements
        if (context.mounted) Navigator.pop(context);
      }, 
      title: LocaleKeys.commonGeneral_logout.locale,
    );
  }

}
