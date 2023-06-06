import '../../extensions/number_extension.dart';
import '../../services/database/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/widget_extension.dart';
import '../../mixins/screen_state_mixin.dart';
import '../../models/score_models/boss_battle.dart';
import '../../providers/boss_battle_provider.dart';
import '../../services/user_manager.dart';
import '../../services/app_services.dart';
import '../app_outlined_button.dart';
import '../app_snackbar.dart';
import '../empty_box.dart';
import '../watch_ad_button.dart';

class BossResultRoundDialogContent extends StatelessWidget {
  final BossBattle model;
  final int earnedGold;
  final double earnedExp;
  final bool timeUp;
  final bool isLast;
  final double bossHpLeft;

  const BossResultRoundDialogContent({
    super.key, 
    required this.model, 
    required this.earnedGold, 
    required this.earnedExp,
    required this.timeUp,
    required this.isLast, 
    required this.bossHpLeft,
  });

  int get goldAmount => model.round * 100;

  @override
  Widget build(BuildContext context) {
    final bestScore = UserManager.instance.getBestBossScore(model.boss);

    return  Column(
      children: [
        _victoryDefeatText(),
        _resultField(AppStrings.boss,            model.boss),
        _resultField(AppStrings.elapsedTime,     '${model.time} Sec'),
        if(timeUp) 
          _resultField(AppStrings.remainingHp,   bossHpLeft.numberFormat),
        _resultField(AppStrings.AverageDps5Sec,  model.averageDps.numberFormat),
        _resultField(AppStrings.maxDps,          model.maxDps.numberFormat),
        _resultField(AppStrings.physicalDmg,     model.physicalDamage.numberFormat),
        _resultField(AppStrings.magicalDmg,      model.magicalDamage.numberFormat),
        _resultField(AppStrings.earnedExp,       earnedExp.numberFormat),
        if (!timeUp && isLast) ...[
          _resultField(AppStrings.earnedGold, earnedGold.numberFormat),
          const EmptyBox.h4(),
          watchAdButton(context),
        ],
        const Divider(),
        if (bestScore.isNotEmpty) ...[
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.bestScoreByKill,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500, 
                    fontSize: context.sp(13),
                  ),
                ),
                const EmptyBox.w4(),
                const Icon(Icons.swipe_down)
              ],
            ),
          ),
          if (timeUp) const EmptyBox.h8(),
          _resultField(AppStrings.elapsedTime, "${bestScore["time"]} ${AppStrings.second}"),
          _resultField(AppStrings.AverageDps,  (bestScore['averageDps'] as double).numberFormat),
          _resultField(AppStrings.maxDps,      (bestScore['maxDps'] as double).numberFormat),
          _resultField(AppStrings.physicalDmg, (bestScore['physicalDamage'] as double).numberFormat),
          _resultField(AppStrings.magicalDmg,  (bestScore['magicalDamage'] as double).numberFormat),
        ]
      ],
    );
  }

  Container _victoryDefeatText() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: AppColors.resultFieldBg,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          timeUp ? AppStrings.defeated : AppStrings.victory, 
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: timeUp ? AppColors.red : AppColors.amber,
          ), 
          textAlign: TextAlign.center,
        ),
      );
  }

  WatchAdButton watchAdButton(BuildContext context) {
    return WatchAdButton(
      title: goldAmount.toString(),
      showGoldIcon: true,
      afterWatchingAdFn: () => context.read<BossBattleProvider>().addGoldAfterWatchingAd(goldAmount), 
      isAdWatched: context.watch<BossBattleProvider>().isAdWatched, 
    );
  }

  Widget _resultField(String title, String value) {
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
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

}

class BossResultRoundDialogAction extends StatefulWidget {
  const BossResultRoundDialogAction({super.key, required this.model});

  final BossBattle model;

  @override
  State<BossResultRoundDialogAction> createState() => _BossResultRoundDialogActionState();
}

class _BossResultRoundDialogActionState extends State<BossResultRoundDialogAction> with ScreenStateMixin {

  bool get isNewScore => widget.model.time <= (UserManager.instance.getBestBossScore(widget.model.boss)['time'] ?? 0);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppOutlinedButton(
          bgColor: isNewScore ? AppColors.green.withOpacity(0.24) : AppColors.red.withOpacity(0.24),
          title: AppStrings.send,
          isButtonActive: !isLoading,
          onPressed: () async => submitScoreFn(),
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
  
  Future<void> submitScoreFn() async {
    final user = UserManager.instance.user;
    final uid = user.uid;
    final db = AppServices.instance.databaseService;
    final bestTime = UserManager.instance.getBestBossScore(widget.model.boss)['time'] ?? 0;
    final score = widget.model;

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (uid == null) {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.errorSubmitScore1, 
        snackBartype: SnackBarType.error,
      );
      return;
    }

    if (widget.model.time > bestTime) {
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

    await db.createOrUpdateUser(user); // update db user model

    changeLoadingState();

    bool isOk = false;
    isOk = await db.addScore<BossBattle>(
      scoreType: ScoreType.Boss, 
      score: score,
    );

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

    changeLoadingState();
    if (isOk) Navigator.pop(context);
  }
}
