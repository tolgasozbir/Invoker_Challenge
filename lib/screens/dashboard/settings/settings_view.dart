import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../extensions/context_extension.dart';
import '../../../utils/fade_in_page_animation.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../widgets/empty_box.dart';
import '../../../widgets/sliders/qwer_hud_height_slider.dart';
import '../../../widgets/sliders/volume_slider.dart';
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
          divider(),
          menuItem(
            context: context,
            leading: FontAwesomeIcons.commentDots,
            text: AppStrings.feedback,
            onTap: () => Navigator.push(context, fadeInPageRoute(const FeedbackView())),
          ),
          divider(),
          menuItem(
            context: context,
            leading: FontAwesomeIcons.starHalfAlt,
            text: AppStrings.rateApp,
            onTap: storeRedirect,
          ),
          divider(),
        ],
      ),
    );
  }

  Future<void> storeRedirect() async {
    const String googlePlayStoreUrl = 'https://play.google.com/store/apps/details?id=com.dota2.invoker.game';
    try{
      await launchUrl(
        Uri.parse(googlePlayStoreUrl),
        mode: LaunchMode.externalApplication,
      );
    }
    catch(e) {
      AppSnackBar.showSnackBarMessage(text: AppStrings.errorMessage, snackBartype: SnackBarType.error);
    }
  }

  Divider divider() => const Divider(color: AppColors.amber, height: 28);

  Widget menuItem({required BuildContext context, required IconData leading, required String text, VoidCallback? onTap}){
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(leading),
          const Spacer(),
          Text(text, style: TextStyle(fontSize: context.sp(14)),),
          const Spacer(flex: 9,),
          const Icon(CupertinoIcons.chevron_forward)
        ],
      ),
    );
  }

}
