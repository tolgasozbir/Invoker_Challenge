import 'package:dota2_invoker/models/challenger_result.dart';
import 'package:dota2_invoker/services/database/firestore_service.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../enums/elements.dart';
import '../../widgets/menu_button.dart';
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            // ElevatedButton(
            //   onPressed: () async {
            //     var dummy = ChallengerResult(name: "test", time: 27, score: 22);
            //     await FirestoreService.instance.addChallengerScore(dummy);
            //     var data = await FirestoreService.instance.getAllChallangerScores();
            //     data.forEach((element) {
            //       print(element.name);
            //       print(element.score);
            //       print("**************");
            //     });
            //   }, 
            //   child: Text("Fetch")

            //TODO: database_service.dart düzenlencek veya silincek duruma göre
            // leaderboard a entegre edilcek servicesler
            // )
          ],
        ),
      ),
    );
  }
  
}