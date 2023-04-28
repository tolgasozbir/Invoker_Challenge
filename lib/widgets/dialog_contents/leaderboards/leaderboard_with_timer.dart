import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../mixins/loading_state_mixin.dart';
import '../../../models/timer_result.dart';
import '../../../services/app_services.dart';
import '../../app_outlined_button.dart';
import '../../app_snackbar.dart';

class LeaderboardWithTimer extends StatefulWidget {
  const LeaderboardWithTimer({super.key,});

  @override
  State<LeaderboardWithTimer> createState() => _LeaderboardWithTimerState();
}

class _LeaderboardWithTimerState extends State<LeaderboardWithTimer> with LoadingState {

  List<TimerResult>? results;

  @override
  void initState() {
    Future.microtask(() async {
      changeLoadingState();
      results = await AppServices.instance.databaseService.getTimerScores();
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
          if (results == null) const CircularProgressIndicator.adaptive().wrapCenter() 
          else results!.isEmpty 
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
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        if ((results?.length ?? 0) >= 100) {
          AppSnackBar.showSnackBarMessage(
            text: AppStrings.sbCannotFetchMore, 
            snackBartype: SnackBarType.info,
          );
          return;
        }
        changeLoadingState();
        await Future.delayed(const Duration(seconds: 1));
        results?.addAll(await AppServices.instance.databaseService.getTimerScores());
        changeLoadingState();
      },
    );
  }

  ListView resultListView(List<TimerResult> results) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        final textStyle = TextStyle(color: AppColors.white, fontSize: context.sp(13));
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
