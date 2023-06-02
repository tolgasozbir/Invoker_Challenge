import '../../extensions/number_extension.dart';
import '../../models/score_models/combo.dart';
import '../../models/score_models/time_trial.dart';
import '../../services/database/firestore_service.dart';
import '../empty_box.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_image_paths.dart';
import '../../constants/app_strings.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/widget_extension.dart';
import '../../mixins/screen_state_mixin.dart';
import '../../models/base_models/base_score_model.dart';
import '../../models/score_models/boss_battle.dart';
import '../../models/score_models/challenger.dart';
import '../../services/app_services.dart';
import '../app_dialogs.dart';
import '../app_outlined_button.dart';
import '../app_snackbar.dart';

enum LeaderboardType { TimeTrial, Challenger, Combo, Boss }

class LeaderboardDialog extends StatefulWidget {
  const LeaderboardDialog({
    super.key, 
    required this.leaderboardType, 
    this.bossName,
  }) : assert(!(leaderboardType == LeaderboardType.Boss && bossName == null), 'Boss name is required');

  final LeaderboardType leaderboardType;
  final String? bossName;

  @override
  State<LeaderboardDialog> createState() => _LeaderboardDialogState();
}

class _LeaderboardDialogState extends State<LeaderboardDialog> with ScreenStateMixin {

  List<IScoreModel>? results;

  Future<void> init() async {
    switch (widget.leaderboardType) {
      case LeaderboardType.TimeTrial:
        results = await AppServices.instance.databaseService.getScores<TimeTrial>(scoreType: ScoreType.TimeTrial);
        break;
      case LeaderboardType.Challenger:
        results = await AppServices.instance.databaseService.getScores<Challenger>(scoreType: ScoreType.Challenger);
        break;
      case LeaderboardType.Combo:
        results = await AppServices.instance.databaseService.getScores<Combo>(scoreType: ScoreType.Combo);
        break;
      case LeaderboardType.Boss:
        results = await AppServices.instance.databaseService.getScores<BossBattle>(
          scoreType: ScoreType.Boss, 
          bossName: widget.bossName,
        );
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
          challengerTitles(),
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

  Widget challengerTitles() {
    if (widget.leaderboardType != LeaderboardType.Challenger) return const EmptyBox();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(flex: 5, child: Text(AppStrings.username)),
        Expanded(flex: 2, child: Center(child: Text(AppStrings.time))),
        Expanded(flex: 2, child: Center(child: Text('${AppStrings.score}    '))),
      ],
    ).wrapPadding(const EdgeInsets.all(8.0));
  }

  AppOutlinedButton showMoreBtn() {
    return AppOutlinedButton(
      width: double.infinity,
      title: AppStrings.showMore,
      isButtonActive: !isLoading,
      onPressed: showMoreFn,
    );
  }

  void showMoreFn() async {
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
      case LeaderboardType.Challenger:
        results?.addAll(await AppServices.instance.databaseService.getScores<Challenger>(scoreType: ScoreType.Challenger));
        break;
      case LeaderboardType.Combo:
        results?.addAll(await AppServices.instance.databaseService.getScores<Combo>(scoreType: ScoreType.Combo));
        break;
      case LeaderboardType.Boss:
        results?.addAll(await AppServices.instance.databaseService.getScores<BossBattle>(
          scoreType: ScoreType.Boss, 
          bossName: widget.bossName,
        ),);
        break;
    }
    changeLoadingState();
  }

  ListView resultListView(List<IScoreModel> results) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        final data = results[index];
        return Card(
          color: AppColors.dialogBgColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.leaderboardType == LeaderboardType.Challenger 
              ? buildChallengerScoreWidget(index, data)
              : widget.leaderboardType == LeaderboardType.Boss 
                ? buildBossScoreWidget(index, data)
                : buildScoreWidget(index, data),
          ),
        );
      },
    );
  }

  List<Widget> buildScoreWidget(int index, IScoreModel data) {
    return [
      Text(
        '  ${index+1}.  ${data.name}',
        style: TextStyle(color: AppColors.white, fontSize: context.sp(13)),
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.fade,
      ),
      Text(
        '${data.score}  ',
        style: TextStyle(color: AppColors.white, fontSize: context.sp(13)),
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.fade,
      ),
    ];
  }

  List<Widget> buildChallengerScoreWidget(int index, IScoreModel data) {
    return [
      Expanded(
        flex: 5,
        child: Text(
          '  ${index + 1}.  ${data.name}',
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
    ];
  }


  //Boss Leaderboard

  List<Widget> buildBossScoreWidget(int index, IScoreModel data) {
    return [
      GestureDetector(
        onTap: () => _showDetailsDialog(data as BossBattle),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: AppColors.dialogBgColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '  ${index+1}.  ${data.name}',
                style: TextStyle(color: AppColors.white, fontSize: context.sp(13)),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
              const Icon(Icons.arrow_drop_down_circle_outlined)
            ],
          ).wrapPadding(const EdgeInsets.all(8)),
        ),
      ).wrapExpanded()
    ];
  }

  void _showDetailsDialog(BossBattle model) {
    final itemWidgets = model.items.map((e) => Image.asset('${ImagePaths.items}$e.png'.replaceAll(' ', '_'),),).toList();
    AppDialogs.showSlidingDialog(
      dismissible: true,
      title: model.name,
      content: Column(
        children: [
          _resultField(AppStrings.elapsedTime, '${model.time} ${AppStrings.second}'),
          _resultField(AppStrings.maxDps,      model.maxDps.numberFormat),
          _resultField(AppStrings.AverageDps,  model.averageDps.numberFormat),
          _resultField(AppStrings.physicalDmg, model.physicalDamage.numberFormat),
          _resultField(AppStrings.magicalDmg,  model.magicalDamage.numberFormat),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.resultFieldBg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Text('${AppStrings.items} : ', style: TextStyle(fontWeight: FontWeight.w500),),
                for (var i = 0; i < 6; i++)
                  i < itemWidgets.length ? itemWidgets[i].wrapExpanded() : const EmptyBox().wrapExpanded(),
              ],
            ),
          ),
        ],
      ),
      action: AppOutlinedButton(
        title: AppStrings.back,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _resultField(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.resultFieldBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

}
