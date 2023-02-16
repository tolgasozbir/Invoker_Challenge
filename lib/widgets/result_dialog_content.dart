import 'package:dota2_invoker/constants/app_colors.dart';
import 'package:dota2_invoker/services/user_manager.dart';
import 'package:dota2_invoker/widgets/game_ui_widget.dart';

import '../extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

class ResultDialogContent extends StatelessWidget {
  const ResultDialogContent({super.key, required this.correctCount, required this.gameType});

  final int correctCount;
  final GameType gameType;

  @override
  Widget build(BuildContext context) {
   return Column(
    children: [
      //TODO:
      Text(
        '${AppStrings.trueCombinations}\n\n$correctCount',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500, 
          fontSize: context.sp(13)
        ),
      ),
      Divider(thickness: 1, color: AppColors.amber.withOpacity(0.6),),
      Text(
        '${AppStrings.bestScore}\n\n${UserManager.instance.getBestScore(gameType)}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500, 
          fontSize: context.sp(13)
        ),
      ),
    ],
   );
  }
}
