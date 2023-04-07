import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../extensions/widget_extension.dart';
import '../services/sound_manager.dart';
import '../utils/ads_helper.dart';

class WatchAdButton extends StatelessWidget {
  const WatchAdButton({super.key, required this.afterWatchingAdFn, required this.isAdWatched, required this.title});

  final String title;
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.slow_motion_video, size: 26,),
            EmptyBox.w4(),
            Text(
              title,
              style: TextStyle(
                fontSize: context.sp(13),
                fontWeight: FontWeight.bold,
                shadows: List.generate(2, (index) => Shadow(blurRadius: 2)),
              ),
            ),
            Image.asset(ImagePaths.gold, height: 28),
          ],
        ),
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
    await AdsHelper.instance.rewardedInterstitialAd?.show(onUserEarnedReward: (ad, reward) async {
      afterWatchingAdFn.call();
      await AdsHelper.instance.rewardedInterstitialAdLoad();
    });
  }
}