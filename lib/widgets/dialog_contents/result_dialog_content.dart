import 'package:dota2_invoker_game/extensions/string_extension.dart';

import '../../constants/locale_keys.g.dart';
import '../../models/score_models/combo.dart';
import '../../services/database/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../enums/database_table.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/widget_extension.dart';
import '../../mixins/screen_state_mixin.dart';
import '../../models/score_models/challenger.dart';
import '../../models/score_models/time_trial.dart';
import '../../providers/game_provider.dart';
import '../../services/user_manager.dart';
import '../../services/app_services.dart';
import '../../utils/ads_helper.dart';
import '../app_outlined_button.dart';
import '../app_snackbar.dart';
import '../empty_box.dart';
import '../game_ui_widget.dart';
import '../watch_ad_button.dart';

class ResultDialogContent extends StatefulWidget {
  const ResultDialogContent({
    super.key, 
    required this.correctCount, 
    required this.time, 
    required this.exp,
    required this.gameType, 
  });

  final int correctCount;
  final int time;
  final int exp;
  final GameType gameType;

  @override
  State<ResultDialogContent> createState() => _ResultDialogContentState();
}

class _ResultDialogContentState extends State<ResultDialogContent> {

  @override
  void initState() {
    Future.microtask(() async => AdsHelper.instance.rewardedInterstitialAdLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return Column(
    children: [
      resultField(context, LocaleKeys.commonGeneral_score.locale, widget.correctCount.toString()),
      resultField(context, LocaleKeys.commonGeneral_time.locale, widget.time.toString()),
      resultField(context, LocaleKeys.commonGeneral_exp.locale, '+${UserManager.instance.expCalc(widget.exp).toStringAsFixed(0)}'),
      const EmptyBox.h16(),
      if(!context.watch<GameProvider>().isAdWatched) watchAdButton(context),
      const EmptyBox.h8(),
      Text(
        LocaleKeys.commonGeneral_bestScore.locale,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500, 
          fontSize: context.sp(13),
        ),
      ),
      resultField(context, LocaleKeys.commonGeneral_score.locale, UserManager.instance.getBestScore(widget.gameType).toString()),
    ],
   );
  }

  WatchAdButton watchAdButton(BuildContext context) {
    String btnTitle = '';
    switch (widget.gameType) {
      case GameType.Training:
        break;
      case GameType.Challanger:
        btnTitle = LocaleKeys.adBtn_continue.locale;
      case GameType.Timer:
        btnTitle = LocaleKeys.adBtn_sec30.locale;
      case GameType.Combo:
        btnTitle = LocaleKeys.adBtn_sec10.locale;
    }
    return WatchAdButton(
      title: btnTitle,
      showGoldIcon: false,
      afterWatchingAdFn: () {
        switch (widget.gameType) {
          case GameType.Training: 
            break;
          case GameType.Challanger:
            context.read<GameProvider>().continueChallangerAfterWatchingAd();
          case GameType.Timer:
            context.read<GameProvider>().continueTimeTrialAfterWatchingAd();
          case GameType.Combo:
            context.read<GameProvider>().continueComboAfterWatchingAd();
        }
        Navigator.pop(context);
      },
      isAdWatched: context.watch<GameProvider>().isAdWatched, 
    );
  }

  Widget resultField(BuildContext context, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.resultFieldBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500, 
              fontSize: context.sp(13),
            ),
          ),
          const Spacer(),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800, 
              fontSize: context.sp(13),
            ),
          ),
        ],
      ).wrapPadding(const EdgeInsets.all(4)),
    );
  }
}


class ResultDialogAction extends StatefulWidget {
  const ResultDialogAction({super.key, required this.databaseTable, required this.gameType});

  final DatabaseTable databaseTable;
  final GameType gameType;

  @override
  State<ResultDialogAction> createState() => _ResultDialogActionState();
}

class _ResultDialogActionState extends State<ResultDialogAction> with ScreenStateMixin {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppOutlinedButton(
          title: LocaleKeys.commonGeneral_send.locale,
          isButtonActive: !isLoading,
          onPressed: () async => submitScoreFn(widget.databaseTable),
        ).wrapExpanded(),
        const EmptyBox.w8(),
        AppOutlinedButton(
          title: LocaleKeys.commonGeneral_back.locale,
          isButtonActive: !isLoading,
          onPressed: () => Navigator.pop(context),
        ).wrapExpanded(),
      ],
    );
  }

  Future<void> submitScoreFn(DatabaseTable dbTable) async {
    final user = UserManager.instance.user;
    final uid = user.uid;
    final name = user.username;
    final score = context.read<GameProvider>().getCorrectCombinationCount;
    final time = context.read<GameProvider>().getTimerValue;
    final db = AppServices.instance.databaseService;

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (uid == null) {
      AppSnackBar.showSnackBarMessage(
        text: LocaleKeys.snackbarMessages_errorSubmitScore1.locale, 
        snackBartype: SnackBarType.error,
      );
      return;
    }

    if (score < UserManager.instance.getBestScore(widget.gameType)) {
      AppSnackBar.showSnackBarMessage(
        text: LocaleKeys.snackbarMessages_errorSubmitScore2.locale, 
        snackBartype: SnackBarType.error,
      );
      return;
    }

    final hasConnection = await InternetConnectionChecker().hasConnection;
    if (!hasConnection) {
      AppSnackBar.showSnackBarMessage(
        text: LocaleKeys.snackbarMessages_errorConnection.locale, 
        snackBartype: SnackBarType.error,
      );
      return;
    }

    changeLoadingState();
    bool isOk = false;
    switch (dbTable) {
      case DatabaseTable.TimeTrial:
        isOk = await db.addScore<TimeTrial>(
          scoreType: ScoreType.TimeTrial, 
          score: TimeTrial(
            uid: uid, 
            name: name, 
            score: score,
          ),
        );
      case DatabaseTable.Challenger:
        isOk = await db.addScore<Challenger>(
          scoreType: ScoreType.Challenger, 
          score: Challenger(
            uid: uid, 
            name: name,
            time: time, 
            score: score,
          ),
        );
      case DatabaseTable.Combo:
        isOk = await db.addScore<Combo>(
          scoreType: ScoreType.Combo, 
          score: Combo(
            uid: uid, 
            name: name, 
            score: score,
          ),
        );
    }

    if (isOk) {
      AppSnackBar.showSnackBarMessage(
        text: LocaleKeys.snackbarMessages_succesSubmitScore.locale, 
        snackBartype: SnackBarType.success,
      );
    } else {
      AppSnackBar.showSnackBarMessage(
        text: LocaleKeys.snackbarMessages_errorMessage.locale, 
        snackBartype: SnackBarType.error,
      );
    }

    if (mounted) {
      changeLoadingState();
      if (isOk) Navigator.pop(context);
    }
  }
}
