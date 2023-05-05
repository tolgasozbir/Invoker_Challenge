import 'package:dota2_invoker_game/extensions/number_extension.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/widget_extension.dart';
import '../../mixins/screen_state_mixin.dart';
import '../../models/boss_battle_result.dart';
import '../../providers/boss_battle_provider.dart';
import '../../providers/user_manager.dart';
import '../../services/app_services.dart';
import '../app_outlined_button.dart';
import '../app_snackbar.dart';
import '../empty_box.dart';
import '../watch_ad_button.dart';

class BossResultRoundDialogContent extends StatelessWidget {
  final BossBattleResult model;
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
        _resultField('Boss',                      model.boss),
        _resultField('Elapsed Time',              '${model.time} Sec'),
        if(timeUp) _resultField('Remaining HP',   bossHpLeft.numberFormat),
        _resultField('Average DPS (Last 5 Sec)',  model.averageDps.numberFormat),
        _resultField('Max DPS',                   model.maxDps.numberFormat),
        _resultField('Physical Damage',           model.physicalDamage.numberFormat),
        _resultField('Magical Damage',            model.magicalDamage.numberFormat),
        _resultField('Earned Exp',                earnedExp.numberFormat),
        if (!timeUp && isLast) ...[
          _resultField('Earned Gold', earnedGold.numberFormat),
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
          _resultField('Elapsed Time',    "${bestScore["time"]} Sec"),
          _resultField('Average DPS',     (bestScore['averageDps'] as double).numberFormat),
          _resultField('Max DPS',         (bestScore['maxDps'] as double).numberFormat),
          _resultField('Physical Damage', (bestScore['physicalDamage'] as double).numberFormat),
          _resultField('Magical Damage',  (bestScore['magicalDamage'] as double).numberFormat),
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
      afterWatchingAdFn: () => context.read<BossBattleProvider>().addGoldAfterWatchingAd(goldAmount), 
      isAdWatched: context.watch<BossBattleProvider>().isAdWatched, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.slow_motion_video, size: 26,),
          const EmptyBox.w4(),
          Text(
            goldAmount.toString(),
            style: TextStyle(
              fontSize: context.sp(13),
              fontWeight: FontWeight.bold,
              shadows: List.generate(2, (index) => const Shadow(blurRadius: 2)),
            ),
          ),
          Image.asset(ImagePaths.gold, height: 28),
        ],
      ),
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

  final BossBattleResult model;

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
    final isLoggedIn = UserManager.instance.isLoggedIn();
    final user = UserManager.instance.user;
    final uid = user.uid;
    final db = AppServices.instance.databaseService;
    final bestTime = UserManager.instance.getBestBossScore(widget.model.boss)['time'] ?? 0;
    final score = widget.model;

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (!isLoggedIn || uid == null) {
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
    isOk = await db.addBossScore(score);

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
