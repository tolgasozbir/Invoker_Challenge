// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/providers/boss_provider.dart';
import 'package:dota2_invoker_game/services/sound_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../extensions/widget_extension.dart';
import '../../utils/ads_helper.dart';

class BossResultRoundDialogContent extends StatelessWidget {
  final BossRoundResultModel model;

  const BossResultRoundDialogContent({super.key, required this.model});

  int get goldAmount => (model.round+1) * 100;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        EmptyBox.h8(),
        _resultField("Boss", model.boss.capitalize()),
        EmptyBox.h4(),
        _resultField("Elapsed Time", "${model.time} Sec"),
        EmptyBox.h4(),
        _resultField("Average DPS", model.averageDps.toStringAsFixed(0)),
        EmptyBox.h4(),
        _resultField("Max DPS (All Round)", model.maxDps.toStringAsFixed(0)),
        EmptyBox.h4(),
        _resultField("Physical Damage", model.physicalDamage.toStringAsFixed(0)),
        EmptyBox.h4(),
        _resultField("Magical Damage", model.magicalDamage.toStringAsFixed(0)),
        EmptyBox.h4(),
        _resultField("Earned Gold", model.earnedGold.toString()),
        EmptyBox.h16(),
        GestureDetector(
          onTap: context.watch<BossProvider>().isAdWatched ? meepMerp : () async => await watchAdFn(context),
          child: Container(
            width: context.dynamicWidth(0.36),
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.blue.shade400,
                  Colors.blue,
                ],
              ),
              borderRadius: BorderRadius.circular(4)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.slow_motion_video),
                EmptyBox.w4(),
                Text(goldAmount.toString()),
                Image.asset(ImagePaths.gold, height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _resultField(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.resultFieldBg,
        borderRadius: BorderRadius.circular(4)
      ),
      //width: double.infinity,
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
      ).wrapPadding(EdgeInsets.all(8)),
    );
  }

  void meepMerp() {
    SoundManager.instance.playMeepMerp();
  }

  Future<void> watchAdFn(BuildContext context) async {
    await AdsHelper.instance.rewardedInterstitialAdLoad();
    if (AdsHelper.instance.rewardedInterstitialAd == null) {
      await AdsHelper.instance.rewardedInterstitialAdLoad();
    }
    await AdsHelper.instance.rewardedInterstitialAd?.show(onUserEarnedReward: (ad, reward) async {
      context.read<BossProvider>().addGoldAfterWatchingAd(goldAmount);
      await AdsHelper.instance.rewardedInterstitialAdLoad();
    });
  }
}

class BossRoundResultModel {
  final int round;
  final String boss;
  final int time;
  final double averageDps;
  final double maxDps;
  final double physicalDamage;
  final double magicalDamage;
  final int earnedGold;

  BossRoundResultModel({
    required this.round,
    required this.boss,
    required this.time,
    required this.averageDps,
    required this.maxDps,
    required this.physicalDamage,
    required this.magicalDamage,
    required this.earnedGold,
  });
}
