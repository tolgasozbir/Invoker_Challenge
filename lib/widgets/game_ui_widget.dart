import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../enums/database_table.dart';
import '../enums/elements.dart';
import '../enums/local_storage_keys.dart';
import '../extensions/context_extension.dart';
import '../extensions/widget_extension.dart';
import '../mixins/loading_state_mixin.dart';
import '../mixins/orb_mixin.dart';
import '../providers/game_provider.dart';
import '../providers/spell_provider.dart';
import '../providers/user_manager.dart';
import '../screens/profile/achievements/achievement_manager.dart';
import '../services/app_services.dart';
import '../services/sound_manager.dart';
import 'app_outlined_button.dart';
import 'bouncing_button.dart';
import 'timer_hud.dart';
import 'true_false_icon_widget.dart';

enum GameType { Training, Challanger, Timer }

class GameUIWidget extends StatefulWidget {
  const GameUIWidget({super.key, required this.gameType});

  final GameType gameType;

  @override
  State<GameUIWidget> createState() => _GameUIWidgetState();
}

class _GameUIWidgetState extends State<GameUIWidget> with OrbMixin, LoadingState {

  final _animKey = GlobalKey<TrueFalseWidgetState>();
  var challangerLife = UserManager.instance.user.challangerLife;

  @override
  Widget build(BuildContext context) => _bodyView();

  Column _bodyView() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            TimerHud(gameType: widget.gameType).wrapExpanded(),
            trueCounter().wrapExpanded(),
          ],
        ),
        if (widget.gameType == GameType.Training)
          SizedBox(height: context.dynamicHeight(0.16) + (context.watch<GameProvider>().spellHelperIsOpen ? -context.dynamicHeight(0.12) : 0))
        else
          SizedBox(height: context.dynamicHeight(0.20)),
        TrueFalseIconWidget(key: _animKey),
        bigSpellPicture(),
        selectedElementOrbs(),
        skills(),
        startButton()
      ],
    );
  }

  Widget trueCounter(){
    var score = context.watch<GameProvider>().getCorrectCombinationCount.toString();
    return Text(
      AppStrings.score + ": " + score,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: context.sp(18), 
        color: AppColors.green
      ),
    ).wrapPadding(EdgeInsets.only(top: 4, right: 8));
  }

  Widget bigSpellPicture(){
    return Container(
      width: context.dynamicWidth(0.28),
      height: context.dynamicWidth(0.28),
      decoration: BoxDecoration(
        color: AppColors.svgGrey,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          width: 1.6,
          color: AppColors.white30,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.white30, 
            blurRadius: 12, 
            spreadRadius: 4,
          ),
        ],
      ),
      child: Image.asset(
        context.watch<GameProvider>().isStart 
          ? context.watch<SpellProvider>().getNextSpellImage 
          : ImagePaths.spellImage,
        fit: BoxFit.cover,
      ).wrapClipRRect(BorderRadius.circular(4)),
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

  //QWER Ability Hud
  AnimatedPadding skills() {
    return AnimatedPadding(
      duration: Duration(milliseconds: 400),
      padding: EdgeInsets.only(top: qwerHudHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(Elements.values.length, (index) => skill(Elements.values[index])),
      ),
    );
  }

  BouncingButton skill(Elements element) {
    return BouncingButton(
      child: Stack(
        children: [
          DecoratedBox(
            decoration: qwerAbilityDecoration(element.getColor),
            child: Image.asset(element.getImage,width: context.dynamicWidth(0.18)),
          ),
          Text(
            element.getKey.toUpperCase(), 
            style: TextStyle(
              color: element.getColor, 
              fontSize: context.sp(16),
              fontWeight: FontWeight.w500,
              shadows: List.generate(3, (index) => Shadow(blurRadius: 8)),
            ),
          ).wrapPadding(EdgeInsets.only(left: 2)),
        ],
      ),
      onPressed: () {
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
        if (currentCombination == spellProvider.getNextCombination) {
          timerProvider.increaseCorrectCounter();
          SoundManager.instance.trueCombinationSound(spellProvider.getNextCombination);
          _animKey.currentState?.playAnimation(IconType.True);
        }else{
          SoundManager.instance.failCombinationSound();
          _animKey.currentState?.playAnimation(IconType.False);
        }
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
        if (currentCombination == spellProvider.getNextCombination) {
          timerProvider.increaseCorrectCounter();
          SoundManager.instance.trueCombinationSound(spellProvider.getNextCombination);
          _animKey.currentState?.playAnimation(IconType.True);

          final score = context.read<GameProvider>().getCorrectCombinationCount;
          AchievementManager.instance.updateTimer(score);
        }else{
          SoundManager.instance.failCombinationSound();
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
        if (currentCombination == spellProvider.getNextCombination) {
          timerProvider.increaseCorrectCounter();
          SoundManager.instance.trueCombinationSound(spellProvider.getNextCombination);
          _animKey.currentState?.playAnimation(IconType.True);
          spellProvider.getRandomSpell();

          final time = context.read<GameProvider>().getTimeValue;
          final score = context.read<GameProvider>().getCorrectCombinationCount;
          AchievementManager.instance.updateChallenger(score, time);
        } else {
          if (challangerLife > 0) {
            SoundManager.instance.failCombinationSound();
            _animKey.currentState?.playAnimation(IconType.False);
            spellProvider.getRandomSpell();
            challangerLife--;
            UserManager.instance.snappableKey.currentState?.snap();
            return;
          }
          SoundManager.instance.ggSound();
          timerProvider.changeIsStartStatus();
          timerProvider.disposeTimer();
          _animKey.currentState?.playAnimation(IconType.False);
          context.read<GameProvider>().showResultDialog(GameType.Challanger, DatabaseTable.challenger);
        }
    }
  }

  Widget startButton() {
    final isStart = context.read<GameProvider>().isStart;
    if (isStart) return EmptyBox();
    return AppOutlinedButton(
      title: AppStrings.start, 
      width: context.dynamicWidth(0.4),
      padding: EdgeInsets.only(top: context.dynamicHeight(0.04)),
      onPressed: startBtnFn,
    );
  }

  void startBtnFn() {
    context.read<GameProvider>().resetTimer();
    switch (widget.gameType) {
      case GameType.Training:
      case GameType.Challanger: 
        UserManager.instance.snappableKey.currentState?.reset();
        challangerLife = UserManager.instance.user.challangerLife;
        context.read<GameProvider>().startTimer(); 
        break;
      case GameType.Timer:
        context.read<GameProvider>().startCoundown();
        break;
    }
    context.read<SpellProvider>().getRandomSpell();
  }
  
  double get qwerHudHeight {
    var isStart = context.read<GameProvider>().isStart;
    final totalButtonHeight = 96;
    double max = context.dynamicHeight(0.12);
    double sliderVal = AppServices.instance.localStorageService.
      getIntValue(LocalStorageKey.qwerHudHeight)?.toDouble() ?? 20;

    var calculatedVal =  (sliderVal / 100 * max) + (isStart ? (sliderVal / 100 * totalButtonHeight) : 0);

    return calculatedVal;
  }

}
