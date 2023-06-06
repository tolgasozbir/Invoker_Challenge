import '../../../widgets/dialog_contents/leaderboard_dialog.dart';
import 'package:flutter/material.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../../../constants/app_image_paths.dart';
import '../../../constants/app_strings.dart';
import '../../../extensions/context_extension.dart';
import '../../../services/user_manager.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/game_ui_widget.dart';
import '../../../widgets/show_leaderboard_button.dart';

class ChallangerView extends StatefulWidget {
  const ChallangerView({super.key});

  @override
  State<ChallangerView> createState() => _ChallangerViewState();
}

class _ChallangerViewState extends State<ChallangerView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppScaffold(
        resizeToAvoidBottomInset: false,
        body: _bodyView(),
      ),
    );
  }

  Widget _bodyView() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          const Column(
            children: [
              GameUIWidget(gameType: GameType.Challanger),
              ShowLeaderBoardButton(
                title: AppStrings.leaderboard, 
                contentDialog: LeaderboardDialog(leaderboardType: LeaderboardType.Challenger),
              ),
            ],
          ),
          if(UserManager.instance.user.challangerLife > 0) lifeIcon(),
        ],
      ),
    );
  }

  Widget lifeIcon() {
    return Positioned(
      right: context.dynamicWidth(0.02),
      top: kToolbarHeight,
      child: Snappable(
        key: UserManager.instance.snappableKey,
        duration: const Duration(milliseconds: 1600),
        onSnapped: () => null,
        child: Image.asset(ImagePaths.icInvokerHead, height: 80),
      ),
    );
  }

}
