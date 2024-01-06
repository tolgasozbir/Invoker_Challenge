import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dota2_invoker_game/constants/app_colors.dart';
import 'package:dota2_invoker_game/constants/app_strings.dart';
import 'package:dota2_invoker_game/constants/locale_keys.g.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/services/sound_manager.dart';
import 'package:dota2_invoker_game/widgets/empty_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_image_paths.dart';
import '../../utils/url_launcher.dart';

class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({super.key, required this.forceUpdate});

  final bool forceUpdate;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SimpleDialog(
        contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
        children: [
          SizedBox(
            width: context.dynamicWidth(0.6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  logoAndTitle(context),
                  const EmptyBox.h8(),
                  Text(LocaleKeys.appUpdateDialog_message.locale),
                  const EmptyBox.h16(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      laterBtn(context),
                      const EmptyBox.w8(),
                      updateBtn(),
                    ],
                  ),
                  const Divider(thickness: 2),
                  Image.asset(
                    ImagePaths.gPlayLogo,
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row logoAndTitle(BuildContext context) {
    return Row(
      children: [
        Card(
          color: Colors.white,
          child: Image.asset(
            ImagePaths.appLogo, 
            fit: BoxFit.cover,
            width: context.dynamicWidth(0.08),
          ),
        ),
        const EmptyBox.w8(),
        const Expanded(
          child: AutoSizeText(
            AppStrings.appName,
            maxLines: 1,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  TextButton laterBtn(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFF378262),
      ),
      onPressed: forceUpdate 
        ? () => SoundManager.instance.playMeepMerp()
        : () => Navigator.pop(context), 
      child: AutoSizeText(
        LocaleKeys.appUpdateDialog_later.locale,
        maxLines: 1,
        style: TextStyle(
          color: forceUpdate ? AppColors.grey : null,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ElevatedButton updateBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF378262),
      ),
      onPressed: () async {
        closeApp();
        await UrlLauncher.instance.storeRedirect();
      },
      child: Text(
        LocaleKeys.appUpdateDialog_update.locale,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  void closeApp() {
    if (Platform.isIOS) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else if (Platform.isAndroid) {
      SystemNavigator.pop();
    }
  }
}
