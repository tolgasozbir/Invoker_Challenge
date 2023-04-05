import '../../../enums/achievements.dart';
import '../../../providers/user_manager.dart';
import 'widgets/achievement_widget.dart';

class AchievementManager {
  AchievementManager._() {
    initAchievements();
  }

  static AchievementManager? _instance;
  static AchievementManager get instance => _instance ??= AchievementManager._();

  List<AchievementWidgetModel> get achievements => _achievements;
  List<AchievementWidgetModel> _achievements = [];

  var _userRecords = UserManager.instance.user.achievements;

  void initAchievements(){
    _achievements.clear();
    _achievements.addAll(_levelAchievements);
    _achievements.addAll(_playedGamesAchievements);
    _achievements.addAll(_timerModeAchievements);
    _achievements.addAll(_challengerModeAchievements);
    _achievements.insert(0, achieveAll);
  }

  void updateAchievements() {
    updateLevel();
    //updatePlayedGame();
    updateChallenger(0, 0);
    updateTimer(0);
    initAchievements();
    UserManager.instance.setAndSaveUserToLocale(UserManager.instance.user);
  }

  void updateLevel() {
    UserManager.instance.user.achievements?["level"] = UserManager.instance.user.level;
    print("User Level : ${UserManager.instance.user.achievements?["level"]}");
  }

  void updatePlayedGame() {
    UserManager.instance.user.achievements?["playedGame"]++;
    print("Played Games : ${UserManager.instance.user.achievements?["playedGame"]}");
  }

  void updateChallenger(int score, int time) {
    var currentRecord = _userRecords?["challenger"] ?? 0;
    if (score <= currentRecord || time > 180) return;
    UserManager.instance.user.achievements?["challenger"] = score;
    print("Challenger Score : ${UserManager.instance.user.achievements?["challenger"]}");
  }  
  
  void updateTimer(int score) {
    var currentRecord = _userRecords?["timer"] ?? 0;
    if (score <= currentRecord) return;
    UserManager.instance.user.achievements?["timer"] = score;
    print("Timer Score : ${UserManager.instance.user.achievements?["timer"]}");
  }

  //First Achievement total progress
  AchievementWidgetModel get achieveAll {
    int currentProgress = achievements.where((e) => e.isDone == true).toList().length;
    return AchievementWidgetModel(
      id: "achievements",
      iconPath: "assets/images/achievements/ic_achievements.png", 
      title: "Achieve All", 
      description: "Get all achievements!", 
      isDone: currentProgress >= achievements.length, 
      currentProgress: currentProgress, 
      maxProgress: achievements.length
    );
  }  

  List<AchievementWidgetModel> get _levelAchievements {
    final levelAchievements = const [
      Achievements.level1, 
      Achievements.level2, 
      Achievements.level3, 
      Achievements.level4, 
      Achievements.level5,
    ];

    return levelAchievements.map((e) => AchievementWidgetModel(
      id: e.getId, 
      iconPath: e.getIconPath, 
      title: e.getTitle, 
      description: e.getDescription, 
      isDone: (_userRecords?["level"] ?? 0) >= e.getMaxProgress,
      currentProgress: _userRecords?["level"] ?? 0, 
      maxProgress: e.getMaxProgress
    )).toList();
  }

  List<AchievementWidgetModel> get _playedGamesAchievements {
    final playedGamesAchievements = const [
      Achievements.played_games1, 
      Achievements.played_games2,
      Achievements.played_games3,
      Achievements.played_games4,
      Achievements.played_games5,
    ];

    return playedGamesAchievements.map((e) => AchievementWidgetModel(
      id: e.getId, 
      iconPath: e.getIconPath, 
      title: e.getTitle, 
      description: e.getDescription, 
      isDone: (_userRecords?["playedGame"] ?? 0) >= e.getMaxProgress,
      currentProgress: _userRecords?["playedGame"] ?? 0, 
      maxProgress: e.getMaxProgress
    )).toList();
  }  

  List<AchievementWidgetModel> get _timerModeAchievements {
    final timerModeAchievements = const [
      Achievements.timer1,
      Achievements.timer2,
      Achievements.timer3,
    ];

    return timerModeAchievements.map((e) => AchievementWidgetModel(
      id: e.getId, 
      iconPath: e.getIconPath, 
      title: e.getTitle, 
      description: e.getDescription, 
      isDone: (_userRecords?["timer"] ?? 0) >= e.getMaxProgress,
      currentProgress: _userRecords?["timer"] ?? 0,  
      maxProgress: e.getMaxProgress
    )).toList();
  }

  List<AchievementWidgetModel> get _challengerModeAchievements {
    final challengerModeAchievements = const [
      Achievements.challenger1,
      Achievements.challenger2,
      Achievements.challenger3,
    ];

    return challengerModeAchievements.map((e) => AchievementWidgetModel(
      id: e.getId, 
      iconPath: e.getIconPath, 
      title: e.getTitle, 
      description: e.getDescription, 
      isDone: (_userRecords?["challenger"] ?? 0) >= e.getMaxProgress,
      currentProgress: _userRecords?["challenger"] ?? 0, 
      maxProgress: e.getMaxProgress
    )).toList();
  }

}
