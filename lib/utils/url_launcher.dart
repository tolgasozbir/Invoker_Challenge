import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

import '../constants/app_strings.dart';
import '../constants/locale_keys.g.dart';
import '../extensions/string_extension.dart';
import '../widgets/app_snackbar.dart';

class UrlLauncher {
  UrlLauncher._();

  static UrlLauncher? _instance;
  static UrlLauncher get instance => _instance ??= UrlLauncher._();

  /// [writeReview] iOS'ta doğrudan yorum yazma ekranını açar.
  Future<void> storeRedirect({bool writeReview = false}) async {
    try{
      await launchUrl(
        Uri.parse(_storeUrl(writeReview: writeReview)),
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

  String _storeUrl({required bool writeReview}) {
    if (!Platform.isIOS) return AppStrings.playStoreUrl;
    return writeReview
      ? '${AppStrings.appStoreUrl}?action=write-review'
      : AppStrings.appStoreUrl;
  }

}
