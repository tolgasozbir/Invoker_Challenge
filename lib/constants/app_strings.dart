import '../models/exit_dialog_message.dart';
import 'locale_keys.g.dart';

class AppStrings {
  const AppStrings._();
  
  static const String appName = 'Invoker Challenge';
  static const String appVersion = '1.8.0';
  static const String appVersionStr = 'Beta $appVersion';
  static const String googlePlayStoreUrl = 'https://play.google.com/store/apps/details?id=com.dota2.invoker.game';
  
  static const List<ExitDialogMessage> exitMessages = [
    ExitDialogMessage(
      title: LocaleKeys.exitGameDialogMessages_title1, 
      body: LocaleKeys.exitGameDialogMessages_body1, 
      word: LocaleKeys.exitGameDialogMessages_word1, 
    ),
    ExitDialogMessage(
      title: LocaleKeys.exitGameDialogMessages_title2, 
      body: LocaleKeys.exitGameDialogMessages_body2, 
      word: LocaleKeys.exitGameDialogMessages_word2, 
    ),
    ExitDialogMessage(
      title: LocaleKeys.exitGameDialogMessages_title3, 
      body: LocaleKeys.exitGameDialogMessages_body3, 
      word: LocaleKeys.exitGameDialogMessages_word3, 
    ),
  ];

}
