import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_strings.dart';
import '../constants/locale_keys.g.dart';
import '../widgets/app_snackbar.dart';

class UrlLauncher {
  UrlLauncher._();

  static UrlLauncher? _instance;
  static UrlLauncher get instance => _instance ??= UrlLauncher._();

  Future<void> storeRedirect() async {
    try{
      await launchUrl(
        Uri.parse(AppStrings.googlePlayStoreUrl),
        mode: LaunchMode.externalApplication,
      );
    }
    catch(e) {
      AppSnackBar.showSnackBarMessage(
        text: LocaleKeys.snackbarMessages_errorMessage.locale, 
        snackBartype: SnackBarType.error,
      );
    }
  }

}
