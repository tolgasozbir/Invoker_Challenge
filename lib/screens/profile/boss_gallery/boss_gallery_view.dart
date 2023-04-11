import 'package:dota2_invoker_game/enums/Bosses.dart';
import 'package:dota2_invoker_game/extensions/widget_extension.dart';
import 'package:dota2_invoker_game/utils/number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../constants/app_strings.dart';
import '../../../widgets/app_dialogs.dart';
import '../../../widgets/app_outlined_button.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/dialog_contents/leaderboards/leaderboard_bosses.dart';

class BossGalleryView extends StatefulWidget {
  const BossGalleryView({super.key});

  @override
  State<BossGalleryView> createState() => _BossGalleryViewState();
}

class _BossGalleryViewState extends State<BossGalleryView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: false,
      appbar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.bossGallery),
      ),
      body: _bodyView()
    );
  }

  Widget _bodyView() {
    return AnimationLimiter(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2/3,
        ),
        padding: EdgeInsets.all(8),
        itemCount: Bosses.values.length,
        itemBuilder: (BuildContext context, int index) {
          var boss = Bosses.values[index];
          return AnimationConfiguration.staggeredGrid(
            columnCount: 3,
            position: index,
            duration: Duration(milliseconds: 1200),
            child: SlideAnimation(
              child: FadeInAnimation(
                child: _bossCard(boss),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bossCard(Bosses boss) {
    return InkWell(
      onTap: () => cardOnTapFn(boss),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(boss.getImage),
            Text(
              boss.getName, 
              style: TextStyle(
                fontWeight: FontWeight.w600,
                shadows: List.generate(2, (index) => Shadow(color: Colors.red, blurRadius: 4))
              ),
            ).wrapFittedBox(),
            Text(
              "HP "+priceString(boss.getHp),
              style: TextStyle(
                shadows: List.generate(2, (index) => Shadow(color: Colors.deepPurple, blurRadius: 4))
              ),
            ).wrapFittedBox(),
          ],
        ),
      ),
    );
  }

  void cardOnTapFn(Bosses boss) {
    AppDialogs.showScaleDialog(
      title: AppStrings.leaderboard + " " +boss.getName,
      content: LeaderboardBosses(bossName: boss.getName),
      action: AppOutlinedButton(
        title: AppStrings.back,
        onPressed: (){
          Navigator.pop(context);
        },
      ),
    );
  }
}
