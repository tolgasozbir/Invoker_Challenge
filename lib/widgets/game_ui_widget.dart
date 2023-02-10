import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../enums/database_table.dart';
import '../enums/elements.dart';
import '../extensions/context_extension.dart';
import '../mixins/orb_mixin.dart';
import '../models/challenger_result.dart';
import '../models/timer_result.dart';
import '../providers/game_provider.dart';
import '../providers/spell_provider.dart';
import '../services/sound_service.dart';
import 'custom_animated_dialog.dart';
import 'custom_button.dart';
import 'result_dialog_content.dart';
import 'true_false_icon_widget.dart';

enum GameType { Training, Challanger, Timer }

class GameUIWidget extends StatefulWidget {
  const GameUIWidget({super.key, required this.gameType, required this.timerWidget});

  final GameType gameType;
  final Widget? timerWidget;

  @override
  State<GameUIWidget> createState() => _GameUIWidgetState();
}

class _GameUIWidgetState extends State<GameUIWidget> with OrbMixin {

  final _animKey = GlobalKey<TrueFalseWidgetState>();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) => _bodyView(context);

  Column _bodyView(BuildContext context) {
    return Column(
      children: [
        //SizedBox(height: context.dynamicHeight(0.02)),
        if (widget.gameType != GameType.Training)
          trueCounter(),
        if (widget.timerWidget != null)
          widget.timerWidget!,
        TrueFalseIconWidget(key: _animKey),
        bigSpellPicture(),
        selectedElementOrbs(),
        skills(),
        startButton()
      ],
    );
  }

  Widget trueCounter(){
    return SizedBox(
      width: double.infinity,
      height: context.dynamicHeight(0.12),
      child: Center(
        child: Text(
          context.watch<GameProvider>().getCorrectCombinationCount.toString(),
          style: TextStyle(fontSize: context.sp(36), color: AppColors.correctCounterColor,),
        ),
      ),
    );
  }

  Widget bigSpellPicture(){
    return Container(
      width: context.dynamicWidth(0.28),
      height: context.dynamicWidth(0.28),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white30, 
            blurRadius: 12, 
            spreadRadius: 4,
          ),
        ],
      ),
      child: Image.asset(
        context.watch<GameProvider>().isStart 
          ? context.watch<SpellProvider>().getNextSpellImage 
          : ImagePaths.spellImage,
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
        child: Image.asset(element.getImage,width: context.dynamicWidth(0.20)),
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
    final spellProvider = context.read<SpellProvider>();
    final timerProvider = context.read<GameProvider>();
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
    final spellProvider = context.read<SpellProvider>();
    final timerProvider = context.read<GameProvider>();
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
    final spellProvider = context.read<SpellProvider>();
    final timerProvider = context.read<GameProvider>();
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
          _animKey.currentState?.playAnimation(IconType.False);
          showResultDialog(DatabaseTable.challenger);
        }
    }
  }

  void showResultDialog(DatabaseTable dbTable) {
    CustomAnimatedDialog.showCustomDialog(
      title: AppStrings.result, 
      content: ResultDialogContent(
        correctCount: context.read<GameProvider>().getCorrectCombinationCount, 
        textEditingController: _textEditingController,
      ),
      action: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            child: const Text(AppStrings.send),
            onPressed: () async {
              var name = _textEditingController.text.trim();
              final score = context.read<GameProvider>().getCorrectCombinationCount;
              final time = context.read<GameProvider>().getTimeValue;
              final db = context.services.databaseService;
              if (name.isEmpty) {
                name = AppStrings.unNamed + Random().nextInt(999999).toString();
              }
              switch (dbTable) {
                case DatabaseTable.timer:
                  await db.addTimerScore(TimerResult(name: name, score: score));
                  break;
                case DatabaseTable.challenger:
                  await db.addChallengerScore(ChallengerResult(name: name, time: time, score: score));
                  break;
              }
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text(AppStrings.back),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget startButton() {
    final isStart = context.read<GameProvider>().isStart;
    return !isStart 
      ? CustomButton(
          text: AppStrings.start, 
          padding: EdgeInsets.only(top: context.dynamicHeight(0.04)),
          onTap: () {
            context.read<GameProvider>().resetTimer();
            widget.gameType == GameType.Timer 
              ? context.read<GameProvider>().startCoundown(showResultDialog)
              : context.read<GameProvider>().startTimer();
            context.read<SpellProvider>().getRandomSpell();
          },
        )
      : const SizedBox.shrink();
  }

}
