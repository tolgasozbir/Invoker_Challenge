enum Achievements {
  level1,
  level2,
  level3,
  level4,
  level5,
  played_games1,
  played_games2,
  played_games3,
  played_games4,
  played_games5,
  timer1,
  timer2,
  timer3,
  challenger1,
  challenger2,
  challenger3,
}

extension achievementExtension on Achievements {
  String get getId => this.name;
  String get getIconPath => "assets/images/achievements/ic_${this.name}.png";
}