enum Achievements {
  level1(title: 'Good Knowledge',       description: 'Reach 10 level.',   maxProgress: 10),
  level2(title: 'Second Chance',        description: 'Reach 15 level.',   maxProgress: 15),
  level3(title: 'THE “NEW YOU”',        description: 'Reach 20 level.',   maxProgress: 20),
  level4(title: 'Near The End',         description: 'Reach 25 level.',   maxProgress: 25),
  level5(title: 'Welcome To The Limit', description: 'Reach 30 level.',   maxProgress: 30),
  played_games1(title: 'Basic Training',              description: 'Play Any Mode 10 times.',   maxProgress: 10),
  played_games2(title: 'Still Learning',              description: 'Play Any Mode 20 times.',   maxProgress: 20),
  played_games3(title: "We're Just Getting Started",  description: 'Play Any Mode 50 times.',   maxProgress: 50),
  played_games4(title: 'Almost Pro',                  description: 'Play Any Mode 100 times.',  maxProgress: 100),
  played_games5(title: 'Invoker GOD!',                description: 'Play Any Mode 200 times.',  maxProgress: 200),
  timer1(title: 'Always Hard',      description: 'Reach 45 Score before time runs out in Timer mode.',  maxProgress: 45),
  timer2(title: 'Speed Freak',      description: 'Reach 60 Score before time runs out in Timer mode.',  maxProgress: 60),
  timer3(title: 'OUT OF CONTROL!',  description: 'Reach 75 Score before time runs out in Timer mode.',  maxProgress: 75),
  challenger1(title: 'Streaker',              description: 'Reach 100 points in under 3 minutes in Challenger mode.',   maxProgress: 100),
  challenger2(title: 'Must Try Harder',       description: 'Reach 120 points in under 3 minutes in Challenger mode.',   maxProgress: 120),
  challenger3(title: 'The Real CHALLENGER!',  description: 'Reach 140 points in under 3 minutes in Challenger mode.',   maxProgress: 140),
  boss1(title: 'Power of the elements', description: 'Kill 100 boss in Boss mode.', maxProgress: 100),
  boss2(title: 'Feel the power.',       description: 'Kill 300 boss in Boss mode.', maxProgress: 300),
  boss3(title: "What's next?.",         description: 'Kill 500 boss in Boss mode.', maxProgress: 500),
  misc_kill_wk(title: "King's Bane", description: "Put an end to the Wraith King's reign",      maxProgress: 1),
  misc_gold(title: 'Barely Touched', description: 'Economize your gold and amass 10,000 gold.',  maxProgress: 10000);


  const Achievements({required this.title, required this.description, required this.maxProgress});

  final String title;
  final String description;
  final int maxProgress;
}

extension AchievementExtension on Achievements {
  String get getId => this.name;
  String get getIconPath => 'assets/images/achievements/ic_${this.name}.png';
  String get getTitle => this.title;
  String get getDescription => this.description;
  int get getMaxProgress => this.maxProgress;
}
