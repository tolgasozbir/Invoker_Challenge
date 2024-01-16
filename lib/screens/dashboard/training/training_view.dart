import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../extensions/context_extension.dart';
import '../../../providers/game_provider.dart';
import '../../../utils/ads_helper.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/empty_box.dart';
import '../../../widgets/game_ui_widget.dart';
import '../../../widgets/spells_helper_widget.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({super.key});

  @override
  State<TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends State<TrainingView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppScaffold(
        body: _bodyView(),
      ),
    );
  }

  Widget _bodyView() {
    return SingleChildScrollView(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          //adBannerWidget(),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              Consumer<GameProvider>(
                builder: (context, provider, child) => AnimatedCrossFade(
                  duration: const Duration(milliseconds: 400),
                  firstChild: const EmptyBox(),
                  secondChild: const SpellsHelperWidget(),
                  crossFadeState: provider.spellHelperIsOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                ),
              ),
              const GameUIWidget(gameType: GameType.Training),
            ],
          ),
          showSpells(),
        ],
      ),
    );
  }

  Widget showSpells() {
    return Consumer<GameProvider>(
      builder: (context, provider, child) => AnimatedPositioned(
        duration: const Duration(milliseconds: 400),
        right: context.dynamicWidth(0.02), 
        top: kToolbarHeight + (provider.spellHelperIsOpen ? context.dynamicHeight(0.24) : 0),
        child: GestureDetector(
          child: Container(
            alignment: Alignment.topRight,
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(4),
            height: context.dynamicWidth(0.16),
            width: context.dynamicWidth(0.16),
            child: const Icon(
              Icons.help_outline,
              size: 28,
              color: AppColors.amber,
            ),
          ),
          onTap: () => provider.showCloseHelperWidget(),
        ),
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
