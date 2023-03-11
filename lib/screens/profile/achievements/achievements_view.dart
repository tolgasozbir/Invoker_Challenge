import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../constants/app_strings.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/sliders/progress_slider.dart';
import 'achievement_manager.dart';
import 'widgets/achievement_widget.dart';

class AchievementsView extends StatelessWidget {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    var totalCount = AchievementManager.instance.achievements.length;
    var current = AchievementManager.instance.achievements.where((e) => e.isDone == true).toList().length;
    return AppScaffold(
      extendBodyBehindAppBar: false,
      appbar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.achievements),
        actions: [
          SizedBox(
            width: context.dynamicWidth(0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Spacer(),
                Text(
                  "$current/$totalCount", 
                  style: TextStyle(fontSize: context.sp(12)),
                ).wrapAlign(Alignment.center),
                ProgressSlider(
                  max: totalCount.toDouble(),
                  current: current.toDouble(),
                ),
                Spacer(flex: 3),
              ],
            ).wrapPadding(EdgeInsets.only(right: 8)),
          ),
        ],
      ),
      body: _bodyView()
    );
  }

  Widget _bodyView() {
    AchievementManager.instance.initAchievements();
    var achievements = AchievementManager.instance.achievements;
    return AnimationLimiter(
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: achievements.length,
        itemBuilder: (BuildContext context, int index) {
          var achievement = achievements[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 1600),
            child: SlideAnimation(
              verticalOffset: 50.0,
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
