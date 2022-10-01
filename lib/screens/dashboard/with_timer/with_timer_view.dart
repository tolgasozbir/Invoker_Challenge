import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/widgets/custom_animated_dialog.dart';
import 'package:dota2_invoker/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/dbResultWidget.dart';
import '../../../constants/app_strings.dart';
import '../../../enums/elements.dart';
import '../../../providers/spell_provider.dart';
import '../../../providers/timer_provider.dart';
import '../../../services/sound_service.dart';
import '../../../widgets/big_spell_picture.dart';
import '../../../widgets/trueFalseWidget.dart';
import 'with_timer_view_model.dart';

class WithTimerView extends StatefulWidget {
  const WithTimerView({Key? key}) : super(key: key);

  @override
  State<WithTimerView> createState() => _WithTimerViewState();
}

class _WithTimerViewState extends WithTimerViewModel {
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
    var countdownValue = context.watch<TimerProvider>().getCountdownValue;
    return Card(
      color: Color(0xFF303030),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.square(
            dimension: context.dynamicWidth(0.14),
            child: CircularProgressIndicator(
              color: Colors.amber,
              backgroundColor: Colors.blue,
              valueColor: countdownValue <=10 
                ? AlwaysStoppedAnimation<Color>(Colors.red) 
                : AlwaysStoppedAnimation<Color>(Colors.amber),
              value: countdownValue / 60,
              strokeWidth: 4,
            ),
          ),
          Text(countdownValue.toString(), style: TextStyle(fontSize: context.sp(24)),),
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
          timerProvider.increaseTotalCast();
          SoundService.instance.trueCombinationSound(spellProvider.getNextCombination);
          globalAnimKey.currentState?.trueAnimationForward();
        }else{
          SoundService.instance.failCombinationSound();
          globalAnimKey.currentState?.falseAnimationForward();
        }
        timerProvider.increaseTotalTabs();
        spellProvider.getRandomSpell();
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
            context.read<TimerProvider>().startCoundown();
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
              color:Color(0xFF666666) , 
              child: DbResultWidget() //TODO EDİT
            ),
            action: TextButton(
              child: Text("Back"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
        )
      : SizedBox.shrink();
  }


}