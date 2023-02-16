import '../../../extensions/widget_extension.dart';
import '../../../widgets/app_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../extensions/context_extension.dart';
import '../../../providers/game_provider.dart';
import '../../../widgets/custom_animated_dialog.dart';
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
            GameUIWidget(
              gameType: GameType.Timer,
              timerWidget: timerCounterWidget(),
            ),
            showLeaderBoardButton(),
          ],
        ),
      ),
    );
  }

  Widget timerCounterWidget() {
    final countdownValue = context.watch<GameProvider>().getCountdownValue;
    return Card(
      color: context.theme.scaffoldBackgroundColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.square(
            dimension: context.dynamicWidth(0.14),
            child: CircularProgressIndicator(
              color: AppColors.amber,
              backgroundColor: AppColors.blue,
              valueColor: countdownValue <=10 
                ? const AlwaysStoppedAnimation<Color>(AppColors.red) 
                : const AlwaysStoppedAnimation<Color>(AppColors.amber),
              value: countdownValue / 60,
              strokeWidth: 4,
            ),
          ),
          Text(countdownValue.toString(), style: TextStyle(fontSize: context.sp(24)),),
        ],
      ),
    );
  }

  Widget showLeaderBoardButton() {
    final isStart = context.read<GameProvider>().isStart;
    if (isStart) return EmptyBox();
    return AppOutlinedButton(
      title: AppStrings.leaderboard, 
      width: context.dynamicWidth(0.4),
      padding: EdgeInsets.only(top: context.dynamicHeight(0.02)),
      onPressed: () => CustomAnimatedDialog.showCustomDialog(
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
