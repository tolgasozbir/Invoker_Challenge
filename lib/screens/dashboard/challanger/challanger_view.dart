import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../../../constants/app_image_paths.dart';
import '../../../constants/app_strings.dart';
import '../../../extensions/context_extension.dart';
import '../../../providers/game_provider.dart';
import '../../../services/user_manager.dart';
import '../../../widgets/app_dialogs.dart';
import '../../../widgets/app_outlined_button.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/dialog_contents/leaderboards/leaderboard_challanger.dart';
import '../../../widgets/empty_box.dart';
import '../../../widgets/game_ui_widget.dart';

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
              showLeaderBoardButton(),
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

  Widget showLeaderBoardButton() {
    final isStart = context.watch<GameProvider>().isStart;
    if (isStart) return const EmptyBox();
    return AppOutlinedButton(
      title: AppStrings.leaderboard,
      width: context.dynamicWidth(0.4),
      padding: EdgeInsets.only(top: context.dynamicHeight(0.02)),
      onPressed: () => AppDialogs.showScaleDialog(
        title: AppStrings.leaderboard,
        content: const LeaderboardChallanger(),
        action: AppOutlinedButton(
          title: AppStrings.back,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

}
