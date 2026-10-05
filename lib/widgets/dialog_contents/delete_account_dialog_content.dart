import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/locale_keys.g.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/string_extension.dart';
import '../../mixins/input_validation_mixin.dart';
import '../../mixins/screen_state_mixin.dart';
import '../../providers/boss_battle_provider.dart';
import '../../services/achievement_manager.dart';
import '../../services/iap/revenuecat_service.dart';
import '../../services/user_manager.dart';
import '../app_outlined_button.dart';
import '../app_snackbar.dart';
import '../app_text_from_field.dart';
import '../empty_box.dart';

class DeleteAccountDialogContent extends StatefulWidget {
  const DeleteAccountDialogContent({super.key});

  // Abonelik notu görünürken içerik daha uzun.
  static double get dialogHeight => RevenueCatService.instance.isConfigured ? 430 : 340;

  @override
  State<DeleteAccountDialogContent> createState() => _DeleteAccountDialogContentState();
}

class _DeleteAccountDialogContentState extends State<DeleteAccountDialogContent> with ScreenStateMixin, InputValidationMixin {

  final passwordController = TextEditingController();
  bool showPassword = true;

  TextStyle get textStyle => TextStyle(fontSize: context.sp(12));

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Silme sürerken geri tuşuyla kapanmaz.
    return PopScope(
      canPop: !isLoading,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LocaleKeys.deleteAccount_warning.locale, style: textStyle),
            if (RevenueCatService.instance.isConfigured) ...[
              const EmptyBox.h12(),
              Text(
                LocaleKeys.deleteAccount_subscriptionNote.locale,
                style: textStyle.copyWith(color: AppColors.amber),
              ),
            ],
            const EmptyBox.h16(),
            AppTextFormField(
              topLabel: LocaleKeys.formDialog_password.locale,
              obscureText: showPassword,
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              validator: isValidPassword,
              suffixIcon: IconButton(
                onPressed: () {
                  showPassword = !showPassword;
                  updateScreen();
                },
                icon: Icon(showPassword ? CupertinoIcons.eye : CupertinoIcons.eye_slash),
              ),
            ),
            const EmptyBox.h16(),
            AppOutlinedButton(
              width: double.infinity,
              onPressed: onTapDelete,
              isButtonActive: !isLoading,
              bgColor: AppColors.red,
              title: LocaleKeys.deleteAccount_confirm.locale,
              textStyle: textStyle,
            ),
          ],
        ),
      ),
    );
  }

  void onTapDelete() async {
    FocusScope.of(context).unfocus();
    isValidate = formKey.currentState!.validate();
    updateScreen();
    if (!isValidate) return;

    final bool hasConnection = await InternetConnectionChecker().hasConnection;
    if (!hasConnection) {
      AppSnackBar.showSnackBarMessage(
        text: LocaleKeys.snackbarMessages_errorConnection.locale,
        snackBartype: SnackBarType.info,
      );
      return;
    }

    changeLoadingState();
    final isDeleted = await UserManager.instance.deleteAccount(password: passwordController.text.trim());
    changeLoadingState();
    if (!isDeleted || !mounted) return;

    context.read<BossBattleProvider>().disposeGame(); //Reset Boss Mode Values
    AchievementManager.instance.updateAchievements(); //Reset achievements
    AppSnackBar.showSnackBarMessage(
      text: LocaleKeys.deleteAccount_success.locale,
      snackBartype: SnackBarType.success,
    );
    Navigator.pop(context);
  }

}
