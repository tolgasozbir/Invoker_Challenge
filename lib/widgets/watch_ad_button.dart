import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../services/sound_manager.dart';
import '../utils/ads_helper.dart';

class WatchAdButton extends StatelessWidget {
  const WatchAdButton({super.key, required this.afterWatchingAdFn, required this.isAdWatched, required this.child});

  final Widget child;
  final bool isAdWatched;
  final VoidCallback afterWatchingAdFn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAdWatched ? meepMerp : () async => await watchAdFn(context),
      child: Container(
        width: context.dynamicWidth(0.36),
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade600,
              Colors.blue.shade300,
              Colors.blue.shade600,
            ],
          ),
          borderRadius: BorderRadius.circular(4),
          border: Border.all()
        ),
        child: child
      ),
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
    await AdsHelper.instance.rewardedInterstitialAd?.show(
      onUserEarnedReward: (ad, reward) async {
        afterWatchingAdFn.call();
        await AdsHelper.instance.rewardedInterstitialAdLoad();
      }
    );
  }
}