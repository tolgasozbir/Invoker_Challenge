import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:dota2_invoker/widgets/user_info.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../enums/elements.dart';
import '../../widgets/app_snackbar.dart';
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
      body: _bodyView(context),
    );
  }

  Widget _bodyView(BuildContext context) {
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          children: [
            Row(
              children: [
                UserStatus().wrapAlign(Alignment.topLeft).wrapExpanded(flex: 1),
                SettingsButton().wrapAlign(Alignment.topRight).wrapExpanded(flex: 1),
              ],
            ).wrapExpanded(flex: 1),
            ...menuBtns(),
            // ElevatedButton(
            //   onPressed: () {
            //     ScaffoldMessenger.of(context).removeCurrentSnackBar();
            //     AppSnackBar.showSnackBarMessage(text: "text", snackBartype: SnackBarType.info);
            //   }, 
            //   child: Text("Show")
            // ),
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