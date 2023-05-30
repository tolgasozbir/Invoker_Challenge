import 'package:dota2_invoker_game/extensions/number_extension.dart';
import 'package:dota2_invoker_game/services/database/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../mixins/screen_state_mixin.dart';
import '../../../models/boss_battle_result.dart';
import '../../../services/app_services.dart';
import '../../app_dialogs.dart';
import '../../app_outlined_button.dart';
import '../../app_snackbar.dart';
import '../../empty_box.dart';

class LeaderboardBosses extends StatefulWidget {
  const LeaderboardBosses({super.key, required this.bossName,});

  final String bossName;

  @override
  State<LeaderboardBosses> createState() => _LeaderboardBossesState();
}

class _LeaderboardBossesState extends State<LeaderboardBosses> with ScreenStateMixin {

  List<BossBattleResult>? results;

  @override
  void initState() {
    Future.microtask(() async {
      changeLoadingState();
      results = await AppServices.instance.databaseService.getScores<BossBattleResult>(
        scoreType: ScoreType.Boss, 
        bossName: widget.bossName,
      );
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
            showMoreBtn().wrapPadding(const EdgeInsets.symmetric(horizontal: 8, vertical: 4))
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
        if ((results?.length ?? 0) >= 20) {
          AppSnackBar.showSnackBarMessage(
            text: AppStrings.sbCannotFetchMore, 
            snackBartype: SnackBarType.info,
          );
          return;
        }
        changeLoadingState();
        await Future.delayed(const Duration(seconds: 1));
        final moreResults = await AppServices.instance.databaseService.getScores<BossBattleResult>(
          scoreType: ScoreType.Boss, 
          bossName: widget.bossName,
        );
        results?.addAll(moreResults);
        changeLoadingState();
      },
    );
  }

  ListView resultListView(List<BossBattleResult> results) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 4),
      shrinkWrap: true,
      itemCount:results.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        final data = results[index];
        return GestureDetector(
          onTap: () => showDetailsDialog(data),
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
        );
      },
    );
  }

  void showDetailsDialog(BossBattleResult model) {
    final itemWidgets = model.items.map((e) => Image.asset('${ImagePaths.items}$e.png'.replaceAll(' ', '_'),),).toList();
    AppDialogs.showSlidingDialog(
      dismissible: true,
      title: model.name,
      content: Column(
        children: [
          //TODO: LANG
          _resultField('Elapsed Time', '${model.time} Sec'),
          _resultField('Max DPS',         model.maxDps.numberFormat),
          _resultField('Average DPS',     model.averageDps.numberFormat),
          _resultField('Physical Damage', model.physicalDamage.numberFormat),
          _resultField('Magical Damage',  model.magicalDamage.numberFormat),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.resultFieldBg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Text('Items : ', style: TextStyle(fontWeight: FontWeight.w500),),
                for (var i = 0; i < 6; i++)
                  i < itemWidgets.length ? itemWidgets[i].wrapExpanded() : const EmptyBox().wrapExpanded(),
              ],
            ),
          ),
        ],
      ),
      action: AppOutlinedButton(
        title: AppStrings.back,
        onPressed: (){
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
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
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
