import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../enums/local_storage_keys.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../providers/user_manager.dart';
import '../../../services/app_services.dart';
import '../../../services/sound_manager.dart';
import '../../../widgets/app_outlined_button.dart';
import 'about_me/about_me.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.dynamicHeight(0.24);
    return Center(
      child: Column(
        children: [
          volumeSlider(size),
          divider(),
          menuItem(
            context: context,
            leading: FontAwesomeIcons.questionCircle,
            text: AppStrings.aboutMe,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutMeView(),)),
          ),
          divider(),
          menuItem(
            context: context,
            leading: FontAwesomeIcons.commentDots,
            text: AppStrings.feedback,
          ),
          divider(),
          menuItem(
            context: context,
            leading: FontAwesomeIcons.starHalfAlt,
            text: AppStrings.rateApp,
          ),
          divider(),
          logoutbtn(context),
        ],
      ),
    );
  }

  Divider divider() => const Divider(color: AppColors.amber, height: 24,);

  SleekCircularSlider volumeSlider(double size) {
    return SleekCircularSlider(
      min: 0,
      max: 100,
      initialValue: SoundManager.instance.getVolume,
      onChangeEnd: (value) async {
        SoundManager.instance.setVolume(value);
        await AppServices.instance.localStorageService.setIntValue(
          LocalStorageKey.volume, 
          value.ceil().toInt()
        );
      },
      appearance: CircularSliderAppearance(
        size: size,
        animDurationMultiplier: 1.6,
        infoProperties: InfoProperties(
          mainLabelStyle: TextStyle(
            color: const Color.fromRGBO(220, 190, 251, 1),
            fontSize: size / 5.0,
            fontWeight: FontWeight.w300,
          ),
          bottomLabelText: AppStrings.volume,
          bottomLabelStyle: TextStyle(
            color: const Color.fromRGBO(220, 190, 251, 1),
            fontSize: size / 10.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

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
