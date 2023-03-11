import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../utils/circular_reveal_page_route.dart';
import '../../../widgets/sliders/qwer_hud_height_slider.dart';
import '../../../widgets/sliders/volume_slider.dart';
import 'about_me/about_me.dart';
import 'feedback/feedback_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          VolumeSlider(size: context.dynamicHeight(0.24)),
          QWERHudHeightSlider(),
          EmptyBox.h8(),
          divider(),
          menuItem(
            context: context,
            leading: FontAwesomeIcons.questionCircle,
            text: AppStrings.aboutMe,
            onTap: () => Navigator.push(context, circularRevealPageRoute(AboutMeView())),
          ),
          divider(),
          menuItem(
            context: context,
            leading: FontAwesomeIcons.commentDots,
            text: AppStrings.feedback,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackView())),
          ),
          divider(),
          menuItem(
            context: context,
            leading: FontAwesomeIcons.starHalfAlt,
            text: AppStrings.rateApp,
            //onTap: () => StoreRedirect.redirect(androidAppId: ''), //TODO:
          ),
          divider(),
        ],
      ),
    );
  }

  Divider divider() => const Divider(color: AppColors.amber, height: 28);

  Widget menuItem({required BuildContext context, required IconData leading, required String text, VoidCallback? onTap}){
    return InkWell(
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
      onTap: onTap,
    );
  }

}
