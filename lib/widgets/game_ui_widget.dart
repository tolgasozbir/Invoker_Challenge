import 'package:dota2_invoker_game/extensions/string_extension.dart';

import '../constants/locale_keys.g.dart';
import '../enums/spells.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_image_paths.dart';
import '../enums/database_table.dart';
import '../enums/elements.dart';
import '../enums/local_storage_keys.dart';
import '../extensions/context_extension.dart';
import '../extensions/widget_extension.dart';
import '../mixins/screen_state_mixin.dart';
import '../mixins/orb_mixin.dart';
import '../providers/game_provider.dart';
import '../providers/spell_provider.dart';
import '../services/user_manager.dart';
import '../services/achievement_manager.dart';
import '../services/app_services.dart';
import '../services/sound_manager.dart';
import '../utils/spell_combination_checker.dart';
import 'app_outlined_button.dart';
import 'bouncing_button.dart';
import 'empty_box.dart';
import 'timer_hud.dart';
import 'true_false_icon_widget.dart';

enum GameType { Training, Challanger, Timer, Combo }

class GameUIWidget extends StatefulWidget {
  const GameUIWidget({super.key, required this.gameType});

  final GameType gameType;

  @override
  State<GameUIWidget> createState() => _GameUIWidgetState();
}

class _GameUIWidgetState extends State<GameUIWidget> with OrbMixin, ScreenStateMixin {
  late GameProvider _gameProvider;
  final _animKey = GlobalKey<TrueFalseWidgetState>();
  int challangerLife = UserManager.instance.user.challangerLife;

  final _boxDecoration = BoxDecoration(
    color: AppColors.svgGrey,
    borderRadius: const BorderRadius.all(Radius.circular(4)),
    border: Border.all(
      width: 1.6,
      color: AppColors.white30,
    ),
    boxShadow: const [
      BoxShadow(
        color: AppColors.white30, 
        blurRadius: 12, 
        spreadRadius: 4,
      ),
    ],
  );

  @override
  void initState() {
    _gameProvider = context.read<GameProvider>();
    Future.microtask(() => initSpecificValues());
    super.initState();
  }

  void initSpecificValues() {
    if (widget.gameType == GameType.Combo) {
      context.read<GameProvider>().updateCountdownTimeBasedOnScore();
    }
  }

