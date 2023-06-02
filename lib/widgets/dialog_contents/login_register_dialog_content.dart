import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_image_paths.dart';
import '../../constants/app_strings.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/widget_extension.dart';
import '../../mixins/input_validation_mixin.dart';
import '../../mixins/screen_state_mixin.dart';
import '../../services/achievement_manager.dart';
import '../../services/app_services.dart';
import '../app_outlined_button.dart';
import '../app_snackbar.dart';
import '../app_text_from_field.dart';
import '../empty_box.dart';
import '../reset_pw_button.dart';

class LoginRegisterDialogContent extends StatefulWidget {
  const LoginRegisterDialogContent({super.key});

  @override
  State<LoginRegisterDialogContent> createState() => _LoginRegisterDialogContentState();
}

class _LoginRegisterDialogContentState extends State<LoginRegisterDialogContent> with ScreenStateMixin, InputValidationMixin {
  final eMailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  TextStyle get textStyle => TextStyle(fontSize: context.sp(12));
  bool isLoginCheckboxSelected = true;
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          usernameFieldAnimated(),
          AppTextFormField(
            topLabel: AppStrings.eMail,
            hintText: AppStrings.eMailHint,
            controller: eMailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: isValidEmail,
          ),
          const EmptyBox.h16(),
          AppTextFormField(
            topLabel: AppStrings.password,
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
          const EmptyBox.h12(),
          Row(
            children: [
              ...checkboxWithTitle(
                title: AppStrings.login, 
                isSelected: isLoginCheckboxSelected,
              ),
              Text(AppStrings.or, style: textStyle,),
              ...checkboxWithTitle(
                title: AppStrings.register, 
                isSelected: !isLoginCheckboxSelected,
              ),
            ],
          ),
          const EmptyBox.h12(),
          showHideOrbs(),
          loginOrRegisterBtn(),
          //const EmptyBox.h12(),
          const ResetPwButton(),
        ],
      ),
    );
  }

  Widget usernameFieldAnimated() {
    return AnimatedCrossFade(
      firstChild: const SizedBox(height: 16, width: double.infinity,),
      secondChild: AppTextFormField(
        topLabel: AppStrings.username,
        hintText: AppStrings.usernameHint,
        controller: usernameController,
        textInputAction: TextInputAction.next,
        maxLength: isLoginCheckboxSelected ? null : 16,
        validator: isLoginCheckboxSelected ? null : isValid,
      ).wrapPadding(const EdgeInsets.only(top: 16)),
      crossFadeState: isLoginCheckboxSelected ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
      duration: const Duration(milliseconds: 400),
      sizeCurve: Curves.decelerate,
    );
  }

  Widget showHideOrbs() {
    return AnimatedCrossFade(
      firstChild: const EmptyBox(),
      secondChild: invokerOrbs,
      crossFadeState: !isLoginCheckboxSelected ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
      duration: const Duration(milliseconds: 400),
      sizeCurve: Curves.decelerate,
    );
  }

  Widget get invokerOrbs => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        ImagePaths.svgQuas,
        color: AppColors.quasColor.withOpacity(0.72),
        width: 48,
      ),
      SvgPicture.asset(
        ImagePaths.svgWex,
        color: AppColors.wexColor.withOpacity(0.72),
        width: 48,
      ),
      SvgPicture.asset(
        ImagePaths.svgExort,
        color: AppColors.exortColor.withOpacity(0.72),
        width: 48,
      ),
    ],
  ).wrapPadding(const EdgeInsets.only(bottom: 32, top: 8));

  List<Widget> checkboxWithTitle({required String title, bool isSelected = false}) {
    return [
      const Spacer(),
      Text(title, style: textStyle),
      Checkbox(
        value: isSelected, 
        onChanged: (value) {
          isLoginCheckboxSelected = !isLoginCheckboxSelected;
          updateScreen();
        },
        activeColor: AppColors.white30,
        checkColor: AppColors.amber,
      ).scaleWidget(1.2),
      const Spacer(),
    ];
  }

  Widget loginOrRegisterBtn() {
    return AppOutlinedButton(
      width: double.infinity,
      onPressed: onTapFn, 
      isButtonActive: !isLoading,
      title: isLoginCheckboxSelected ? AppStrings.login : AppStrings.register,
      textStyle: textStyle,
    ).wrapPadding(const EdgeInsets.symmetric(horizontal: 4));
  }

  void onTapFn() async {
    FocusScope.of(context).unfocus();
    isValidate = formKey.currentState!.validate();
    updateScreen();
    if (!isValidate) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      AppSnackBar.showSnackBarMessage(text: AppStrings.fillFields, snackBartype: SnackBarType.info);
      return;
    }

    final bool hasConnection = await InternetConnectionChecker().hasConnection;
    if (!hasConnection) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      AppSnackBar.showSnackBarMessage(text: AppStrings.errorConnection, snackBartype: SnackBarType.info);
      return;
    }
    
    changeLoadingState();
    final auth = AppServices.instance.firebaseAuthService;
    var isOk = false;
    if (isLoginCheckboxSelected) {
      isOk = await auth.signIn(
        email: eMailController.text.trim(), 
        password: passwordController.text.trim(),
      );
    } 
    else {
      isOk = await auth.signUp(
        email: eMailController.text.trim(), 
        password: passwordController.text.trim(), 
        username: usernameController.text.trim(),
      );
    }
    //AchievementManager.instance.reset(); //reset achievements //TODO:
    changeLoadingState();
    if (mounted && isOk) Navigator.pop(context);
  }
  
}
