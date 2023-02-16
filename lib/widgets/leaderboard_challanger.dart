import '../mixins/loading_state_mixin.dart';
import 'app_outlined_button.dart';

import '../extensions/context_extension.dart';
import '../extensions/widget_extension.dart';
import '../constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../models/challenger_result.dart';
import '../services/app_services.dart';

class LeaderboardChallanger extends StatefulWidget {
  const LeaderboardChallanger({super.key,});

  @override
  State<LeaderboardChallanger> createState() => _LeaderboardChallangerState();
}

class _LeaderboardChallangerState extends State<LeaderboardChallanger> with LoadingState {

  List<ChallengerResult> results = [];

  @override
  void initState() {
    Future.microtask(() async {
      changeLoadingState();
      results = await AppServices.instance.databaseService.getChallangerScores();
      changeLoadingState();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    AppServices.instance.databaseService.dispose();
    super.didChangeDependencies();
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

  AppOutlinedButton showMoreBtn() {
    return AppOutlinedButton(
      width: double.infinity,
      title: AppStrings.showMore,
      onPressed: isLoading ? null : () async {
        changeLoadingState();
        await Future.delayed(const Duration(seconds: 1));
        results.addAll(await AppServices.instance.databaseService.getChallangerScores());
        changeLoadingState();
      },
    );
  }

  ListView resultListView(List<ChallengerResult> results) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount:results.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        final data = results[index];
        return Card(
          color: AppColors.dialogBgColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  '  ${index+1}.  ${data.name}',
                  style: TextStyle(color: AppColors.white, fontSize: context.sp(13)),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              ),
              Expanded(
                flex: 2, 
                child: Center(
                  child: Text(
                    data.time.toString(),
                    style: TextStyle(color: AppColors.amber, fontSize: context.sp(13)),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              Expanded(
                flex: 2, 
                child: Center(
                  child: Text(
                    '${data.score}    ',
                    style: TextStyle(color: AppColors.fullGreen, fontSize: context.sp(13)),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
