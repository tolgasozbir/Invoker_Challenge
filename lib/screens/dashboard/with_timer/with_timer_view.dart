import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_strings.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../providers/game_provider.dart';
import '../../../widgets/app_dialogs.dart';
import '../../../widgets/app_outlined_button.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/dialog_contents/leaderboards/leaderboard_with_timer.dart';
import '../../../widgets/game_ui_widget.dart';

class WithTimerView extends StatefulWidget {
  const WithTimerView({super.key});

  @override
  State<WithTimerView> createState() => _WithTimerViewState();
}

class _WithTimerViewState extends State<WithTimerView> {
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
          showLeaderBoardButton(),
        ],
      ),
    );
  }

  Widget showLeaderBoardButton() {
    final isStart = context.watch<GameProvider>().isStart;
    if (isStart) return const EmptyBox();
    return AppOutlinedButton(
      title: AppStrings.leaderboard, 
      width: context.dynamicWidth(0.4),
      padding: EdgeInsets.only(top: context.dynamicHeight(0.02)),
      onPressed: () => AppDialogs.showScaleDialog(
        title: AppStrings.leaderboard,
        content: const LeaderboardWithTimer(),
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
