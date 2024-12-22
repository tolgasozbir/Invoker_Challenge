import 'package:dota2_invoker_game/widgets/crownfall_button.dart';
import 'package:flutter/material.dart';

import '../constants/app_image_paths.dart';
import '../extensions/context_extension.dart';
import '../services/sound_manager.dart';
import '../utils/ads_helper.dart';
import 'empty_box.dart';

class WatchAdButton extends StatelessWidget {
  const WatchAdButton({
    super.key, 
    required this.title, 
    required this.afterWatchingAdFn, 
    required this.isAdWatched, 
    required this.showGoldIcon,
  });

  final String title;
  final bool showGoldIcon;
  final bool isAdWatched;
  final VoidCallback afterWatchingAdFn;

  @override
  Widget build(BuildContext context) {
    return CrownfallButton.normal(
      buttonType: isAdWatched ? CrownfallButtonTypes.Onyx : CrownfallButtonTypes.Azurite,
      onTap: isAdWatched ? meepMerp : () async => watchAdFn(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.slow_motion_video, size: 26,),
          const EmptyBox.w4(),
          Text(
            title,
            style: TextStyle(
              fontSize: context.sp(13),
              fontWeight: FontWeight.bold,
              shadows: List.generate(2, (index) => const Shadow(blurRadius: 2)),
            ),
          ),
          if(showGoldIcon) Image.asset(ImagePaths.gold, height: 28),
        ],
      ),
    );
  }

  void meepMerp() {
    SoundManager.instance.playMeepMerp();
  }

  Future<void> watchAdFn(BuildContext context) async {
    await AdsHelper.instance.rewardedAdLoad();
    if (AdsHelper.instance.rewardedAd == null) {
      await AdsHelper.instance.rewardedAdLoad();
    }
    if (AdsHelper.instance.rewardedAd != null) {
      await AdsHelper.instance.rewardedAd?.show(
        onUserEarnedReward: (ad, reward) async {
          afterWatchingAdFn.call();
          await AdsHelper.instance.rewardedAdLoad();
        },
      );
    }
  }
}
