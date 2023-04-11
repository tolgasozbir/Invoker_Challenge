import 'package:flutter/material.dart';

import '../../../../extensions/context_extension.dart';
import '../../../../extensions/widget_extension.dart';
import '../../../../widgets/sliders/progress_slider.dart';

class AchievementWidget extends StatelessWidget {
  const AchievementWidget({super.key, required this.achievement});

  final AchievementWidgetModel achievement;
  
  @override
  Widget build(BuildContext context) {
    var currentProgress = achievement.currentProgress.toDouble();
    var max = achievement.maxProgress.toDouble();
    var current = currentProgress >= max ? max : currentProgress;
    return Container(
      color: Colors.grey.withOpacity(0.2),
      height: context.dynamicHeight(0.12),
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
              Text(
                achievement.title, 
                style: TextStyle(fontSize: context.sp(16))
              ).wrapFittedBox(),
              Text(
                achievement.description, 
                style: TextStyle(fontSize: context.sp(10))
              ).wrapFittedBox(),
              Row(
                children: [
                  Text(current.toStringAsFixed(0)),
                  EmptyBox.w8(),
                  ProgressSlider(
                    trackHeight: 6,
                    current: current,  
                    max: max,
                  ).wrapExpanded(),
                  EmptyBox.w8(),
                  Text(max.toStringAsFixed(0)),
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

class AchievementWidgetModel {
  final String id;
  final String iconPath;
  final String title;
  final String description;
  int currentProgress;
  final int maxProgress;
  bool isDone;

  AchievementWidgetModel({
    required this.id,
    required this.iconPath,
    required this.title,
    required this.description,
    required this.isDone,
    required this.currentProgress,
    required this.maxProgress,
  });

}