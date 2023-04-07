import '../../utils/ads_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../enums/elements.dart';
import '../../extensions/widget_extension.dart';
import '../../providers/user_manager.dart';
import '../../widgets/menu_button.dart';
import '../../widgets/settings_button.dart';
import '../../widgets/talent_tree.dart';
import '../../widgets/user_info.dart';
import 'boss_mode/boss_mode_view.dart';
import 'challanger/challanger_view.dart';
import 'training/training_view.dart';
import 'with_timer/with_timer_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _bodyView(context),
      bottomNavigationBar: AdBanner()
    );
  }

  Widget _bodyView(BuildContext context) {
    var user = context.watch<UserManager>().user;
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
                    child: FadeInAnimation(child: menuBtns[index])
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Text(AppStrings.appVersion).wrapPadding(EdgeInsets.all(8))
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get menuBtns => [
    const MenuButton( 
      color: AppColors.quasColor, 
      imagePath: ImagePaths.quas, 
      title: AppStrings.titleTraining, 
      navigatePage: TrainingView(),
    ),
    const MenuButton(
      color: AppColors.wexColor,
      imagePath: ImagePaths.wex, 
      title: AppStrings.titleWithTimer, 
      navigatePage: WithTimerView(),
    ),
    const MenuButton(
      color: AppColors.exortColor,
      imagePath: ImagePaths.exort, 
      title: AppStrings.titleChallanger, 
      navigatePage: ChallangerView(),
    ),
    MenuButton.bossMode(
      color: AppColors.white,
      imagePath: Elements.invoke.getImage, 
      title: AppStrings.titleBossMode,
      navigatePage: BossModeView(),
    ),
    MenuButton.exit(
      backgroundColor: AppColors.exitBtnBgColor,
      color: AppColors.exitBtnColor,
      imagePath: ImagePaths.icInvokeLine, 
      title: AppStrings.quitGame,
    ),
  ];
}
