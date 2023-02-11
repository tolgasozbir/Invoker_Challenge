import '../extensions/context_extension.dart';
import '../extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/timer_result.dart';
import '../services/app_services.dart';

class LeaderboardWithTimer extends StatefulWidget {
  const LeaderboardWithTimer({super.key,});

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
      results = await AppServices.instance.databaseService.getTimerScores();
      changeLoading();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    AppServices.instance.databaseService.dispose();
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
        results.isEmpty ? const CircularProgressIndicator.adaptive().wrapCenter() : resultListView(results),
        if (results.isNotEmpty)
          showMoreBtn().wrapPadding(const EdgeInsets.all(8))
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
          await Future.delayed(const Duration(seconds: 1));
          results.addAll(await AppServices.instance.databaseService.getTimerScores());
          changeLoading();
        },
        child: Text(AppStrings.showMore, style: TextStyle(fontSize: context.sp(12)),),
      ),
    );
  }

  ListView resultListView(List<TimerResult> results) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        final textStyle = TextStyle(color: Color(0xFFEEEEEE), fontSize: context.sp(13));
        final data = results[index];
        return Card(
          color: AppColors.dialogBgColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '  ${index+1}.  ${data.name}',
                style: textStyle,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
              Text(
                '${data.score}  ',
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
