import 'package:dota2_invoker/enums/achievement.dart';
import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:dota2_invoker/models/achievement_model.dart';
import 'package:dota2_invoker/screens/profile/achievements/widgets/achievement_widget.dart';
import 'package:dota2_invoker/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import '../../../widgets/sliders/progress_slider.dart';

class AchievementsView extends StatelessWidget {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Achievements"),
        actions: [
          SizedBox(
            width: context.dynamicWidth(0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Spacer(),
                Text(
                  "0/18", 
                  style: TextStyle(fontSize: context.sp(12)),
                ).wrapAlign(Alignment.center),
                ProgressSlider(
                  max: 18,
                  current: 5,
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
    AchievementManager.instance.init();
    var achievements = AchievementManager.instance.achievements;
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: achievements.length,
      itemBuilder: (BuildContext context, int index) {
        var achievement = achievements[index];
        return AchievementWidget(achievement: achievement);
      },
    );
  }
}

class AchievementManager {
  AchievementManager._();

  static AchievementManager? _instance;
  static AchievementManager get instance => _instance ??= AchievementManager._();

  List<AchievementModel> get achievements => _achievements;
  List<AchievementModel> _achievements = [];
  void init(){
    _achievements.clear();
    _achievements.addAll(levelAchievements);
    _achievements.addAll(playedGamesAchievements);
    _achievements.addAll(TimerModeAchievements);
    _achievements.addAll(ChallengerModeAchievements);
    _achievements.insert(0, achieveAll);
  }

  AchievementModel get achieveAll {
    int currentProgress = achievements.where((e) => e.isDone == true).toList().length;
    return AchievementModel(
      id: "ic_achievements",
      iconPath: "assets/images/achievements/ic_achievements.png", 
      title: "Achieve All", 
      goalText: "Get all achievements!", 
      isDone: false, 
      currentProgress: currentProgress, 
      maxProgress: achievements.length
    );
  }  
  
  List<AchievementModel> levelAchievements = [
    AchievementModel(
      id: "ic_level1",
      iconPath: "assets/images/achievements/ic_level1.png", 
      title: "Good Knowledge",
      goalText: "Reach 10 level.", 
      isDone: true, 
      currentProgress: 10, 
      maxProgress: 10
    ),
    AchievementModel(
      id: "ic_level2",
      iconPath: "assets/images/achievements/ic_level2.png", 
      title: "Second Chance",
      goalText: "Reach 15 level.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 15
    ),
    AchievementModel(
      id: "ic_level3",
      iconPath: "assets/images/achievements/ic_level3.png", 
      title: "THE “NEW YOU”",
      goalText: "Reach 20 level.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 20
    ),
    AchievementModel(
      id: "ic_level4",
      iconPath: "assets/images/achievements/ic_level4.png", 
      title: "Near The End",
      goalText: "Reach 25 level.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 25
    ),
    AchievementModel(
      id: "ic_level5",
      iconPath: "assets/images/achievements/ic_level5.png", 
      title: "Welcome To The Limit",
      goalText: "Reach 30 level.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 30
    ),
  ];

  List<AchievementModel> playedGamesAchievements = [
    AchievementModel(
      id: "ic_played_games1",
      iconPath: "assets/images/achievements/ic_played_games1.png", 
      title: "Basic Training",
      goalText: "Play Any Mode 10 times.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 10
    ),
    AchievementModel(
      id: "ic_played_games2",
      iconPath: "assets/images/achievements/ic_played_games2.png", 
      title: "Still Learning",
      goalText: "Play Any Mode 20 times.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 20
    ),
    AchievementModel(
      id: "ic_played_games3",
      iconPath: "assets/images/achievements/ic_played_games3.png", 
      title: "We're Just Getting Started",
      goalText: "Play Any Mode 50 times.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 50
    ),
    AchievementModel(
      id: "ic_played_games4",
      iconPath: "assets/images/achievements/ic_played_games4.png", 
      title: "Almost Pro",
      goalText: "Play Any Mode 100 times.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 100
    ),
    AchievementModel(
      id: "ic_played_games5",
      iconPath: "assets/images/achievements/ic_played_games5.png", 
      title: "Invoker GOD!",
      goalText: "Play Any Mode 200 times.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 200
    ),
  ];

  List<AchievementModel> TimerModeAchievements = [
    AchievementModel(
      id: "ic_timer1",
      iconPath: "assets/images/achievements/ic_timer1.png", 
      title: "Always Hard",
      goalText: "Reach 50 Score before time runs out in Timer mode.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 50
    ),
    AchievementModel(
      id: "ic_timer2",
      iconPath: "assets/images/achievements/ic_timer2.png", 
      title: "Speed Freak",
      goalText: "Reach 75 Score before time runs out in Timer mode.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 75
    ),
    AchievementModel(
      id: "ic_timer3",
      iconPath: "assets/images/achievements/ic_timer3.png", 
      title: "OUT OF CONTROL!",
      goalText: "Reach 100 Score before time runs out in Timer mode.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 100
    ),
  ];

  List<AchievementModel> ChallengerModeAchievements = [
    AchievementModel(
      id: "ic_challenger1",
      iconPath: "assets/images/achievements/ic_challenger1.png", 
      title: "Streaker",
      goalText: "Reach 200 points in under 5 minutes in Challenger mode.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 50
    ),
    AchievementModel(
      id: "ic_challenger2",
      iconPath: "assets/images/achievements/ic_challenger2.png", 
      title: "Must Try Harder",
      goalText: "Reach 200 points in under 5 minutes in Challenger mode.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 100
    ),
    AchievementModel(
      id: "ic_challenger3",
      iconPath: "assets/images/achievements/ic_challenger3.png", 
      title: "The Real CHALLENGER!",
      goalText: "Reach 200 points in under 5 minutes in Challenger mode.", 
      isDone: false, 
      currentProgress: 0, 
      maxProgress: 200
    ),
  ];

}

  List<String> titles2 = [
    "The Novice", //acemi
    "newbie", //çaylak
    "Adept", //usta
    "Complexity", //karmaşıklık
    "Wisdom", //bilgelik
    "Perseverance", //sabır
    "The Complexity Taste" //karmaşıklığın tadı
    "Welcome To The Limit" // Reach 30 level
  "FIRST BLOOD"
  ];



//Boss
//"FIRST BLOOD" ilk büyük boss'unu öldür
//"RAMPAGE" ölmeden 5 büyük boss öldür
//MARATHON. //modu x süre içinde bitir
//DRAGON SLAYER.
//CLEAR ROUND 5.

//NEVER GONNA SPEND IT ALL //Boss modunda fazladan 1k biriktir

//misc çeşitli
//BUTTON MASHER
//ORB HUNTER
// BRONZE STREAKER.
// SILVER STREAKER.
// GOLD STREAKER.
// STREAK MASTER.
//THE DESTROYER.. //reach all achivements
//TO THE MOON.
//"IT'S MINE! ALL MINE!".
//NOW YOU SEE ME, NOW YOU DON'T.
//TOO MANY TO COUNT //para ilgili birşey