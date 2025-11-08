import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/locale_keys.g.dart';
import '../../enums/Bosses.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/number_extension.dart';
import '../../extensions/string_extension.dart';
import '../../extensions/widget_extension.dart';
import '../../mixins/screen_state_mixin.dart';
import '../../models/score_models/boss_battle.dart';
import '../../providers/boss_battle_provider.dart';
import '../../services/app_services.dart';
import '../../services/database/firestore_service.dart';
import '../../services/user_manager.dart';
import '../app_snackbar.dart';
import '../crownfall_button.dart';
import '../empty_box.dart';
import '../watch_ad_button.dart';

class BossResultRoundDialogContent extends StatelessWidget {
  final BossBattle model;
  final Bosses boss;
  final int totalEarnedGold;
  final double earnedExp;
  final bool timeUp;
  final bool isLast;
  final double bossHpLeft;

  const BossResultRoundDialogContent({
    super.key, 
    required this.model, 
    required this.boss,
    required this.totalEarnedGold,
    required this.earnedExp,
    required this.timeUp,
    required this.isLast, 
    required this.bossHpLeft,
  });

  int get goldAmount => (model.round+3) * 100;

  @override
  Widget build(BuildContext context) {
    final bestTime = UserManager.instance.getBestBossScore(boss)['time'] as int? ?? 0;
    
    return  Column(
      children: [
        //Header
        header(context),
        //Stats
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if(timeUp) 
                  _resultField(LocaleKeys.leaderboard_remainingHp.locale,   bossHpLeft.numberFormat),
                _resultField(LocaleKeys.leaderboard_elapsedTime.locale,     '${model.time} ${LocaleKeys.leaderboard_second.locale}'),
                _resultField(LocaleKeys.leaderboard_bestTime.locale, bestTime > 0 ? '$bestTime ${LocaleKeys.leaderboard_second.locale}' : '-'),
                _damages(),
                _resultField(LocaleKeys.leaderboard_AverageDps.locale, model.averageDps.numberFormat),
                _resultField(LocaleKeys.leaderboard_earnedExp.locale,earnedExp.numberFormat, color: AppColors.green),
                if (!timeUp && isLast) ...[
                  if (UserManager.instance.user.isPremium) _resultField(LocaleKeys.leaderboard_bonusGold.locale, goldAmount.numberFormat, color: AppColors.amber),
                  _resultField(LocaleKeys.leaderboard_earnedGold.locale, totalEarnedGold.numberFormat, color: AppColors.amber),
                  const EmptyBox.h4(),
                  watchAdButton(context),
                  const EmptyBox.h4(),
                ],
              ],
            ),
          ),
        ),

      ],
    );
  }

  Column header(BuildContext context) {
    final String lastBossText = model.round == Bosses.values.length ? ' ${LocaleKeys.commonGeneral_last.locale} ' : ' ';
    final victoryDefeatText = timeUp ? LocaleKeys.commonGeneral_defeated.locale : LocaleKeys.commonGeneral_victory.locale;
    return Column(
        children: [
          //Title
          AutoSizeText(
            '${LocaleKeys.leaderboard_round.locale} ${model.round}$lastBossText$victoryDefeatText',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.w500, fontFamily: 'Virgil'),
          ),
          const EmptyBox.h4(),
          //Circle Image
          Container(
            width: context.dynamicWidth(0.32),
            height: context.dynamicWidth(0.32),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              Bosses.values[model.round-1].getImage,
              fit: BoxFit.cover,
            ),
          ),
          //Boss name
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              model.boss,
              style: TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.w500,  fontFamily: 'Virgil'),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(color: Colors.white, height: 0,),
        ],
      );
  }

  Padding _damages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.leaderboard_physicalDmg.locale,
                style: const TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              Text(
                LocaleKeys.leaderboard_magicalDmg.locale,
                style: const TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: calculateFlex('physical'),
                child: Container(
                  height: 24,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border: Border.all(),
                  ),
                ),
              ),
              Container(
                height: 32,
                width: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
              ),
              Expanded(
                flex: calculateFlex('magical'),
                child: Container(
                  height: 24,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border: Border.all(),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.physicalDamage.toInt().numberFormat,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, 
                    fontFamily: 'Virgil',
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  model.magicalDamage.toInt().numberFormat,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, 
                    fontFamily: 'Virgil',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int calculateFlex(String damageType) {
    // Toplam hasarı hesaplayın
    final totalDamage = model.physicalDamage + model.magicalDamage;
    if (totalDamage <= 0) {
      return 1;
    }
    int flex;

    // Belirtilen hasar türüne göre yüzdesini hesaplayın
    if (damageType == 'magical') {
      flex = ((model.magicalDamage / totalDamage) * 100).toInt();
    } else if (damageType == 'physical') {
      flex = ((model.physicalDamage / totalDamage) * 100).toInt();
    } else {
      throw ArgumentError('Invalid damage type: $damageType');
    }

    // Eğer flex 0 veya 0'dan küçükse, 1 değerini verin
    if (flex <= 0) {
      flex = 1;
    }

    return flex;
  }

  WatchAdButton watchAdButton(BuildContext context) {
    return WatchAdButton(
      title: goldAmount.toString(),
      showGoldIcon: true,
      afterWatchingAdFn: () => context.read<BossBattleProvider>().addGoldAfterWatchingAd(goldAmount), 
      isAdWatched: context.watch<BossBattleProvider>().isAdWatched, 
    );
  }

  Widget _resultField(String title, String value, {Color? color}) {
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
            style: TextStyle(fontWeight: FontWeight.w500, color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

}

class BossResultRoundDialogAction extends StatefulWidget {
  const BossResultRoundDialogAction({super.key, required this.model, required this.boss, required this.timeUp});

  final BossBattle model;
  final Bosses boss;
  final bool timeUp;

  @override
  State<BossResultRoundDialogAction> createState() => _BossResultRoundDialogActionState();
}

class _BossResultRoundDialogActionState extends State<BossResultRoundDialogAction> with ScreenStateMixin {

  bool get isNewScore => !widget.timeUp && widget.model.time <= (UserManager.instance.getBestBossScore(widget.boss)['time'] ?? 0);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CrownfallButton(
          height: 48,
          buttonType: isLoading 
              ? CrownfallButtonTypes.Onyx 
              : isNewScore 
                  ? CrownfallButtonTypes.Jade 
                  : CrownfallButtonTypes.Ruby,
          isButtonActive: !isLoading,
          onTap: () => submitScoreFn(),
          child: Text(
            LocaleKeys.commonGeneral_send.locale,
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ).wrapExpanded(),
        const EmptyBox.w8(),
        CrownfallButton(
          height: 48,
          buttonType: CrownfallButtonTypes.Onyx,
          onTap: () => Navigator.pop(context),
          child: Text(
            LocaleKeys.commonGeneral_back.locale,
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ).wrapExpanded(),
      ],
    );
  }
  
  Future<void> submitScoreFn() async {
    final user = UserManager.instance.user;
    final uid = user.uid;
    final db = AppServices.instance.databaseService;
    final bestTime = UserManager.instance.getBestBossScore(widget.boss)['time'] ?? 0;
    final score = widget.model;

    //TODO check if magic damage + pyscial damage not bigger than boss healt return throw error and save log to firebase
    // yüzde 5-10 luk sapma payı koyabilirsin ayrıca saniye kontrolüde yapabilirsin
    // son seviyede sadece spell atarak kaç sn de bitiyorsa ilk boss onun bir iki saniye altını hesap edebilirsin

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (uid == null) {
      AppSnackBar.showSnackBarMessage(
        text: LocaleKeys.snackbarMessages_errorSubmitScore1.locale, 
        snackBartype: SnackBarType.error,
      );
      return;
    }

    if (widget.model.time > bestTime || widget.timeUp) {
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

    await db.createOrUpdateUser(user); // update db user model

    changeLoadingState();

    bool isOk = false;
    isOk = await db.addScore<BossBattle>(
      scoreType: ScoreType.Boss, 
      score: score,
    );

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

    changeLoadingState();
    if (isOk && mounted) Navigator.pop(context);
  }
}
