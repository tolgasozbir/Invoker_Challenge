import 'package:dota2_invoker_game/constants/locale_keys.g.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';

import 'combo/combo_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_image_paths.dart';
import '../../constants/app_strings.dart';
import '../../enums/elements.dart';
import '../../extensions/widget_extension.dart';
import '../../services/user_manager.dart';
import '../../utils/ads_helper.dart';
import '../../widgets/menu_button.dart';
import '../../widgets/settings_button.dart';
import '../../widgets/talent_tree.dart';
import '../../widgets/user_info.dart';
import 'boss_mode/boss_mode_view.dart';
import 'challanger/challanger_view.dart';
import 'training/training_view.dart';
import 'time_trial/time_trial_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _bodyView(context),
      bottomNavigationBar: const AdBanner(),
    );
  }

  Widget _bodyView(BuildContext context) {
    final user = context.watch<UserManager>().user;
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          children: [
            Row(
              children: [
                UserStatus(user: user).wrapAlign(Alignment.topLeft).wrapExpanded(flex: 2),
                TalentTree(user: user).wrapExpanded(),
                const SettingsButton().wrapAlign(Alignment.topRight).wrapExpanded(),
              ],
            ).wrapExpanded(flex: 3),
            ...List.generate(menuBtns.length, (index) => AnimationLimiter(
                child: AnimationConfiguration.staggeredList(
                  duration: const Duration(milliseconds: 1600),
                  position: index, 
                  child: SlideAnimation(
                    verticalOffset: -100,
                    child: FadeInAnimation(child: menuBtns[index]),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: const Text(AppStrings.appVersion).wrapPadding(const EdgeInsets.all(8)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get menuBtns => [
    MenuButton( 
      color: AppColors.quasColor,
      imagePath: ImagePaths.quas,
      title: LocaleKeys.mainMenu_titleTraining.locale,
      navigatePage: const TrainingView(),
    ),
    MenuButton(
      color: AppColors.wexColor,
      imagePath: ImagePaths.wex,
      title: LocaleKeys.mainMenu_titleWithTimer.locale,
      navigatePage: const TimeTrialView(),
    ),
    MenuButton(
      color: AppColors.exortColor,
      imagePath: ImagePaths.exort,
      title: LocaleKeys.mainMenu_titleChallenger.locale,
      navigatePage: const ChallangerView(),
    ),
    MenuButton(
      color: AppColors.comboBtnColor,
      imagePath: ImagePaths.icCombo,
      title: LocaleKeys.mainMenu_titleCombo.locale,
      navigatePage: const ComboView(),
    ),
    MenuButton(
      color: AppColors.white,
      imagePath: Elements.invoke.getImage,
      title: LocaleKeys.mainMenu_titleBossMode.locale,
      bannerTitle: 'Beta',
      animType: AnimType.Rotation,
      fit: BoxFit.contain,
      navigatePage: const BossModeView(),
    ),
  ];
}
