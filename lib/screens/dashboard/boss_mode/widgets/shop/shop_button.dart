import 'dart:developer';

import 'package:dota2_invoker_game/constants/locale_keys.g.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/boss_battle_provider.dart';
import '../../../../../services/sound_manager.dart';
import '../../../../../utils/ads_helper.dart';
import '../../../../../utils/fade_in_page_animation.dart';
import '../../../../../widgets/bouncing_button.dart';
import 'shop_view.dart';

class ShopButton extends StatelessWidget {
  const ShopButton({super.key,});

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      child: Stack(
        children: [
          Container(
            width: 72,
            height: kToolbarHeight,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              gradient: LinearGradient(
                colors: [Color(0xFFE7CB90), Color(0xFF584226), Color(0xFFAB945A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(
            width: 64,
            alignment: Alignment.center,
            height: kToolbarHeight,
            margin: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              gradient: LinearGradient(
                colors: [Color(0xFFD9BA00), Color(0xFFF4C400), Color(0xFF7E5B0C)],
                stops: [0, .2, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Text(
              LocaleKeys.commonGeneral_shop.locale, 
              style: const TextStyle(
                fontSize: 16, 
                color: Color(0xFFFBFBCC), 
                fontWeight: FontWeight.bold, 
                shadows: [Shadow(blurRadius: 2)],
              ),
            ),
          ),
        ],
      ),
      onPressed: () async {
        final bool isClickable = !context.read<BossBattleProvider>().started && 
                         context.read<BossBattleProvider>().snapIsDone && 
                        !context.read<BossBattleProvider>().isHornSoundPlaying;
        if(isClickable) {
          AdsHelper.instance.shopEntryAdCounter++;
          if (AdsHelper.instance.shopEntryAdCounter % 4 == 0) {
            try {
              await AdsHelper.instance.appOpenAdLoad();
            } catch (e) {
              log('err interstitialAd $e');
            }
            Navigator.push(context, fadeInPageRoute(const ShopView()));
            return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopView(),));
        }
        else {
          SoundManager.instance.playMeepMerp();
        }
      },
    );
  }
}
