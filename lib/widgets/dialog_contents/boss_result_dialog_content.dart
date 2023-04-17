import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/string_extension.dart';
import '../../extensions/widget_extension.dart';
import '../../mixins/loading_state_mixin.dart';
import '../../models/boss_round_result_model.dart';
import '../../providers/boss_provider.dart';
import '../../providers/user_manager.dart';
import '../../services/app_services.dart';
import '../../utils/number_formatter.dart';
import '../app_outlined_button.dart';
import '../app_snackbar.dart';
import '../watch_ad_button.dart';

class BossResultRoundDialogContent extends StatelessWidget {
  final BossRoundResultModel model;
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
    required this.bossHpLeft
  });

  int get goldAmount => model.round * 100;

  @override
  Widget build(BuildContext context) {
    var bestScore = UserManager.instance.getBestBossScore(model.boss);

    return  Column(
      children: [
        _victoryDefeatText(),
        _resultField("Boss", model.boss.capitalize()),
        _resultField("Elapsed Time", "${model.time} Sec"),
        if(timeUp) _resultField("Remaining HP", priceString(bossHpLeft)),
        _resultField("Average DPS", priceString(model.averageDps)),
        _resultField("Max DPS (All Round)", priceString(model.maxDps)),
        _resultField("Physical Damage", priceString(model.physicalDamage)),
        _resultField("Magical Damage", priceString(model.magicalDamage)),
        if(!timeUp) _resultField("Earned Exp", priceString(earnedExp)),
        if (!timeUp && isLast) ...[
          _resultField("Earned Gold", priceString(earnedGold.toDouble())),
          EmptyBox.h4(),
          watchAdButton(context),
        ],
        EmptyBox(),
        Divider(),
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your best score by kill time ",//AppStrings.bestScore,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500, 
                  fontSize: context.sp(13),
                ),
              ),
              Icon(Icons.swipe_down)
            ],
          ),
        ),
        if (timeUp) EmptyBox.h8(),
        _resultField("Elapsed Time", "${bestScore["time"]} Sec"),
        _resultField("Average DPS", priceString(bestScore["averageDps"])),
        _resultField("Max DPS", priceString(bestScore["maxDps"])),
        _resultField("Physical Damage", priceString(bestScore["physicalDamage"])),
        _resultField("Magical Damage", priceString(bestScore["magicalDamage"])),
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
            color: timeUp ? AppColors.red : AppColors.amber
          ), 
          textAlign: TextAlign.center
        ),
      );
  }

  WatchAdButton watchAdButton(BuildContext context) {
    return WatchAdButton(
      afterWatchingAdFn: () => context.read<BossProvider>().addGoldAfterWatchingAd(goldAmount), 
      isAdWatched: context.watch<BossProvider>().isAdWatched, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.slow_motion_video, size: 26,),
          EmptyBox.w4(),
          Text(
            goldAmount.toString(),
            style: TextStyle(
              fontSize: context.sp(13),
              fontWeight: FontWeight.bold,
              shadows: List.generate(2, (index) => Shadow(blurRadius: 2)),
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
            style: TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

}

class BossResultRoundDialogAction extends StatefulWidget {
  const BossResultRoundDialogAction({super.key, required this.model});

  final BossRoundResultModel model;

  @override
  State<BossResultRoundDialogAction> createState() => _BossResultRoundDialogActionState();
}

class _BossResultRoundDialogActionState extends State<BossResultRoundDialogAction> with LoadingState {

  bool get isNewScore => widget.model.time <= UserManager.instance.getBestBossScore(widget.model.boss)["time"];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppOutlinedButton(
          bgColor: isNewScore ? AppColors.green.withOpacity(0.24) : AppColors.red.withOpacity(0.24),
          title: AppStrings.send,
          isButtonActive: !isLoading,
          onPressed: () async => await submitScoreFn(),
        ).wrapExpanded(),
        EmptyBox.w8(),
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
    final bestTime = UserManager.instance.getBestBossScore(widget.model.boss)["time"];
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

    var hasConnection = await InternetConnectionChecker().hasConnection;
    if (!hasConnection) {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.errorConnection, 
        snackBartype: SnackBarType.error,
      );
      return;
    }

    db.createOrUpdateUser(user); // update db user model

    changeLoadingState();

    bool isOk = false;
    isOk = await db.addBossScore(score);

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

    changeLoadingState();
    if (isOk) Navigator.pop(context);
  }
}
