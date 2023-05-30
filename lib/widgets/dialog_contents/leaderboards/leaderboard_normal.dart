import 'package:dota2_invoker_game/models/base_model.dart';
import 'package:dota2_invoker_game/models/combo.dart';
import 'package:dota2_invoker_game/models/time_trial.dart';
import 'package:dota2_invoker_game/services/database/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../mixins/screen_state_mixin.dart';
import '../../../services/app_services.dart';
import '../../app_outlined_button.dart';
import '../../app_snackbar.dart';

enum LeaderboardType { TimeTrial, Combo }

class LeaderboardNormal extends StatefulWidget {
  const LeaderboardNormal({super.key, required this.leaderboardType,});

  final LeaderboardType leaderboardType;

  @override
  State<LeaderboardNormal> createState() => _LeaderboardNormalState();
}

class _LeaderboardNormalState extends State<LeaderboardNormal> with ScreenStateMixin {

  List<ICommonProperties>? results;

  Future<void> init() async {
    switch (widget.leaderboardType) {
      case LeaderboardType.TimeTrial:
        results = await AppServices.instance.databaseService.getScores<TimeTrial>(scoreType: ScoreType.TimeTrial);
        break;
      case LeaderboardType.Combo:
        results = await AppServices.instance.databaseService.getScores<Combo>(scoreType: ScoreType.Combo);
        break;
    }
  }

  @override
  void initState() {
    Future.microtask(() async {
      changeLoadingState();
      await init();
      changeLoadingState();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    AppServices.instance.databaseService.resetPagination();
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
        switch (widget.leaderboardType) {
          case LeaderboardType.TimeTrial:
            results?.addAll(await AppServices.instance.databaseService.getScores<TimeTrial>(scoreType: ScoreType.TimeTrial));
            break;
          case LeaderboardType.Combo:
            results?.addAll(await AppServices.instance.databaseService.getScores<Combo>(scoreType: ScoreType.Combo));
            break;
        }
        changeLoadingState();
      },
    );
  }

  ListView resultListView(List<ICommonProperties> results) {
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
