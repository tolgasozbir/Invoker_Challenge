import '../services/user_manager.dart';

import '../extensions/context_extension.dart';
import '../mixins/screen_state_mixin.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../constants/app_strings.dart';
import 'app_dialogs.dart';
import 'app_outlined_button.dart';
import 'app_snackbar.dart';
import 'app_text_from_field.dart';
import 'empty_box.dart';

class ResetPwButton extends StatefulWidget {
  const ResetPwButton({super.key});

  @override
  State<ResetPwButton> createState() => _ResetPwButtonState();
}

class _ResetPwButtonState extends State<ResetPwButton> with ScreenStateMixin {

  final eMailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTapBtn, 
      child: const Text(AppStrings.resetPw),
    );
  }

  void onTapBtn() {
    FocusScope.of(context).unfocus();
    openResetDialog();
  }

  void openResetDialog() {
    AppDialogs.showSlidingDialog(
      dismissible: true,
      showBackButton: true,
      height: 224,
      title: AppStrings.resetPw,
      content: Column(
        children: [
          AppTextFormField(
            topLabel: AppStrings.eMail,
            hintText: AppStrings.eMailHint,
            controller: eMailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const EmptyBox.h24(),
          AppOutlinedButton(
            width: double.infinity,
            onPressed: resetBtnFn, 
            isButtonActive: !isLoading,
            title: AppStrings.reset,
            textStyle: TextStyle(fontSize: context.sp(12)),
          ),
        ],
      ),
    );
  }

  void resetBtnFn() async {
    if (isLoading) return;
    changeLoadingState();
    FocusScope.of(context).requestFocus(FocusNode());
    final bool hasConnection = await InternetConnectionChecker().hasConnection;
    if (!hasConnection) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      AppSnackBar.showSnackBarMessage(text: AppStrings.errorConnection, snackBartype: SnackBarType.info);
      return;
    }
    final isOk = await UserManager.instance.resetPassword(email: eMailController.text);
    if (isOk) {
      AppSnackBar.showSnackBarMessage(text: AppStrings.sbResetPw, snackBartype: SnackBarType.success);
      Navigator.pop(context);
    }
    changeLoadingState();
  }
}
