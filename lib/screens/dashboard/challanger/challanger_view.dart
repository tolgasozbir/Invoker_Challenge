import 'package:dota2_invoker/widgets/game_ui_widget.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/leaderboard_challanger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../providers/timer_provider.dart';
import '../../../widgets/custom_animated_dialog.dart';
import '../../../widgets/custom_button.dart';

class ChallangerView extends StatefulWidget {
  const ChallangerView({Key? key}) : super(key: key);

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          trueCounter(),
          timerCounter(),
          GameUIWidget(gameType: GameType.Challanger),
          showLeaderBoardButton(),
        ],
      ),
    );
  }

  Widget trueCounter(){
    return Container(
      width: double.infinity,
      height: context.dynamicHeight(0.12),
      child: Center(
        child: Text(
          context.watch<TimerProvider>().getCorrectCombinationCount.toString(),
          style: TextStyle(fontSize: context.sp(36), color: Colors.green,),
        ),
      ),
    );
  }

  Widget timerCounter() {
    var timerValue = context.watch<TimerProvider>().getTimeValue;
    return Card(
      color: Color(0xFF303030),
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: AlwaysStoppedAnimation((timerValue*10) / 360 ),
            child: SizedBox.square(
              dimension: context.dynamicWidth(0.14),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0x3300BBFF),Color(0x33FFCC00)],),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ), 
          Text(timerValue.toString(), style: TextStyle(fontSize: context.sp(24)),),
        ],
      ),
    );
  }

  Widget showLeaderBoardButton() {
    bool isStart = context.read<TimerProvider>().isStart;
    return !isStart 
      ? CustomButton(
          text: AppStrings.leaderboard, 
          padding: EdgeInsets.only(top: context.dynamicHeight(0.02)),
          onTap: () => CustomAnimatedDialog.showCustomDialog(
            title: AppStrings.leaderboard,
            content: Card(
              color: AppColors.resultCardBg, 
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //TODO:
                        Expanded(flex: 6, child: Text("Name")),
                        Text("Time"),
                        Spacer(),
                        Text("Score"),
                      ],
                    ),
                  ),
                  LeaderboardChallanger(),
                ],
              )
            ),
            action: TextButton(
              child: Text(AppStrings.back),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
        )
      : SizedBox.shrink();
  }

}