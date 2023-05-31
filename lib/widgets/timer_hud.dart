import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_image_paths.dart';
import '../extensions/context_extension.dart';
import '../extensions/widget_extension.dart';
import '../providers/game_provider.dart';
import 'game_ui_widget.dart';

class TimerHud extends StatelessWidget {
  const TimerHud({super.key, required this.gameType});

  final GameType gameType;

  String getTimerValue(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    switch (gameType) {
      case GameType.Training:
      case GameType.Challanger:
        return gameProvider.getTimerValue.toString().padLeft(2, '0');
      case GameType.Combo:
      case GameType.Timer:
        return gameProvider.getCountdownValue.toString().padLeft(2, '0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: AppColors.transparent,
      elevation: 16, //24
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(50)),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(ImagePaths.todClock, height: context.dynamicHeight(0.08)), //0.1
          Text(
            getTimerValue(context),
            style: TextStyle(
              fontSize: context.dynamicHeight(0.032), //0.4
              color: AppColors.white,
              shadows: List.generate(2, (index) => const Shadow(blurRadius: 8,)),
            ),
          ).wrapPadding(const EdgeInsets.only(top: 4)),
        ],
      ),
    );
  }
}
