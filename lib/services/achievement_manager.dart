import '../enums/achievements.dart';
import 'user_manager.dart';
import '../screens/profile/achievements/widgets/achievement_widget.dart';

class AchievementManager {
  AchievementManager._() {
    initAchievements();
  }

  static AchievementManager? _instance;
  static AchievementManager get instance => _instance ??= AchievementManager._();

  List<AchievementWidgetModel> get achievements => _achievements;
  final List<AchievementWidgetModel> _achievements = [];

  var _userRecords = UserManager.instance.user.achievements ??= {};

  void initAchievements() {
    UserManager.instance.user.achievements ??= {};
    _userRecords = UserManager.instance.user.achievements!;
    _achievements.clear();
    _achievements.addAll(_levelAchievements);
    _achievements.addAll(_playedGamesAchievements);
    _achievements.addAll(_timerModeAchievements);
    _achievements.addAll(_challengerModeAchievements);
    _achievements.addAll(_comboModeAchievements);
    _achievements.addAll(_bossModeAchievements);
    _achievements.addAll(_miscAchievements);
    _achievements.insert(0, achieveAll);
  }

  void updateAchievements() {
    initAchievements();
    UserManager.instance.setUserAndSaveToCache(UserManager.instance.user);
  }

  void updateLevel() {
    UserManager.instance.user.achievements?.putIfAbsent('level', () => 0);
    UserManager.instance.user.achievements?['level'] = UserManager.instance.user.level;
    //print("User Level : ${UserManager.instance.user.achievements?["level"]}");
  }

  void updatePlayedGame() {
    UserManager.instance.user.achievements?.putIfAbsent('playedGame', () => 0);
    UserManager.instance.user.achievements?['playedGame']++;
    //print("Played Games : ${UserManager.instance.user.achievements?["playedGame"]}");
  }

  void updateChallenger(int score, int time) {
    UserManager.instance.user.achievements?.putIfAbsent('challenger', () => 0);
    final currentRecord = _userRecords['challenger'] as int? ?? 0;
    if (score <= currentRecord || time > 180) return;
    UserManager.instance.user.achievements?['challenger'] = score;
    //print("Challenger Score : ${UserManager.instance.user.achievements?["challenger"]}");
  }  
  
  void updateTimer(int score) {
    UserManager.instance.user.achievements?.putIfAbsent('timer', () => 0);
    final currentRecord = _userRecords['timer'] as int? ?? 0;
    if (score <= currentRecord) return;
    UserManager.instance.user.achievements?['timer'] = score;
    //print("Timer Score : ${UserManager.instance.user.achievements?["timer"]}");
  }
  
  void updateCombo(int score) {
    UserManager.instance.user.achievements?.putIfAbsent('combo', () => 0);
    final currentRecord = _userRecords['combo'] as int? ?? 0;
    if (score <= currentRecord) return;
    UserManager.instance.user.achievements?['combo'] = score;
  }

  void updateBoss() {
    UserManager.instance.user.achievements?.putIfAbsent('boss', () => 0);
    UserManager.instance.user.achievements?['boss']++;
    //print("Killed Boss Progress : ${UserManager.instance.user.achievements?["boss"]}");
  }

  void updateMiscKillWk() {
    UserManager.instance.user.achievements?.putIfAbsent(Achievements.misc_kill_wk.name, () => 1);
  }

  void updateMiscGold(int progress) {
    final achievementName = Achievements.misc_gold.name;
    UserManager.instance.user.achievements?.putIfAbsent(achievementName, () => 0);
    final currentRecord = _userRecords[achievementName] as int? ?? 0;
    if (progress <= currentRecord) return;
    UserManager.instance.user.achievements?[achievementName] = progress;
  }

  //First Achievement total progress
  AchievementWidgetModel get achieveAll {
    final int currentProgress = achievements.where((e) => e.isDone == true).toList().length;
    return AchievementWidgetModel(
      id: 'achievements',
      iconPath: 'assets/images/achievements/ic_achievements.png', 
      title: 'Achieve All', 
      description: 'Get all achievements!', 
      isDone: currentProgress >= achievements.length, 
      currentProgress: currentProgress, 
      maxProgress: achievements.length,
    );
  }  

