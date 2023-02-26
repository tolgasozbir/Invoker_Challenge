import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../extensions/context_extension.dart';
import '../../providers/user_manager.dart';
import '../game_ui_widget.dart';

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
