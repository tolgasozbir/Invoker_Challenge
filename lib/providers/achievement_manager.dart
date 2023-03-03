import 'package:dota2_invoker/providers/user_manager.dart';

import '../enums/achievements.dart';
import '../models/user_model.dart';
import '../screens/profile/achievements/widgets/achievement_widget.dart';

class AchievementManager {
  AchievementManager._() {
    _initAchievements();
  }

  static AchievementManager? _instance;
  static AchievementManager get instance => _instance ??= AchievementManager._();

  List<AchievementWidgetModel> get achievements => _achievements;
  List<AchievementWidgetModel> _achievements = [];

  void _initAchievements(){
    _achievements.addAll(levelAchievements);
    _achievements.addAll(playedGamesAchievements);
    _achievements.addAll(TimerModeAchievements);
    _achievements.addAll(ChallengerModeAchievements);
    //_achievements.insert(0, achieveAll);
  }

  void setAchievements(){
    var records = UserManager.instance.user.achievements;
    var achs = Achievements.values; //enums

    //eğer userda değer yoksa 0 dan değersiz oluşturuyoruz
    if (records.isEmpty) { //idleri verip 0 ve false olarak dolduruyoruz
      UserManager.instance.user.achievements = achs.map((e) 
        => UserAchievementModel(id: e.getId, currentProgress: 0)).toList();
      _achievements.insert(0, achieveAll);
      return;
    }

    if (achievements.length > achs.length) {
      achievements.removeAt(0);
    }

    //Userdaki değereleri göre liste tekrar güncelleniyor
    //update achievements progress etc.
    for (var i = 0; i < achievements.length; i++) {
      var user = UserManager.instance.user.achievements[i];
      var achsModel = achievements[i];
      //var model = achievements.firstWhere((element) => element.id == user.id);

      achsModel.currentProgress = user?.currentProgress ?? 0;
      achsModel.isDone = (user?.currentProgress ?? 0) >= achsModel.maxProgress;
    }

    _achievements.insert(0, achieveAll);
  }

  //First Achievement total progress
  AchievementWidgetModel get achieveAll {
    int currentProgress = achievements.where((e) => e.isDone == true).toList().length;
    return AchievementWidgetModel(
      id: "achievements",
      iconPath: "assets/images/achievements/ic_achievements.png", 
      title: "Achieve All", 
      description: "Get all achievements!", 
      isDone: false, 
      currentProgress: currentProgress, 
      maxProgress: achievements.length
    );
  }  
  
  List<AchievementWidgetModel> levelAchievements = [
    AchievementWidgetModel(
      id: "level1",
      iconPath: "assets/images/achievements/ic_level1.png", 
      title: "Good Knowledge",
      description: "Reach 10 level.", 
      isDone: false, 
      currentProgress: 0,
      maxProgress: 10
    ),
    AchievementWidgetModel(
      id: "level2",
      iconPath: "assets/images/achievements/ic_level2.png", 
      title: "Second Chance",
      description: "Reach 15 level.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 15
    ),
    AchievementWidgetModel(
      id: "level3",
      iconPath: "assets/images/achievements/ic_level3.png", 
      title: "THE “NEW YOU”",
      description: "Reach 20 level.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 20
    ),
    AchievementWidgetModel(
      id: "level4",
      iconPath: "assets/images/achievements/ic_level4.png", 
      title: "Near The End",
      description: "Reach 25 level.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 25
    ),
    AchievementWidgetModel(
      id: "level5",
      iconPath: "assets/images/achievements/ic_level5.png", 
      title: "Welcome To The Limit",
      description: "Reach 30 level.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 30
    ),
  ];

  List<AchievementWidgetModel> playedGamesAchievements = [
    AchievementWidgetModel(
      id: "played_games1",
      iconPath: "assets/images/achievements/ic_played_games1.png", 
      title: "Basic Training",
      description: "Play Any Mode 10 times.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 10
    ),
    AchievementWidgetModel(
      id: "played_games2",
      iconPath: "assets/images/achievements/ic_played_games2.png", 
      title: "Still Learning",
      description: "Play Any Mode 20 times.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 20
    ),
    AchievementWidgetModel(
      id: "played_games3",
      iconPath: "assets/images/achievements/ic_played_games3.png", 
      title: "We're Just Getting Started",
      description: "Play Any Mode 50 times.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 50
    ),
    AchievementWidgetModel(
      id: "played_games4",
      iconPath: "assets/images/achievements/ic_played_games4.png", 
      title: "Almost Pro",
      description: "Play Any Mode 100 times.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 100
    ),
    AchievementWidgetModel(
      id: "played_games5",
      iconPath: "assets/images/achievements/ic_played_games5.png", 
      title: "Invoker GOD!",
      description: "Play Any Mode 200 times.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 200
    ),
  ];

  List<AchievementWidgetModel> TimerModeAchievements = [
    AchievementWidgetModel(
      id: "timer1",
      iconPath: "assets/images/achievements/ic_timer1.png", 
      title: "Always Hard",
      description: "Reach 50 Score before time runs out in Timer mode.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 50
    ),
    AchievementWidgetModel(
      id: "timer2",
      iconPath: "assets/images/achievements/ic_timer2.png", 
      title: "Speed Freak",
      description: "Reach 75 Score before time runs out in Timer mode.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 75
    ),
    AchievementWidgetModel(
      id: "timer3",
      iconPath: "assets/images/achievements/ic_timer3.png", 
      title: "OUT OF CONTROL!",
      description: "Reach 100 Score before time runs out in Timer mode.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 100
    ),
  ];

  List<AchievementWidgetModel> ChallengerModeAchievements = [
    AchievementWidgetModel(
      id: "challenger1",
      iconPath: "assets/images/achievements/ic_challenger1.png", 
      title: "Streaker",
      description: "Reach 200 points in under 5 minutes in Challenger mode.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 50
    ),
    AchievementWidgetModel(
      id: "challenger2",
      iconPath: "assets/images/achievements/ic_challenger2.png", 
      title: "Must Try Harder",
      description: "Reach 200 points in under 5 minutes in Challenger mode.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 100
    ),
    AchievementWidgetModel(
      id: "challenger3",
      iconPath: "assets/images/achievements/ic_challenger3.png", 
      title: "The Real CHALLENGER!",
      description: "Reach 200 points in under 5 minutes in Challenger mode.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 200
    ),
  ];

}
