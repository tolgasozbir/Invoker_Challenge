import 'package:dota2_invoker_game/extensions/string_extension.dart';

import '../../../constants/locale_keys.g.dart';
import '../../../extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../../../utils/ads_helper.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/dialog_contents/leaderboard_dialog.dart';
import '../../../widgets/game_ui_widget.dart';
import '../../../widgets/show_leaderboard_button.dart';

class ComboView extends StatefulWidget {
  const ComboView({super.key});

  @override
  State<ComboView> createState() => _ComboViewState();
}

class _ComboViewState extends State<ComboView> {
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
        clipBehavior: Clip.none,
        children: [
          adBannerWidget(),
          Column(
            children: [
              const GameUIWidget(gameType: GameType.Combo),
              ShowLeaderBoardButton(
                title: LocaleKeys.commonGeneral_leaderboard.locale, 
                contentDialog: const LeaderboardDialog(leaderboardType: LeaderboardType.Combo),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Positioned adBannerWidget() {
    return Positioned(
      top: context.height - MediaQuery.of(context).padding.top - 50,
      left: 0,
      right: 0,
      child: const AdBanner(),
    );
  }

}
