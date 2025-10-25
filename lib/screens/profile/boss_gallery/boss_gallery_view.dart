import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../constants/locale_keys.g.dart';
import '../../../enums/Bosses.dart';
import '../../../extensions/number_extension.dart';
import '../../../extensions/string_extension.dart';
import '../../../widgets/app_dialogs.dart';
import '../../../widgets/app_outlined_button.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/dialog_contents/leaderboard_dialog.dart';

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
        title: Text(LocaleKeys.mainMenu_bossGallery.locale),
      ),
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2/3,
      ),
      padding: const EdgeInsets.all(8),
      itemCount: Bosses.values.length,
      itemBuilder: (BuildContext context, int index) {
        final boss = Bosses.values[index];
        final delay = (index+1) * 60;
        const duration = 600;

        return _bossCard(boss)
            .animate()
            .fadeIn(
              delay: delay.ms,
              duration: duration.ms,
              curve: Curves.easeOutCubic,
            )
            .slideY(
              delay: delay.ms,
              begin: 0.4,
              end: 0,
              duration: duration.ms,
              curve: Curves.easeOutCubic,
            )
            .scale(
              delay: delay.ms,
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              duration: duration.ms,
              curve: Curves.easeOutBack,
            );
      },
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
            FittedBox(
              child: Text(
                boss.getReadableName, 
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Virgil',
                  fontSize: 16,
                  shadows: List.generate(2, (index) => const Shadow(color: Colors.red, blurRadius: 4)),
                ),
              ),
            ),
            FittedBox(
              child: Text(
                'HP ${boss.health.numberFormat}',
                style: TextStyle(
                  fontFamily: 'Virgil',
                  shadows: List.generate(2, (index) => const Shadow(color: Colors.deepPurple, blurRadius: 4)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void cardOnTapFn(Bosses boss) {
    //SoundManager.instance.playBossEnteringSound(boss);
    AppDialogs.showScaleDialog(
      title: '${LocaleKeys.commonGeneral_leaderboard.locale} ${boss.getReadableName}',
      content: LeaderboardDialog(leaderboardType: LeaderboardType.Boss, boss: boss),
      action: AppOutlinedButton(
        title: LocaleKeys.commonGeneral_back.locale,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
