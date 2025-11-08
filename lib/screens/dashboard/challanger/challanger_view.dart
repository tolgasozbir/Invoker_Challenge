import 'package:flutter/material.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../../../constants/app_image_paths.dart';
import '../../../constants/locale_keys.g.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/string_extension.dart';
import '../../../services/user_manager.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/dialog_contents/leaderboard_dialog.dart';
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
          Column(
            children: [
              const GameUIWidget(gameType: GameType.Challanger),
              ShowLeaderBoardButton(
                title: LocaleKeys.commonGeneral_leaderboard.locale, 
                contentDialog: const LeaderboardDialog(leaderboardType: LeaderboardType.Challenger),
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
        duration: const Duration(milliseconds: 2000),
        onSnapped: () => null,
        child: Image.asset(ImagePaths.icInvokerHead, height: 80),
      ),
    );
  }

}
