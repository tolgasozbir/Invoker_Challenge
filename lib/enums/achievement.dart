import 'package:dota2_invoker/models/achievement_model.dart';

enum Achievements {
  all(AchievementModel2(title: "title", goalText: "goalText", maxProgress: 0));
  
  
  // level1,
  // level2,
  // level3,
  // level4,
  // level5,
  // played_games1,
  // played_games2,
  // played_games3,
  // played_games4,
  // played_games5,
  // timer1,
  // timer2,
  // timer3,
  // challenger1,
  // challenger2,
  // challenger3;

  const Achievements(this.model);

  final AchievementModel2 model;

}

extension achievementExtension on Achievements {
  String get getIconPath => "assets/images/achievements/ic${this.name}.png";
}