class AchievementModel {
  final String id;
  final String iconPath;
  final String title;
  final String goalText;
  int currentProgress;
  final int maxProgress;
  bool isDone;

  AchievementModel({
    required this.id,
    required this.iconPath,
    required this.title,
    required this.goalText,
    required this.isDone,
    required this.currentProgress,
    required this.maxProgress,
  });

}

class AchievementModel2 {
  final String title;
  final String goalText;
  final int maxProgress;

  const AchievementModel2({
    required this.title,
    required this.goalText,
    required this.maxProgress,
  });

}
