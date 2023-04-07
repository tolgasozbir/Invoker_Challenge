// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/mixins/loading_state_mixin.dart';
import 'package:dota2_invoker_game/providers/boss_provider.dart';
import 'package:dota2_invoker_game/utils/number_formatter.dart';
import 'package:dota2_invoker_game/widgets/watch_ad_button.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../extensions/widget_extension.dart';
import '../../providers/user_manager.dart';
import '../../services/app_services.dart';
import '../app_outlined_button.dart';
import '../app_snackbar.dart';
class BossResultRoundDialogContent extends StatelessWidget {
  final BossRoundResultModel model;

  const BossResultRoundDialogContent({super.key, required this.model});

  int get goldAmount => model.round * 100;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        _resultField("Boss", model.boss.capitalize()),
        _resultField("Elapsed Time", "${model.time} Sec"),
        _resultField("Average DPS", priceString(model.averageDps)),
        _resultField("Max DPS (All Round)", priceString(model.maxDps)),
        _resultField("Physical Damage", priceString(model.physicalDamage)),
        _resultField("Magical Damage", priceString(model.magicalDamage)),
        _resultField("Earned Gold", priceString(model.earnedGold.toDouble())),
        EmptyBox.h4(),
        WatchAdButton(
          afterWatchingAdFn: () => context.read<BossProvider>().addGoldAfterWatchingAd(goldAmount), 
          isAdWatched: context.watch<BossProvider>().isAdWatched, 
          title: goldAmount.toString(),
        ),
        EmptyBox.h4(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.bestScore,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500, 
                fontSize: context.sp(13),
              ),
            ),
            Icon(Icons.swipe_down)
          ],
        ),
        _resultField("Elapsed Time", "${model.time} Sec"),
        _resultField("Average DPS", priceString(model.averageDps)),
        _resultField("Max DPS (All Round)", priceString(model.maxDps)),
        _resultField("Physical Damage", priceString(model.physicalDamage)),
        _resultField("Magical Damage", priceString(model.magicalDamage)),
      ],
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
            style: TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

}

class BossResultRoundDialogAction extends StatefulWidget {
  const BossResultRoundDialogAction({super.key, required this.model});

  final BossRoundResultModel model;

  @override
  State<BossResultRoundDialogAction> createState() => _BossResultRoundDialogActionState();
}

class _BossResultRoundDialogActionState extends State<BossResultRoundDialogAction> with LoadingState {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppOutlinedButton(
          title: AppStrings.send,
          isButtonActive: !isLoading,
          onPressed: () async => await submitScoreFn(),
        ).wrapExpanded(),
        EmptyBox.w8(),
        AppOutlinedButton(
          title: AppStrings.back,
          isButtonActive: !isLoading,
          onPressed: () => Navigator.pop(context),
        ).wrapExpanded(),
      ],
    );
  }
  
  Future<void> submitScoreFn() async {
    final isLoggedIn = UserManager.instance.isLoggedIn();
    final user = UserManager.instance.user;
    final uid = user.uid;
    final db = AppServices.instance.databaseService;

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (!isLoggedIn || uid == null) {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.errorSubmitScore1, 
        snackBartype: SnackBarType.error,
      );
      return;
    }

    if (widget.model.time > UserManager.instance.getBestBossTimeScore(widget.model.boss)) {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.errorSubmitScore2, 
        snackBartype: SnackBarType.error,
      );
      return;
    }

    var hasConnection = await InternetConnectionChecker().hasConnection;
    if (!hasConnection) {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.errorConnection, 
        snackBartype: SnackBarType.error,
      );
      return;
    }

    db.createOrUpdateUser(user); // update db user model

    changeLoadingState();

    bool isOk = false;
    isOk = await db.addBossScore(uid, UserManager.instance.user.bestBossScores!);

    if (isOk) {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.succesSubmitScore, 
        snackBartype: SnackBarType.success
      );
    } else {
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.errorMessage, 
        snackBartype: SnackBarType.error
      );
    }

    changeLoadingState();
    if (isOk) Navigator.pop(context);
  }
}

class BossRoundResultModel {
  final String? uid;
  final String name;
  final int round;
  final String boss;
  final int time;
  final double averageDps;
  final double maxDps;
  final double physicalDamage;
  final double magicalDamage;
  final int earnedGold;
  final List<String> items;

  BossRoundResultModel({
    required this.uid,
    required this.name,
    required this.round,
    required this.boss,
    required this.time,
    required this.averageDps,
    required this.maxDps,
    required this.physicalDamage,
    required this.magicalDamage,
    required this.earnedGold,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'round': round,
      'boss': boss,
      'time': time,
      'averageDps': averageDps,
      'maxDps': maxDps,
      'physicalDamage': physicalDamage,
      'magicalDamage': magicalDamage,
      'earnedGold': earnedGold,
      'items': items,
    };
  }

  factory BossRoundResultModel.fromMap(Map<String, dynamic> map) {
    return BossRoundResultModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      round: map['round'] as int,
      boss: map['boss'] as String,
      time: map['time'] as int,
      averageDps: map['averageDps'] as double,
      maxDps: map['maxDps'] as double,
      physicalDamage: map['physicalDamage'] as double,
      magicalDamage: map['magicalDamage'] as double,
      earnedGold: map['earnedGold'] as int,
      items: List<String>.from((map['items'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory BossRoundResultModel.fromJson(String source) => BossRoundResultModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
