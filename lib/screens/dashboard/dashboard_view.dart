import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../enums/elements.dart';
import '../../widgets/beta_banner.dart';
import '../../widgets/menu_button.dart';
import '../../widgets/settings_button.dart';
import 'challanger/challanger_view.dart';
import 'training/training_view.dart';
import 'with_timer/with_timer_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BetaBanner().wrapAlign(Alignment.topLeft),
                  SettingsButton().wrapAlign(Alignment.topRight),
                ],
              ),
            ),
            ...menuBtns(),
            Spacer(),
          ],
        ),
      ),
    );
  }

  List<Widget> menuBtns() {
    return [
      MenuButton(
        fadeInDuration: Duration(milliseconds: 1000), 
        color: AppColors.quasColor, 
        imagePath: ImagePaths.quas, 
        title: AppStrings.titleTraining, 
        navigatePage: TrainingView(),
      ),
      MenuButton(
        fadeInDuration: Duration(milliseconds: 1500), 
        color: AppColors.wexColor,
        imagePath: ImagePaths.wex, 
        title: AppStrings.titleWithTimer, 
        navigatePage: WithTimerView(),
      ),
      MenuButton(
        fadeInDuration: Duration(milliseconds: 2000), 
        color: AppColors.exortColor,
        imagePath: ImagePaths.exort, 
        title: AppStrings.titleChallanger, 
        navigatePage: ChallangerView(),
      ),
      MenuButton.exit(
        fadeInDuration: Duration(milliseconds: 2500), 
        color: Colors.white70,
        imagePath: Elements.invoke.getImage, 
        title: AppStrings.quitGame,
      ),
    ];
  }
  
}