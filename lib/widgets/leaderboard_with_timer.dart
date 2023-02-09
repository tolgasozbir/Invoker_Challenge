import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/timer_result.dart';
import '../providers/game_provider.dart';

class LeaderboardWithTimer extends StatefulWidget {
  LeaderboardWithTimer({Key? key,}) : super(key: key);

  @override
  State<LeaderboardWithTimer> createState() => _LeaderboardWithTimerState();
}

class _LeaderboardWithTimerState extends State<LeaderboardWithTimer> {

  List<TimerResult> results = [];
  bool isLoading = false;

  @override
  void initState() {
    Future.microtask(() async {
      changeLoading();
      results = await context.read<GameProvider>().databaseService.getTimerScores();
      changeLoading();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.read<GameProvider>().databaseService.dispose();
    super.didChangeDependencies();
  }

  void changeLoading() {
    if (!mounted) return;
    setState(() { 
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        results.isEmpty ? CircularProgressIndicator.adaptive().wrapCenter() : resultListView(results),
        if (results.isNotEmpty)
          showMoreBtn().wrapPadding(EdgeInsets.all(8))
      ],
    );
  }

  SizedBox showMoreBtn() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : () async {
          changeLoading();
          await Future.delayed(Duration(seconds: 1));
          results.addAll(await context.read<GameProvider>().databaseService.getTimerScores());
          changeLoading();
        },
        child: Text(AppStrings.showMore, style: TextStyle(fontSize: 16),)
      ),
    );
  }

  ListView resultListView(List<TimerResult> results) {
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