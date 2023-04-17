import 'package:dota2_invoker_game/utils/ads_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../providers/game_provider.dart';
import '../../../widgets/app_scaffold.dart';
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
        extendBodyBehindAppBar: true,
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
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              Consumer<GameProvider>(
                builder: (context, provider, child) => AnimatedCrossFade(
                  duration: Duration(milliseconds: 400),
                  firstChild: EmptyBox(),
                  secondChild: SpellsHelperWidget(),
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
        duration: Duration(milliseconds: 400),
        right: context.dynamicWidth(0.02), 
        top: kToolbarHeight + (provider.spellHelperIsOpen ? context.dynamicHeight(0.24) : 0),
        child: InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          child: SizedBox.square(
            dimension: context.dynamicWidth(0.08),
            child: const Icon(FontAwesomeIcons.questionCircle,color: AppColors.amber),
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
      child: AdBanner()
    );
  }

}
