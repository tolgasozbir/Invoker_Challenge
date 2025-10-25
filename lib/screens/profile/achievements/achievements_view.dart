import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../constants/locale_keys.g.dart';
import '../../../services/achievement_manager.dart';
import '../../../widgets/app_scaffold.dart';
import 'widgets/achievement_widget.dart';

class AchievementsView extends StatelessWidget {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: false,
      appbar: AppBar(
        centerTitle: true,
        title: Text(LocaleKeys.mainMenu_achievements.locale),
      ),
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    AchievementManager.instance.initAchievements();
    final achievements = AchievementManager.instance.achievements;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: List.generate(achievements.length, (index) {
          final achievement = achievements[index];
          final delay = index * 80;
          final isEven = index.isEven;

          return AchievementWidget(achievement: achievement)
              .animate()
              .fadeIn(
                delay: delay.ms,
                duration: 400.ms,
              )
              .slideX(
                delay: delay.ms,
                begin: isEven ? 0.4 : -0.4,
                duration: 650.ms,
                curve: Curves.easeOutQuart,
              )
              .then(delay: 100.ms)
              .shimmer(
                delay: 200.ms,
                duration: 1000.ms,
                color: Colors.white.withValues(alpha: 0.2),
              );
        }),
      ),
    );
  }
}
