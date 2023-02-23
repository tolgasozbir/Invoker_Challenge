import 'package:flutter/material.dart';
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
            ).wrapExpanded(),
            ...menuBtns,
            const Spacer(),
          ],
        ),
      ),
    );
  }

  List<Widget> get menuBtns => [
    const MenuButton(
      fadeInDuration: Duration(milliseconds: 1000), 
      color: AppColors.quasColor, 
      imagePath: ImagePaths.quas, 
      title: AppStrings.titleTraining, 
      navigatePage: TrainingView(),
    ),
    const MenuButton(
      fadeInDuration: Duration(milliseconds: 1500), 
      color: AppColors.wexColor,
      imagePath: ImagePaths.wex, 
      title: AppStrings.titleWithTimer, 
      navigatePage: WithTimerView(),
    ),
    const MenuButton(
      fadeInDuration: Duration(milliseconds: 2000), 
      color: AppColors.exortColor,
      imagePath: ImagePaths.exort, 
      title: AppStrings.titleChallanger, 
      navigatePage: ChallangerView(),
    ),
    MenuButton.exit(
      fadeInDuration: const Duration(milliseconds: 2500), 
      color: AppColors.exitBtnColor,
      imagePath: Elements.invoke.getImage, 
      title: AppStrings.quitGame,
    ),
  ];
  
}
