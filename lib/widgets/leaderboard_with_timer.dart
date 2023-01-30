import '../constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../constants/app_strings.dart';
import '../models/timer_result.dart';
import '../providers/game_provider.dart';

class LeaderboardWithTimer extends StatelessWidget {
  LeaderboardWithTimer({Key? key,}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<GameProvider>().databaseService.getAllTimerScores(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<TimerResult> results = [];
        if (snapshot.connectionState == ConnectionState.waiting) 
          return Center(child: CircularProgressIndicator.adaptive());
        if (!snapshot.hasData)
          return errorLottie();
        results = snapshot.data;
        return results.isNotEmpty 
          ? resultBuilder(results)
          : LottieBuilder.asset(LottiePaths.lottieProudFirst);
      },
    );
  }

  Column errorLottie() {
    return Column(
      children: [
        LottieBuilder.asset(LottiePaths.lottie404),
        Text(AppStrings.errorMessage)
      ],
    );
  }

  ListView resultBuilder(List<TimerResult> results) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        var textStyle = TextStyle(color: Color(0xFFEEEEEE), fontSize: 18);
        var data = results[index];
        return Card(
          color: AppColors.dialogBgColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "  ${index+1}.  " + data.name,
                style: textStyle,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
              Text(
                data.score.toString()+"  ",
                style: textStyle,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        );
      },
    );
  }
}