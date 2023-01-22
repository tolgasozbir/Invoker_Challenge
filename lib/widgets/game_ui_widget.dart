import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/mixins/orb_mixin.dart';
import 'package:dota2_invoker/widgets/result_dialog.dart';
import 'package:dota2_invoker/widgets/true_false_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_strings.dart';
import '../enums/elements.dart';
import '../providers/spell_provider.dart';
import '../providers/timer_provider.dart';
import '../services/database_service.dart';
import '../services/sound_service.dart';
import 'big_spell_picture.dart';
import 'custom_animated_dialog.dart';
import 'custom_button.dart';

enum GameType { Training, Challanger, Timer }

class GameUIWidget extends StatefulWidget {
  GameUIWidget({Key? key, required this.gameType}) : super(key: key);

  final GameType gameType;

  @override
  State<GameUIWidget> createState() => _GameUIWidgetState();
}

class _GameUIWidgetState extends State<GameUIWidget> with OrbMixin {

  final _animKey = GlobalKey<TrueFalseWidgetState>();
  bool showAllSpells = false;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) => _bodyView(context);

  Column _bodyView(BuildContext context) {
    return Column(
      children: [
        trueFalseIcons(),
        BigSpellPicture(
          image: context.watch<TimerProvider>().isStart 
            ? context.watch<SpellProvider>().getNextSpellImage 
            : ImagePaths.spellImage
        ),
        selectedElementOrbs(),
        skills(),
        startButton()
      ],
    );
  }

  Widget trueFalseIcons() {
    return Padding(
      padding: EdgeInsets.only(top: context.dynamicHeight(0.02)),
      child: TrueFalseIconWidget(key: _animKey),
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
      onTap: () {
        switch (widget.gameType) {
          case GameType.Training:
            skillOnTapFNTraining(element);
            return;
          case GameType.Challanger:
            skillOnTapFNChallanger(element);
            return;
          case GameType.Timer:
            skillOnTapFNTimer(element);
            return;
        }
      },
    );
  }

  void skillOnTapFNTraining(Elements element){
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
          _animKey.currentState?.playAnimation(IconType.True);
        }else{
          SoundService.instance.failCombinationSound();
          _animKey.currentState?.playAnimation(IconType.False);
        }
        timerProvider.increaseTotalTabs();
        spellProvider.getRandomSpell();
    }
  }

    void skillOnTapFNTimer(Elements element){
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
          _animKey.currentState?.playAnimation(IconType.True);
        }else{
          SoundService.instance.failCombinationSound();
          _animKey.currentState?.playAnimation(IconType.False);
        }
        spellProvider.getRandomSpell();
    }
  }

    void skillOnTapFNChallanger(Elements element){
    var spellProvider = context.read<SpellProvider>();
    var timerProvider = context.read<TimerProvider>();
    switch (element) {
      case Elements.quas:
      case Elements.wex:
      case Elements.exort:
        return switchOrb(element);
      case Elements.invoke:
        if (!timerProvider.isStart) return;
        if (currentCombination.toString() == spellProvider.getNextCombination.toString()) {
          timerProvider.increaseCorrectCounter();
          SoundService.instance.trueCombinationSound(spellProvider.getNextCombination);
          _animKey.currentState?.playAnimation(IconType.True);
          spellProvider.getRandomSpell();
        } else {
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
          _animKey.currentState?.playAnimation(IconType.False);
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
            widget.gameType == GameType.Timer 
              ? context.read<TimerProvider>().startCoundown()
              : context.read<TimerProvider>().startTimer();
            context.read<SpellProvider>().getRandomSpell();
          },
        )
      : SizedBox.shrink();
  }

}