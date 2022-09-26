import 'package:flutter/material.dart';
import '../../widgets/menu_button.dart';
import '../challangerScreen.dart';
import '../trainingScreen.dart';
import '../withTimerScreen.dart';

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
              color: Colors.blue, 
              imagePath: "images/quasGif.gif", 
              title: "Training", 
              navigatePage: TrainingScreen(),
            ),
            MenuButton(
              fadeInDuration: Duration(seconds: 2), 
              color: Colors.pink.shade200,
              imagePath: "images/wexGif.gif", 
              title: "With Timer", 
              navigatePage: WithTimerScreen(),
            ),
            MenuButton(
              fadeInDuration: Duration(seconds: 3), 
              color: Colors.amber,
              imagePath: "images/exortGif.gif", 
              title: "Challanger", 
              navigatePage: ChallangerScreen(),
            ),
          ],
        ),
      )
    );
  }
  
}