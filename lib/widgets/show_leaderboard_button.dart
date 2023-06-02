import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_strings.dart';
import '../extensions/context_extension.dart';
import '../providers/game_provider.dart';
import 'app_dialogs.dart';
import 'app_outlined_button.dart';
import 'empty_box.dart';

class ShowLeaderBoardButton extends StatelessWidget {
  const ShowLeaderBoardButton({super.key, required this.title, required this.contentDialog});

  final String title;
  final Widget contentDialog;

  @override
  Widget build(BuildContext context) {
    final isStart = context.watch<GameProvider>().isStart;
    if (isStart) return const EmptyBox();
    return AppOutlinedButton(
      title: title, 
      width: context.dynamicWidth(0.4),
      padding: EdgeInsets.only(top: context.dynamicHeight(0.02)),
      onPressed: () => AppDialogs.showScaleDialog(
        title: AppStrings.leaderboard,
        content: contentDialog,
        action: AppOutlinedButton(
          title: AppStrings.back,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
