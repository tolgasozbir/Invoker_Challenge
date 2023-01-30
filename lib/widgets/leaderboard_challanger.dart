import '../constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../constants/app_strings.dart';
import '../models/challenger_result.dart';
import '../providers/game_provider.dart';

class LeaderboardChallanger extends StatelessWidget {
  LeaderboardChallanger({Key? key,}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<GameProvider>().databaseService.getAllChallangerScores(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<ChallengerResult> results = [];
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

  ListView resultBuilder(List<ChallengerResult> results) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount:results.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        var data = results[index];
        return Card(
          color: AppColors.dialogBgColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  "  ${index+1}.  " + data.name,
                  style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 18),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                )
              ),
              Expanded(
                flex: 2, 
                child: Center(
                  child: Text(
                    data.time.toString(),
                    style: TextStyle(color: Color(0xFFFFCC00), fontSize: 18),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  )
                )
              ),
              Expanded(
                flex: 2, 
                child: Center(
                  child: Text(
                    data.score.toString()+"    ",
                    style: TextStyle(color: Color(0xFF00FF00), fontSize: 18),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  )
                )
              ),
            ],
          ),
        );
      },
    ); 
  }
}