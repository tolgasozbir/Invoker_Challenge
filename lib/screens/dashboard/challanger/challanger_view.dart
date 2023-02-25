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
import '../../../widgets/leaderboard_challanger.dart';

class ChallangerView extends StatefulWidget {
  const ChallangerView({super.key});

  @override
  State<ChallangerView> createState() => _ChallangerViewState();
}

class _ChallangerViewState extends State<ChallangerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return SafeArea(
      child: Column(
        children: [
          const GameUIWidget(gameType: GameType.Challanger),
          showLeaderBoardButton(),
        ],
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
        content: Card(
          color: AppColors.resultsCardBg, 
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(flex: 5, child: Text(AppStrings.username)),
                    Expanded(flex: 2, child: Center(child: Text(AppStrings.time))),
                    Expanded(flex: 2, child: Center(child: Text('${AppStrings.score}    '))),
                  ],
                ),
              ),
              const LeaderboardChallanger(),
            ],
          ),
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
