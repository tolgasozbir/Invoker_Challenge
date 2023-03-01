import 'package:dota2_invoker/screens/dashboard/settings/feedback/feedback_view.dart';
import 'package:dota2_invoker/utils/circular_reveal_page_route.dart';
import 'package:dota2_invoker/widgets/sliders/qwer_hud_height_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../providers/user_manager.dart';
import '../../../services/app_services.dart';
import '../../../widgets/app_outlined_button.dart';
import '../../../widgets/sliders/volume_slider.dart';
import 'about_me/about_me.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          VolumeSlider(size: context.dynamicHeight(0.24)),
          QWERHudHeightSlider(),
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
          logoutbtn(context),
        ],
      ),
    );
  }

  Divider divider() => const Divider(color: AppColors.amber, height: 24,);

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

  Widget logoutbtn(BuildContext context) {
    var isLoggedIn = UserManager.instance.isLoggedIn();
    if (!isLoggedIn) return EmptyBox();
    return AppOutlinedButton(
      width: double.infinity,
      onPressed: () async {
        await AppServices.instance.firebaseAuthService.signOut();
        if (context.mounted) Navigator.pop(context);
      }, 
      title: AppStrings.logout
    );
  }
}
