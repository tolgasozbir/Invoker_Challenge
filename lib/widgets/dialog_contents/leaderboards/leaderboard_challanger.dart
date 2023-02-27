import '../../../mixins/loading_state_mixin.dart';
import '../../app_outlined_button.dart';

import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_strings.dart';
import '../../../models/challenger_result.dart';
import '../../../services/app_services.dart';
import 'package:lottie/lottie.dart';

class LeaderboardChallanger extends StatefulWidget {
  const LeaderboardChallanger({super.key,});

  @override
  State<LeaderboardChallanger> createState() => _LeaderboardChallangerState();
}

class _LeaderboardChallangerState extends State<LeaderboardChallanger> with LoadingState {

  List<ChallengerResult>? results = null;

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
    return Card(
      color: AppColors.resultsCardBg, 
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(flex: 5, child: Text(AppStrings.username)),
                Expanded(flex: 2, child: Center(child: Text(AppStrings.time))),
                Expanded(flex: 2, child: Center(child: Text('${AppStrings.score}    '))),
              ],
            ),
          ),
          results == null
            ? const CircularProgressIndicator.adaptive().wrapCenter()
            : results!.isEmpty
              ? Lottie.asset(LottiePaths.lottieNoData, height: context.dynamicHeight(0.32))
              : resultListView(results!),
          if (results!= null && results!.isNotEmpty)
            showMoreBtn().wrapPadding(const EdgeInsets.all(8))
        ],
      ),
    );
  }

  AppOutlinedButton showMoreBtn() {
    return AppOutlinedButton(
      width: double.infinity,
      title: AppStrings.showMore,
      isButtonActive: !isLoading,
      onPressed: () async {
        changeLoadingState();
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        await Future.delayed(const Duration(seconds: 1));
        results?.addAll((await AppServices.instance.databaseService.getChallangerScores()));
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
