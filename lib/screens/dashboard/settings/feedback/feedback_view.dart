import '../../../../constants/app_colors.dart';
import '../../../../constants/app_strings.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../extensions/widget_extension.dart';
import '../../../../mixins/loading_state_mixin.dart';
import '../../../../models/feedback_model.dart';
import '../../../../providers/user_manager.dart';
import 'widgets/rating_faces.dart';
import '../../../../services/app_services.dart';
import '../../../../utils/formatted_date.dart';
import '../../../../widgets/app_outlined_button.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../../../widgets/app_text_from_field.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:splash/splash.dart';
import '../../../../widgets/app_scaffold.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> with SingleTickerProviderStateMixin, LoadingState {
  late final AnimationController _lottieController;
  final _feedbackController = TextEditingController();
  int _ratingValue = 5;

  @override
  void initState() {
    _lottieController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppScaffold(body: _bodyView()),
    );
  }

  Widget _bodyView() {
    return InkWell(
      splashFactory: WaveSplash.splashFactory,
      //splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          height: context.height,
          width: context.width,
          child: Column(
            children: [
              EmptyBox.h8(),
              LottieBuilder.asset(LottiePaths.lottieFeedback, width: double.infinity,).wrapExpanded(flex: 4),
              EmptyBox.h8(),
              Container(
                width: context.dynamicWidth(0.9),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all()
                ),
                child: Column(
                  children: [
                    EmptyBox.h16(),
                    titleText(),
                    EmptyBox.h16(),
                    middleText(),
                    EmptyBox.h8(),
                    RatingFaces(onSelected: (value) => _ratingValue = value).wrapExpanded(),
                    feedbackTextField().wrapExpanded(flex: 3),
                  ],
                ),
              ).wrapExpanded(flex: 10),
              sendButton(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Row titleText() {
    var textStyle = TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.bold);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppStrings.fbTitleFirst, style: textStyle.copyWith(color: Color(0xFF4295F9)),),
        EmptyBox.w4(),
        Text(AppStrings.fbTitleSecond, style: textStyle.copyWith(color: Color(0xFF29C594))),
      ],
    );
  }

  Text middleText() {
    return Text(
      AppStrings.fbMidText, 
      style: TextStyle(fontSize: context.sp(12), color: Colors.grey.shade400),
      textAlign: TextAlign.center,
    );
  }

  AppTextFormField feedbackTextField() {
    return AppTextFormField(
      maxLines: null,
      isExpand: true,
      controller: _feedbackController,
      hintText: AppStrings.fbHint,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
    );
  }

  Stack sendButton() {
    return Stack(
      children: [
        AppOutlinedButton(
          title: AppStrings.fbSendBtn,
          width: context.dynamicWidth(0.9),
          bgColor: AppColors.fbSendBtn,
          padding: EdgeInsets.only(top: 16),
          isButtonActive: !isLoading,
          onPressed: sendBtnFn,
        ),
        Positioned(
          right: 0,
          top: 16,
          bottom: 0,
          child: LottieBuilder.asset(
            LottiePaths.lottieSending, 
            height: 48,
            width: 48,
            controller: _lottieController,
            onLoaded: (composition) => _lottieController.duration = composition.duration,
          ),
        ),
      ],
    );
  }

  void sendBtnFn() async {
    if (_feedbackController.text.length < 10) {
      AppSnackBar.showSnackBarMessage(text: AppStrings.feedbackInfoMessage, snackBartype: SnackBarType.info);
      return;
    }

    var hasConnection = await InternetConnectionChecker().hasConnection;
    if (!hasConnection) {
      AppSnackBar.showSnackBarMessage(text: AppStrings.errorConnection, snackBartype: SnackBarType.info);
      return;
    }

    changeLoadingState();
    var feedback = FeedbackModel(
      senderId: UserManager.instance.user.uid,
      sender: UserManager.instance.user.username, 
      ratePoint: _ratingValue, 
      message: _feedbackController.text,
      createdAt: getFormattedDate
    );

    var success = await AppServices.instance.databaseService.sendFeedback(feedback);
    final duration = const Duration(milliseconds: 3000);
    if (success) {
      await _lottieController.animateTo(1);
      _feedbackController.clear();
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.feedbackSuccessMessage, 
        snackBartype: SnackBarType.success,
        duration: duration
      );
    }else {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.errorMessage + " " +  AppStrings.errorConnection, 
        snackBartype: SnackBarType.error,
        duration: duration,
      );
    }

    changeLoadingState();
      await _lottieController.animateBack(0, duration: Duration.zero);
  }

}