  List<AchievementWidgetModel> get _levelAchievements {
    const levelAchievements = [
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
      isDone: (_userRecords['level'] as int? ?? 0) >= e.getMaxProgress,
      currentProgress: _userRecords['level'] as int? ?? 0, 
      maxProgress: e.getMaxProgress,
    ),).toList();
  }

  List<AchievementWidgetModel> get _playedGamesAchievements {
    const playedGamesAchievements = [
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
      isDone: (_userRecords['playedGame'] as int? ?? 0) >= e.getMaxProgress,
      currentProgress: _userRecords['playedGame'] as int? ?? 0, 
      maxProgress: e.getMaxProgress,
    ),).toList();
  }  

  List<AchievementWidgetModel> get _timerModeAchievements {
    const timerModeAchievements = [
      Achievements.timer1,
      Achievements.timer2,
      Achievements.timer3,
    ];

    return timerModeAchievements.map((e) => AchievementWidgetModel(
      id: e.getId, 
      iconPath: e.getIconPath, 
      title: e.getTitle, 
      description: e.getDescription, 
      isDone: (_userRecords['timer'] as int? ?? 0) >= e.getMaxProgress,
      currentProgress: _userRecords['timer'] as int? ?? 0,  
      maxProgress: e.getMaxProgress,
    ),).toList();
  }

  List<AchievementWidgetModel> get _challengerModeAchievements {
    const challengerModeAchievements = [
      Achievements.challenger1,
      Achievements.challenger2,
      Achievements.challenger3,
    ];

    return challengerModeAchievements.map((e) => AchievementWidgetModel(
      id: e.getId, 
      iconPath: e.getIconPath, 
      title: e.getTitle, 
      description: e.getDescription, 
      isDone: (_userRecords['challenger'] as int? ?? 0) >= e.getMaxProgress,
      currentProgress: _userRecords['challenger'] as int? ?? 0, 
      maxProgress: e.getMaxProgress,
    ),).toList();
  }
  
  List<AchievementWidgetModel> get _comboModeAchievements {
    const comboModeAchievements = [
      Achievements.combo1,
      Achievements.combo2,
      Achievements.combo3,
    ];

    return comboModeAchievements.map((e) => AchievementWidgetModel(
      id: e.getId, 
      iconPath: e.getIconPath, 
      title: e.getTitle, 
      description: e.getDescription, 
      isDone: (_userRecords['combo'] as int? ?? 0) >= e.getMaxProgress,
      currentProgress: _userRecords['combo'] as int? ?? 0, 
      maxProgress: e.getMaxProgress,
    ),).toList();
  }

  List<AchievementWidgetModel> get _bossModeAchievements {
    const challengerModeAchievements = [
      Achievements.boss1,
      Achievements.boss2,
      Achievements.boss3,
    ];

    return challengerModeAchievements.map((e) => AchievementWidgetModel(
      id: e.getId, 
      iconPath: e.getIconPath, 
      title: e.getTitle, 
      description: e.getDescription, 
      isDone: (_userRecords['boss'] as int? ?? 0) >= e.getMaxProgress,
      currentProgress: _userRecords['boss'] as int? ?? 0, 
      maxProgress: e.getMaxProgress,
    ),).toList();
  }

  List<AchievementWidgetModel> get _miscAchievements {
    const challengerModeAchievements = [
      Achievements.misc_kill_wk,
      Achievements.misc_gold,
    ];

    return challengerModeAchievements.map((e) => AchievementWidgetModel(
      id: e.getId, 
      iconPath: e.getIconPath, 
      title: e.getTitle, 
      description: e.getDescription, 
      isDone: (_userRecords[e.name] as int? ?? 0) >= e.getMaxProgress,
      currentProgress: _userRecords[e.name] as int? ?? 0,
      maxProgress: e.getMaxProgress,
    ),).toList();
  }

}
