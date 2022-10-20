import '../../../extensions/context_extension.dart';
import 'challanger_view_model.dart';
import '../../../widgets/leaderboard_challanger.dart';
import '../../../widgets/result_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../enums/elements.dart';
import '../../../providers/spell_provider.dart';
import '../../../providers/timer_provider.dart';
import '../../../services/database_service.dart';
import '../../../services/sound_service.dart';
import '../../../widgets/big_spell_picture.dart';
import '../../../widgets/custom_animated_dialog.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/trueFalseWidget.dart';

class ChallangerView extends StatefulWidget {
  const ChallangerView({Key? key}) : super(key: key);

  @override
  State<ChallangerView> createState() => _ChallangerViewState();
}

class _ChallangerViewState extends ChallangerViewModel {
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
          trueFalseIcons(),
          BigSpellPicture(
            image: context.read<TimerProvider>().isStart 
              ? context.watch<SpellProvider>().getNextSpellImage 
              : ImagePaths.spellImage
          ),
          selectedElementOrbs(),
          skills(),
          startButton(),
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

  Widget trueFalseIcons() {
    return Padding(
      padding: EdgeInsets.only(top: context.dynamicHeight(0.02)),
      child: TrueFalseWidget(
        key: globalAnimKey,
      ),
    );
  }

  SizedBox selectedElementOrbs() {
    return SizedBox(
      width: context.dynamicWidth(0.25),
      height: context.dynamicHeight(0.10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: selectedOrbs,
      ),
    );
  }

  Padding skills() {
    return Padding(
      padding: EdgeInsets.only(top: context.dynamicHeight(0.03)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          skill(Elements.quas),
          skill(Elements.wex),
          skill(Elements.exort),
          skill(Elements.invoke),
        ],
      ),
    );
  }

  InkWell skill(Elements element) {
    return InkWell(
      child: DecoratedBox(
        decoration: skillBlackShadowDec,
        child: Image.asset(element.getImage,width: context.dynamicWidth(0.20))
      ),
      onTap: () => skillOnTapFN(element),
    );
  }

  void skillOnTapFN(Elements element){
    var spellProvider = context.read<SpellProvider>();
    var timerProvider = context.read<TimerProvider>();
    switch (element) {
      case Elements.quas:
      case Elements.wex:
      case Elements.exort:
        return switchOrb(element);
      case Elements.invoke:
        if(!timerProvider.isStart) return;
        if (currentCombination.toString() == spellProvider.getNextCombination.toString()) {
          timerProvider.increaseCorrectCounter();
          SoundService.instance.trueCombinationSound(spellProvider.getNextCombination);
          globalAnimKey.currentState?.trueAnimationForward();
          spellProvider.getRandomSpell();
        }else{
          SoundService.instance.ggSound();
          timerProvider.changeIsStartStatus();
          timerProvider.disposeTimer();
          CustomAnimatedDialog.showCustomDialog(
            title: AppStrings.result, 
            content: ResultDialog(
              correctCount: context.read<TimerProvider>().getCorrectCombinationCount, 
              textEditingController: textEditingController
            ),
            action: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: Text(AppStrings.send),
                onPressed: () async {
                  String name = textEditingController.text.trim();
                  if (name.length == 0) {
                    name=AppStrings.unNamed;
                  }
                  await DatabaseService.instance.addScore(
                    table: DatabaseTable.challenger, 
                    name: name, 
                    time: context.read<TimerProvider>().getTimeValue,
                    score: context.read<TimerProvider>().getCorrectCombinationCount, 
                  );
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(AppStrings.back),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          );
          globalAnimKey.currentState?.falseAnimationForward();
        }
    }
  }

  Widget startButton() {
    bool isStart = context.read<TimerProvider>().isStart;
    return !isStart 
      ? CustomButton(
          text: AppStrings.start, 
          padding: EdgeInsets.only(top: context.dynamicHeight(0.04)),
          onTap: () {
            context.read<TimerProvider>().resetTimer();
            context.read<TimerProvider>().startTimer();
            context.read<SpellProvider>().getRandomSpell();
          },
        )
      : SizedBox.shrink();
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
              child: LeaderboardChallanger()
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