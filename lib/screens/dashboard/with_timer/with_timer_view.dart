import '../../../extensions/widget_extension.dart';
import '../../../widgets/app_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../extensions/context_extension.dart';
import '../../../providers/game_provider.dart';
import '../../../widgets/app_dialogs.dart';
import '../../../widgets/game_ui_widget.dart';
import '../../../widgets/leaderboard_with_timer.dart';

class WithTimerView extends StatefulWidget {
  const WithTimerView({super.key});

  @override
  State<WithTimerView> createState() => _WithTimerViewState();
}

class _WithTimerViewState extends State<WithTimerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const GameUIWidget(gameType: GameType.Timer),
            showLeaderBoardButton(),
          ],
        ),
      ),
    );
  }

  Widget showLeaderBoardButton() {
    final isStart = context.watch<GameProvider>().isStart;
    if (isStart) return EmptyBox();
    return AppOutlinedButton(
      title: AppStrings.leaderboard, 
      width: context.dynamicWidth(0.4),
      padding: EdgeInsets.only(top: context.dynamicHeight(0.02)),
      onPressed: () => AppDialogs.showScaleDialog(
        title: AppStrings.leaderboard,
        content: const Card(
          color: AppColors.resultsCardBg, 
          child: LeaderboardWithTimer(),
        ),
        action: AppOutlinedButton(
          title: AppStrings.back,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

}
