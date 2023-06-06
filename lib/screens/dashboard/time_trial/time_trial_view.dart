import '../../../widgets/show_leaderboard_button.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_strings.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/dialog_contents/leaderboard_dialog.dart';
import '../../../widgets/game_ui_widget.dart';

class TimeTrialView extends StatefulWidget {
  const TimeTrialView({super.key});

  @override
  State<TimeTrialView> createState() => _TimeTrialViewState();
}

class _TimeTrialViewState extends State<TimeTrialView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppScaffold(
        resizeToAvoidBottomInset: false,
        body: _bodyView(),
      ),
    );
  }

  Widget _bodyView() {
    return const SingleChildScrollView(
      child: Column(
        children: [
          GameUIWidget(gameType: GameType.Timer),
          ShowLeaderBoardButton(
            title: AppStrings.leaderboard, 
            contentDialog: LeaderboardDialog(leaderboardType: LeaderboardType.TimeTrial),
          ),
        ],
      ),
    );
  }

}
