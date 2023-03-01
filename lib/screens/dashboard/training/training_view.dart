import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:dota2_invoker/providers/game_provider.dart';
import 'package:dota2_invoker/widgets/spells_helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/game_ui_widget.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({super.key});

  @override
  State<TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends State<TrainingView> {

  bool showAllSpells = false;

  @override
  Widget build(BuildContext context) {
    showAllSpells = context.watch<GameProvider>().spellHelperIsOpen;
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
        children: [
          Column(
            children: [
              AnimatedCrossFade(
                duration: Duration(milliseconds: 400),
                firstChild: EmptyBox(),
                secondChild: SpellsHelperWidget(),
                crossFadeState: showAllSpells ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              ),
              const GameUIWidget(gameType: GameType.Training),
            ],
          ),
          showSpells(),
        ],
      ),
    );
  }

  AnimatedPositioned showSpells() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 400),
      right: context.dynamicWidth(0.02), 
      top: kToolbarHeight + (showAllSpells ? context.dynamicHeight(0.24) : 0),
      child: InkWell(
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        child: SizedBox.square(
          dimension: context.dynamicWidth(0.08),
          child: const Icon(FontAwesomeIcons.questionCircle,color: AppColors.amber),
        ),
        onTap: () => context.read<GameProvider>().showCloseHelperWidget(),
      ),
    );
  }

}
