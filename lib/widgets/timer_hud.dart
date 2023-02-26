import '../constants/app_strings.dart';
import '../extensions/context_extension.dart';
import '../extensions/widget_extension.dart';
import 'game_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class TimerHud extends StatelessWidget {
  const TimerHud({super.key, required this.gameType});

  final GameType gameType;

  String getTimerValue(BuildContext context) {
    var gameProvider = context.watch<GameProvider>();
    switch (gameType) {
      case GameType.Training:
      case GameType.Challanger:
        return gameProvider.getTimeValue.toString().padLeft(2, '0');
      case GameType.Timer:
        return gameProvider.getCountdownValue.toString().padLeft(2, '0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Image.asset(ImagePaths.todClock, height: context.dynamicHeight(0.1)),
        Text(
          getTimerValue(context),
          style: TextStyle(
            fontSize: context.dynamicHeight(0.04),
            color: Color.fromARGB(255, 255, 255, 255),
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 8,
              )
            ]
          )
        ).wrapPadding(EdgeInsets.only(top: 4)),
      ],
    );
  }
}
