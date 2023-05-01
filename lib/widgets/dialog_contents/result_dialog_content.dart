import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../enums/database_table.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/widget_extension.dart';
import '../../mixins/screen_state_mixin.dart';
import '../../models/challenger.dart';
import '../../models/time_trial.dart';
import '../../providers/game_provider.dart';
import '../../providers/user_manager.dart';
import '../../services/app_services.dart';
import '../../utils/ads_helper.dart';
import '../app_outlined_button.dart';
import '../app_snackbar.dart';
import '../empty_box.dart';
import '../game_ui_widget.dart';
import '../watch_ad_button.dart';

class ResultDialogContent extends StatefulWidget {
  const ResultDialogContent({super.key, required this.correctCount, required this.time, required this.gameType});

  final int correctCount;
  final int time;
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
      resultField(context, AppStrings.score, widget.correctCount.toString()),
      resultField(context, AppStrings.time, widget.time.toString()),
      resultField(context, AppStrings.exp, '+${UserManager.instance.expCalc(widget.correctCount).toStringAsFixed(0)}'),
      const EmptyBox.h16(),
      if(!context.watch<GameProvider>().isAdWatched) watchAdButton(context),
      const EmptyBox.h8(),
      Text(
        AppStrings.bestScore,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500, 
          fontSize: context.sp(13),
        ),
      ),
      resultField(context, AppStrings.score, UserManager.instance.getBestScore(widget.gameType).toString())
    ],
   );
  }

  WatchAdButton watchAdButton(BuildContext context) {
    return WatchAdButton(
      afterWatchingAdFn: () {
        if (widget.gameType == GameType.Challanger) {
          context.read<GameProvider>().continueChallangerAfterWatchingAd();
        } else {
          context.read<GameProvider>().continueTimerAfterWatchingAd();
        }
        Navigator.pop(context);
      },
      isAdWatched: context.watch<GameProvider>().isAdWatched, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.slow_motion_video, size: 26,),
          const EmptyBox.w4(),
          Text(
            widget.gameType == GameType.Challanger ? 'Continue' : '+30 Sec',
            style: TextStyle(
              fontSize: context.sp(13),
              fontWeight: FontWeight.bold,
              shadows: List.generate(2, (index) => const Shadow(blurRadius: 2)),
            ),
          ),
        ],
      ),
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
          title: AppStrings.send,
          isButtonActive: !isLoading,
          onPressed: () async => submitScoreFn(widget.databaseTable),
        ).wrapExpanded(),
        const EmptyBox.w8(),
        AppOutlinedButton(
          title: AppStrings.back,
          isButtonActive: !isLoading,
          onPressed: () => Navigator.pop(context),
        ).wrapExpanded(),
      ],
    );
  }

  Future<void> submitScoreFn(DatabaseTable dbTable) async {
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

    final hasConnection = await InternetConnectionChecker().hasConnection;
    if (!hasConnection) {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.errorConnection, 
        snackBartype: SnackBarType.error,
      );
      return;
    }

    changeLoadingState();
    bool isOk = false;
    switch (dbTable) {
      case DatabaseTable.TimeTrial:
        isOk = await db.addTimerScore(
          TimeTrial(
            uid: uid, 
            name: name, 
            score: score,
          ),
        );
        break;
      case DatabaseTable.Challenger:
        isOk = await db.addChallengerScore(
          Challenger(
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
        snackBartype: SnackBarType.success,
      );
    } else {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.errorMessage, 
        snackBartype: SnackBarType.error,
      );
    }

    if (mounted) {
      changeLoadingState();
      if (isOk) Navigator.pop(context);
    }
  }
}
