import 'package:flutter/material.dart';

import '../../../constants/locale_keys.g.dart';
import '../../../extensions/string_extension.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/dialog_contents/leaderboard_dialog.dart';
import '../../../widgets/game_ui_widget.dart';
import '../../../widgets/show_leaderboard_button.dart';

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
    return SingleChildScrollView(
      child: Column(
        children: [
          const GameUIWidget(gameType: GameType.Timer),
          ShowLeaderBoardButton(
            title: LocaleKeys.commonGeneral_leaderboard.locale, 
            contentDialog: const LeaderboardDialog(leaderboardType: LeaderboardType.TimeTrial),
          ),
        ],
      ),
    );
  }

}