  @override
  void dispose() {
    _gameProvider.disposeTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _bodyView();

  Column _bodyView() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            TimerHud(gameType: widget.gameType).wrapExpanded(),
            trueCounter().wrapExpanded(),
          ],
        ),
        if (widget.gameType == GameType.Training)
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: context.dynamicHeight(0.16) + (context.watch<GameProvider>().spellHelperIsOpen ? -context.dynamicHeight(0.12) : 0),
          )
        else
          SizedBox(height: context.dynamicHeight(0.20)),
        if (widget.gameType != GameType.Combo) TrueFalseIconWidget(key: _animKey),
        if (widget.gameType != GameType.Combo) 
          bigSpellPicture() 
        else comboRequiredSpells(),
        selectedElementOrbs(),
        skills(),
        startButton(),
      ],
    );
  }

  Widget trueCounter(){
    final score = context.watch<GameProvider>().getCorrectCombinationCount.toString();
    return Text(
      '${LocaleKeys.commonGeneral_score.locale}: $score',
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: context.sp(18), 
        color: AppColors.green,
      ),
    ).wrapPadding(const EdgeInsets.only(top: 4, right: 8));
  }

  Widget comboRequiredSpells() {
    return Container(
      height: context.dynamicWidth(0.28),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: _boxDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(context.read<SpellProvider>().comboSpellNum, (index) {
          return AnimatedCrossFade(
            alignment: Alignment.topCenter,
            duration: const Duration(milliseconds: 400),
            crossFadeState: context.watch<SpellProvider>().correctSpells.isEmpty || context.watch<SpellProvider>().correctSpells[index] == false ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            secondChild: Opacity(
              opacity: 0.1,
              child: comboSpellImage(index),
            ),
            firstChild: comboSpellImage(index),
          );
        },),
      ),
    );
  }

  Widget comboSpellImage(int index) {
    return Image.asset(
      context.watch<GameProvider>().isStart && context.watch<SpellProvider>().comboSpells.isNotEmpty
        ? context.watch<SpellProvider>().comboSpells[index].image
        : ImagePaths.spellImage,
      fit: BoxFit.cover,
    ).wrapClipRRect(BorderRadius.circular(4)).wrapPadding(const EdgeInsets.all(8.0));
  }

  Widget bigSpellPicture(){
    return Container(
      width: context.dynamicWidth(0.28),
      height: context.dynamicWidth(0.28),
      decoration: _boxDecoration,
      child: Image.asset(
        context.watch<GameProvider>().isStart 
          ? context.watch<SpellProvider>().nextSpell.image 
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
      duration: const Duration(milliseconds: 400),
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
              shadows: List.generate(3, (index) => const Shadow(blurRadius: 8)),
            ),
          ).wrapPadding(const EdgeInsets.only(left: 2)),
        ],
      ),
      onPressed: () {
        switch (widget.gameType) {
          case GameType.Training:   return skillOnTapFNTraining(element);
          case GameType.Challanger: return skillOnTapFNChallanger(element);
          case GameType.Timer:      return skillOnTapFNTimer(element);
          case GameType.Combo:      return skillOnTapFNCombo(element);
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
        if (!timerProvider.isStart) return;
        if (SpellCombinationChecker.checkEquality(spellProvider.nextSpell.combination, currentCombination)) {
          timerProvider.increaseCorrectCounter();
          SoundManager.instance.playSpellSound(spellProvider.nextSpell);
          _animKey.currentState?.playAnimation(IconType.True);
        }
        else {
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
        if (!timerProvider.isStart) return;
        if (SpellCombinationChecker.checkEquality(spellProvider.nextSpell.combination, currentCombination)) {
          timerProvider.increaseCorrectCounter();
          SoundManager.instance.playSpellSound(spellProvider.nextSpell);
          _animKey.currentState?.playAnimation(IconType.True);

          final score = context.read<GameProvider>().getCorrectCombinationCount;
          AchievementManager.instance.updateTimer(score);
        } 
        else {
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
        if (SpellCombinationChecker.checkEquality(spellProvider.nextSpell.combination, currentCombination)) {
          timerProvider.increaseCorrectCounter();
          SoundManager.instance.playSpellSound(spellProvider.nextSpell);
          _animKey.currentState?.playAnimation(IconType.True);
          spellProvider.getRandomSpell();

          final time = context.read<GameProvider>().getTimerValue;
          final score = context.read<GameProvider>().getCorrectCombinationCount;
          AchievementManager.instance.updateChallenger(score, time);
        } 
        else {
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
          context.read<GameProvider>().showResultDialog(GameType.Challanger, DatabaseTable.Challenger);
        }
    }
  }
  
  void skillOnTapFNCombo(Elements element){
    final spellProvider = context.read<SpellProvider>();
    final timerProvider = context.read<GameProvider>();
    switch (element) {
      case Elements.quas:
      case Elements.wex:
      case Elements.exort:
        return switchOrb(element);
      case Elements.invoke:
        if (!timerProvider.isStart) {
          SoundManager.instance.playMeepMerp();
          return;
        }
        SoundManager.instance.playInvoke(volume: 0.12);

        Spell? castedSpell;
        for(final spell in spellProvider.comboSpells) {
          if (SpellCombinationChecker.checkEquality(spell.combination, currentCombination)) {
            castedSpell = spell;
            break;
          }
        }

        if (castedSpell == null) {
          SoundManager.instance.failCombinationSound();
          return;
        }

        final spellIndex = spellProvider.comboSpells.indexOf(castedSpell);
        if (spellProvider.correctSpells[spellIndex] != true) {
          spellProvider.correctSpells[spellIndex] = true;
          spellProvider.updateView();
          SoundManager.instance.playSpellSound(spellProvider.comboSpells[spellIndex]);
        }

        final int correctSpellCount = spellProvider.correctSpells.where((element) => element == true).length;
        final bool isComboComplete = correctSpellCount == spellProvider.comboSpellNum;
        if (isComboComplete) {
          timerProvider.increaseCorrectCounter();
          final score = context.read<GameProvider>().getCorrectCombinationCount;
          AchievementManager.instance.updateCombo(score);
          context.read<GameProvider>().updateCountdownTimeBasedOnScore();
          spellProvider.getRandomComboSpells();
        }
    }
  }

  Widget startButton() {
    final isStart = context.read<GameProvider>().isStart;
    if (isStart) return const EmptyBox();
    return AppOutlinedButton(
      title: LocaleKeys.commonGeneral_start.locale, 
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
      case GameType.Timer:
        context.read<GameProvider>().startCoundown(gameType: GameType.Timer, databaseTable: DatabaseTable.TimeTrial);
      case GameType.Combo:
        context.read<GameProvider>().updateCountdownTimeBasedOnScore();
        context.read<GameProvider>().startCoundown(gameType: GameType.Combo, databaseTable: DatabaseTable.Combo);
        context.read<SpellProvider>().getRandomComboSpells();
        return;
    }
    context.read<SpellProvider>().getRandomSpell();
  }
  
  double get qwerHudHeight {
    final isStart = context.read<GameProvider>().isStart;
    const totalButtonHeight = 96;
    final double max = context.dynamicHeight(0.12);
    final double sliderVal = AppServices.instance.localStorageService.
      getValue<int>(LocalStorageKey.qwerHudHeight)?.toDouble() ?? 20;

    final calculatedVal =  (sliderVal / 100 * max) + (isStart ? (sliderVal / 100 * totalButtonHeight) : 0);

    return calculatedVal;
  }

}
