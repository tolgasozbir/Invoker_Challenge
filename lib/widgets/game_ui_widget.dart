import 'package:dota2_invoker/widgets/timer_hud.dart';
import '../extensions/widget_extension.dart';
import '../mixins/loading_state_mixin.dart';
import '../services/app_services.dart';
import '../providers/user_manager.dart';
import 'app_outlined_button.dart';
import 'app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
import '../services/sound_manager.dart';
import 'app_dialogs.dart';
import 'result_dialog_content.dart';
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

  @override
  Widget build(BuildContext context) => _bodyView();

  Column _bodyView() {
    return Column(
      children: [
        if (widget.gameType != GameType.Training)...[
          TimerHud(gameType: widget.gameType),
          trueCounter(),
        ],
        TrueFalseIconWidget(key: _animKey),
        bigSpellPicture(),
        selectedElementOrbs(),
        skills(),
        startButton()
      ],
    );
  }

  Widget trueCounter(){
    return Text(
      context.watch<GameProvider>().getCorrectCombinationCount.toString(),
      style: TextStyle(fontSize: context.sp(36), color: AppColors.scoreCounterColor,),
    ).wrapPadding(EdgeInsets.only(top: 8));
  }

  Widget bigSpellPicture(){
    return Container(
      width: context.dynamicWidth(0.28),
      height: context.dynamicWidth(0.28),
      decoration: const BoxDecoration(
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
          SoundManager.instance.trueCombinationSound(spellProvider.getNextCombination);
          _animKey.currentState?.playAnimation(IconType.True);
        }else{
          SoundManager.instance.failCombinationSound();
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
          SoundManager.instance.trueCombinationSound(spellProvider.getNextCombination);
          _animKey.currentState?.playAnimation(IconType.True);
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
        if (currentCombination.toString() == spellProvider.getNextCombination.toString()) {
          timerProvider.increaseCorrectCounter();
          SoundManager.instance.trueCombinationSound(spellProvider.getNextCombination);
          _animKey.currentState?.playAnimation(IconType.True);
          spellProvider.getRandomSpell();
        } else {
          SoundManager.instance.ggSound();
          timerProvider.changeIsStartStatus();
          timerProvider.disposeTimer();
          _animKey.currentState?.playAnimation(IconType.False);
          showResultDialog(DatabaseTable.challenger);
        }
    }
  }

  void showResultDialog(DatabaseTable dbTable) {
    var score = context.read<GameProvider>().getCorrectCombinationCount;
    UserManager.instance.addExp(score);
    UserManager.instance.setBestScore(widget.gameType, score);
    AppDialogs.showSlidingDialog(
      title: AppStrings.result, 
      content: ResultDialogContent(
        correctCount: score,
        gameType: widget.gameType,
      ),
      action: StatefulBuilder(
        builder: (context, setState) => Row(
          children: [
            AppOutlinedButton(
              title: AppStrings.send,
              isButtonActive: !isLoading,
              onPressed: () async => await submitScoreFn(setState ,dbTable),
            ).wrapExpanded(),
            EmptyBox.w8(),
            AppOutlinedButton(
              title: AppStrings.back,
              isButtonActive: !isLoading,
              onPressed: () => Navigator.pop(context),
            ).wrapExpanded(),
          ],
        ),
      ),
    );
  }

  Future<void> submitScoreFn(void Function(void Function()) setState, DatabaseTable dbTable) async {
    final isLoggedIn = UserManager.instance.isLoggedIn();
    final user = UserManager.instance.user;
    final uid = user.uid;
    final name = user.username;
    final score = context.read<GameProvider>().getCorrectCombinationCount;
    final time = context.read<GameProvider>().getTimeValue;
    final db = AppServices.instance.databaseService;

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (!isLoggedIn || uid == null) {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.errorSubmitScore1, 
        snackBartype: SnackBarType.error,
      );
      return;
    }

    if (score < UserManager.instance.getBestScore(widget.gameType)) {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.errorSubmitScore2, 
        snackBartype: SnackBarType.error,
      );
      return;
    }

    var hasConnection = await InternetConnectionChecker().hasConnection;
    if (!hasConnection) {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.errorConnection, 
        snackBartype: SnackBarType.error,
      );
      return;
    }

    if (mounted) setState.call(() => changeLoadingState(forceUI: false));
    bool isOk = false;
    switch (dbTable) {
      case DatabaseTable.timer:
        isOk = await db.addTimerScore(
          TimerResult(
            uid: uid, 
            name: name, 
            score: score,
          ),
        );
        break;
      case DatabaseTable.challenger:
        isOk = await db.addChallengerScore(
          ChallengerResult(
            uid: uid, 
            name: name, 
            time: time, 
            score: score,
          ),
        );
        break;
    }

    if (isOk) {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.succesSubmitScore, 
        snackBartype: SnackBarType.success
      );
    } else {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.errorMessage, 
        snackBartype: SnackBarType.error
      );
    }

    if (mounted) {
      setState.call(() => changeLoadingState(forceUI: false));
      if (isOk) Navigator.pop(context);
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
        context.read<GameProvider>().startTimer(); 
        break;
      case GameType.Timer:
        context.read<GameProvider>().startCoundown(showResultDialog);
        break;
    }
    context.read<SpellProvider>().getRandomSpell();
  }
  
}
