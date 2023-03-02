import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/models/achievement_model.dart';
import 'package:dota2_invoker/widgets/sliders/progress_slider.dart';
import 'package:flutter/material.dart';
import '../../../../extensions/widget_extension.dart';

class AchievementWidget extends StatelessWidget {
  const AchievementWidget({super.key, required this.achievement});

  final AchievementModel achievement;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      height: context.dynamicHeight(0.18),
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(right: 8),
      child: Row(
        children: [
          Image.asset(
            achievement.iconPath, 
            fit: BoxFit.scaleDown,
          ).wrapExpanded(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(child: Text(achievement.title, style: TextStyle(fontSize: context.sp(18)),)),
              FittedBox(child: Text(achievement.goalText, style: TextStyle(fontSize: context.sp(12)),)),
              Row(
                children: [
                  Text(achievement.currentProgress.toString()),
                  EmptyBox.w8(),
                  ProgressSlider(
                    trackHeight: 6,
                    current: achievement.currentProgress.toDouble(), 
                    max: achievement.maxProgress.toDouble(),
                  ).wrapExpanded(),
                  EmptyBox.w8(),
                  Text(achievement.maxProgress.toString()),
                  EmptyBox.w12(),
                ],
              ),
            ],
          ).wrapExpanded(flex: 2),
        ],
      ),
    );
  }
}