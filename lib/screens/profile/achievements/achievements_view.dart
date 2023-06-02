import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../constants/app_strings.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../services/achievement_manager.dart';
import 'widgets/achievement_widget.dart';

class AchievementsView extends StatelessWidget {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: false,
      appbar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.achievements),
      ),
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    AchievementManager.instance.initAchievements();
    final achievements = AchievementManager.instance.achievements;
    return AnimationLimiter(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(8),
        itemCount: achievements.length,
        itemBuilder: (BuildContext context, int index) {
          final achievement = achievements[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 1200),
            child: SlideAnimation(
              horizontalOffset: 300,//index.isEven ? 300 : -300,
                child: FadeInAnimation(
                  child: AchievementWidget(achievement: achievement),
                ),
            ),
          );
        },
      ),
    );
  }
}
