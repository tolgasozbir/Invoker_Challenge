import 'package:auto_size_text/auto_size_text.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/utils/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/locale_keys.g.dart';
import '../../../extensions/context_extension.dart';
import '../../../utils/fade_in_page_animation.dart';
import '../../../widgets/empty_box.dart';
import '../../../widgets/sliders/qwer_hud_height_slider.dart';
import '../../../widgets/sliders/volume_slider.dart';
import '../../../widgets/sound_player_switch.dart';
import 'feedback/feedback_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          VolumeSlider(size: context.dynamicHeight(0.24)),
          const QWERHudHeightSlider(),
          const EmptyBox.h8(),
          const SoundPlayerSwitch(),
          divider(),
          menuItem(
            context: context,
            leading: CupertinoIcons.text_bubble,
            text: LocaleKeys.settings_feedback.locale,
            onTap: () => Navigator.push(context, fadeInPageRoute(const FeedbackView())),
          ),
          divider(),
          menuItem(
            context: context,
            leading: CupertinoIcons.star_lefthalf_fill,
            text: LocaleKeys.settings_rateApp.locale,
            onTap: () => UrlLauncher.instance.storeRedirect(),
          ),
          divider(),
          // menuItem(
          //   context: context,
          //   leading: CupertinoIcons.gift,
          //   text: LocaleKeys.supportUsField_supportUs.locale,
          //   onTap: () async {
          //     await AdsHelper.instance.interstitialAdLoad();
          //     if (AdsHelper.instance.interstitialAd != null) {
          //       await AdsHelper.instance.interstitialAd!.show().then((value) => null);
          //       AppSnackBar.showSnackBarMessage(
          //         text: LocaleKeys.snackbarMessages_sbTyForSupportUs.locale, 
          //         snackBartype: SnackBarType.success,
          //         duration: const Duration(seconds: 10),
          //       );
          //     }
          //   },
          // ),
          // divider(),
        ],
      ),
    );
  }

  Divider divider() => const Divider(color: AppColors.amber, height: 28);

  Widget menuItem({required BuildContext context, required IconData leading, required String text, VoidCallback? onTap}){
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(leading),
          Expanded(
            child: AutoSizeText(
              '  $text',
              style: TextStyle(fontSize: context.sp(14)),
              maxLines: 1,
            ),
          ),
          const Icon(CupertinoIcons.chevron_forward),
        ],
      ),
    );
  }

}
