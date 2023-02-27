import 'package:dota2_invoker/constants/app_colors.dart';
import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:dota2_invoker/screens/dashboard/settings/feedback/widgets/rating_faces.dart';
import 'package:dota2_invoker/widgets/app_outlined_button.dart';
import 'package:dota2_invoker/widgets/app_text_from_field.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:splash/splash.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> with SingleTickerProviderStateMixin {
  late final AnimationController _lottieController;
  bool hide = false;

  @override
  void initState() {
    _lottieController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: _bodyView(context),
      ),
    );
  }

  Widget _bodyView(BuildContext context) {
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
              LottieBuilder.asset(LottiePaths.lottieFeedback, width: double.infinity,).wrapExpanded(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Send me your", style: TextStyle(fontSize: context.sp(16), color: Color(0xFF4295F9), fontWeight: FontWeight.bold),),
                        EmptyBox.w4(),
                        Text(AppStrings.feedback+"!", style: TextStyle(fontSize: context.sp(16), color: Color(0xFF29C594), fontWeight: FontWeight.bold),),
                      ],
                    ).wrapPadding(EdgeInsets.only(top: 16)),
                    EmptyBox.h16(),
                    Text(
                      "Tell me how your experience was and let me know what I can improve.", 
                      style: TextStyle(fontSize: context.sp(12), color: Colors.grey.shade400),
                      textAlign: TextAlign.center,
                    ),
                    EmptyBox.h8(),
                    RatingFaces(
                      onSelected: (value) {
                        print(value);
                      },
                    ).wrapExpanded(),
                    AppTextFormField(
                      maxLines: null,
                      isExpand: true,
                      hintText: "Drop me any suggestions, questions or complaints to improve :)",
                      textInputAction: TextInputAction.done,
                    ).wrapExpanded(flex: 3),
                  ],
                )
              ).wrapExpanded(flex: 3),
              Stack(
                children: [
                  AppOutlinedButton(
                    padding: EdgeInsets.only(top: 16),
                    width: context.dynamicWidth(0.9),
                    title: "Send Feedback",
                    isButtonActive: true,
                    onPressed: () async {
                      await _lottieController.animateTo(1);
                      setState(() {
                        hide = !hide;
                      });
                      await _lottieController.animateBack(0, duration: Duration.zero);
                      setState(() {
                        hide = !hide;
                      });
                    },
                  ),
                  Positioned(
                    right: 0,
                    top: 16,
                    bottom: 0,
                    child: Offstage(
                      offstage: hide,
                      child: LottieBuilder.asset(
                        LottiePaths.lottieSending, 
                        height: 48,
                        controller: _lottieController,
                        onLoaded: (composition) => _lottieController.duration = composition.duration,
                      ),
                    ),
                  ),
                ],
              ),
              EmptyBox.h32(),
            ],
          ),
        ),
      ),
    );
  }
}