import 'package:dota2_invoker/constants/app_colors.dart';
import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:dota2_invoker/screens/dashboard/with_timer/with_timer_view.dart';
import 'package:flutter/material.dart';
import '../../widgets/menu_button.dart';
import '../challangerScreen.dart';
import '../withTimerScreen.dart';
import 'training/training_view.dart';

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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuButton(
              fadeInDuration: Duration(seconds: 1), 
              color: AppColors.quasColor, 
              imagePath: ImagePaths.quas, 
              title: AppStrings.titleTraining, 
              navigatePage: TrainingView(),
            ),
            MenuButton(
              fadeInDuration: Duration(seconds: 2), 
              color: AppColors.wexColor,
              imagePath: ImagePaths.wex, 
              title: AppStrings.titleWithTimer, 
              navigatePage: WithTimerView(),
            ),
            // MenuButton(
            //   fadeInDuration: Duration(seconds: 3), 
            //   color: AppColors.exortColor,
            //   imagePath: ImagePaths.exort, 
            //   title: AppStrings.titleChallanger, 
            //   navigatePage: ChallangerScreen(),
            // ),
          ],
        ),
      )
    );
  }
  
}