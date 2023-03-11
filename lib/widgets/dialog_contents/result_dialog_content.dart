import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/widget_extension.dart';
import '../../providers/user_manager.dart';
import '../../utils/ads_helper.dart';
import '../game_ui_widget.dart';

class ResultDialogContent extends StatefulWidget {
  const ResultDialogContent({super.key, required this.correctCount, required this.time, required this.gameType});

  final int correctCount;
  final int time;
  final GameType gameType;

  @override
  State<ResultDialogContent> createState() => _ResultDialogContentState();
}

class _ResultDialogContentState extends State<ResultDialogContent> {

  @override
  void initState() {
    Future.microtask(() async => await AdsHelper.instance.rewardedInterstitialAdLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return Column(
    children: [
      EmptyBox.h8(),
      resultField(context, AppStrings.score, widget.correctCount.toString()),
      EmptyBox.h4(),
      resultField(context, AppStrings.time, widget.time.toString()),
      EmptyBox.h4(),
      resultField(context, AppStrings.exp, "+"+UserManager.instance.expCalc(widget.correctCount).toStringAsFixed(0)),
      EmptyBox.h16(),
      Text(
        AppStrings.bestScore,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500, 
          fontSize: context.sp(13),
        ),
      ),
      ElevatedButton(
        onPressed: () async {
          if (AdsHelper.instance.rewardedInterstitialAd == null) return;
          await AdsHelper.instance.rewardedInterstitialAd?.show(onUserEarnedReward: (ad, reward) async {
            await AdsHelper.instance.rewardedInterstitialAdLoad();
          });
        }, 
        child: Text("test ad"),
      ),
      EmptyBox.h4(),
      resultField(context, AppStrings.score, UserManager.instance.getBestScore(widget.gameType).toString())
    ],
   );
  }

  SizedBox resultField(BuildContext context, String title, String value) {
    return SizedBox(
      width: double.infinity,
      child: ColoredBox(
        color: AppColors.resultFieldBg,
        child: Row(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500, 
                fontSize: context.sp(13),
              ),
            ),
            Spacer(),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800, 
                fontSize: context.sp(13),
              ),
            ),
          ],
        ).wrapPadding(EdgeInsets.all(8)),
      ),
    );
  }
}
