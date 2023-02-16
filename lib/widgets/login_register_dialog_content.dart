import 'package:dota2_invoker/constants/app_colors.dart';
import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:dota2_invoker/mixins/loading_state_mixin.dart';
import 'package:dota2_invoker/services/app_services.dart';
import 'package:dota2_invoker/widgets/app_outlined_button.dart';
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import 'app_text_from_field.dart';

class LoginRegisterDialogContent extends StatefulWidget {
  const LoginRegisterDialogContent({Key? key}) : super(key: key);

  @override
  State<LoginRegisterDialogContent> createState() => _LoginRegisterDialogContentState();
}

class _LoginRegisterDialogContentState extends State<LoginRegisterDialogContent> with LoadingState {
  final eMailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  TextStyle get textStyle => TextStyle(fontSize: context.sp(12));
  bool isLoginCheckboxSelected = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          usernameFieldAnimated(),
          AppTextFormField(
            topLabel: AppStrings.eMail,
            hintText: AppStrings.eMailHint,
            controller: eMailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const EmptyBox.h16(),
          AppTextFormField(
            topLabel: AppStrings.password,
            obscureText: true,
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
          ),
          const EmptyBox.h16(),
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
          const EmptyBox.h16(),
          loginOrRegisterBtn(),
          const EmptyBox.h16(),
          //Text("Reset your password!") //TODO:
        ],
      ),
    );
  }

  Widget usernameFieldAnimated() {
    return AnimatedCrossFade(
      firstChild: SizedBox(height: 16, width: double.infinity,),
      secondChild: AppTextFormField(
        topLabel: AppStrings.username,
        hintText: AppStrings.usernameHint,
        controller: usernameController,
        textInputAction: TextInputAction.next,
        maxLength: isLoginCheckboxSelected ? null : 16,
      ), 
      crossFadeState: isLoginCheckboxSelected ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
      duration: Duration(milliseconds: 400),
      sizeCurve: Curves.decelerate,
    );
  }

  List<Widget> checkboxWithTitle({required String title, bool isSelected = false}) {
    return [
      Spacer(),
      Text(title, style: textStyle),
      Checkbox(
        value: isSelected, 
        onChanged: (value) {
          setState(() => isLoginCheckboxSelected = !isLoginCheckboxSelected);
        },
        activeColor: AppColors.white30,
        checkColor: AppColors.amber,
      ).scaleWidget(1.2),
      Spacer(),
    ];
  }

  Widget loginOrRegisterBtn() {
    return AppOutlinedButton(
      width: double.infinity,
      onPressed: isLoading ? null : onTapFn, 
      title: isLoginCheckboxSelected ? AppStrings.login : AppStrings.register,
      textStyle: textStyle,
    ).wrapPadding(EdgeInsets.symmetric(horizontal: 4));
  }

  void onTapFn() async {
    changeLoadingState();
    final auth = AppServices.instance.firebaseAuthService;
    if (isLoginCheckboxSelected) {
      await auth.signIn(
        email: eMailController.text.trim(), 
        password: passwordController.text.trim()
      );
    } 
    else {
      await auth.signUp(
        email: eMailController.text.trim(), 
        password: passwordController.text.trim(), 
        username: usernameController.text.trim(),
      );
    }
    changeLoadingState();
    if (mounted) Navigator.pop(context);
  }
  
}
