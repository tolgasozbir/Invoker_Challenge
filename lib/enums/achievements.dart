//TODO: DİL

enum Achievements {
  level1(title: 'Good Knowledge',       description: 'Reach 10 level.',   maxProgress: 10),
  level2(title: 'Second Chance',        description: 'Reach 15 level.',   maxProgress: 15),
  level3(title: 'THE “NEW YOU”',        description: 'Reach 20 level.',   maxProgress: 20),
  level4(title: 'Near The End',         description: 'Reach 25 level.',   maxProgress: 25),
  level5(title: 'Welcome To The Limit', description: 'Reach 30 level.',   maxProgress: 30),

  played_games1(title: 'Basic Training',              description: 'Play Any Mode 25 times.',   maxProgress: 25),
  played_games2(title: 'Still Learning',              description: 'Play Any Mode 50 times.',   maxProgress: 50),
  played_games3(title: "We're Just Getting Started",  description: 'Play Any Mode 75 times.',   maxProgress: 75),
  played_games4(title: 'Almost Pro',                  description: 'Play Any Mode 100 times.',  maxProgress: 100),
  played_games5(title: 'Invoker GOD!',                description: 'Play Any Mode 200 times.',  maxProgress: 200),

  timer1(title: 'Always Hard',      description: 'Reach 45 Score before time runs out in Timer mode.',  maxProgress: 45),
  timer2(title: 'Speed Freak',      description: 'Reach 60 Score before time runs out in Timer mode.',  maxProgress: 60),
  timer3(title: 'OUT OF CONTROL!',  description: 'Reach 75 Score before time runs out in Timer mode.',  maxProgress: 75),

  challenger1(title: 'Streaker',              description: 'Reach 100 points in under 3 minutes in Challenger mode.',   maxProgress: 100),
  challenger2(title: 'Must Try Harder',       description: 'Reach 120 points in under 3 minutes in Challenger mode.',   maxProgress: 120),
  challenger3(title: 'The Real CHALLENGER!',  description: 'Reach 140 points in under 3 minutes in Challenger mode.',   maxProgress: 140),
  
  combo1(title: 'Combo Dominator',      description: 'Reach 20 points in combo mode.', maxProgress: 20),
  combo2(title: 'Swift Striker',        description: 'Reach 30 points in combo mode.', maxProgress: 30),
  combo3(title: 'Flawless Annihilator', description: 'Reach 40 points in combo mode.', maxProgress: 40),

  boss1(title: 'Power of the elements', description: 'Kill 100 boss in Boss mode.', maxProgress: 100),
  boss2(title: 'Feel the power.',       description: 'Kill 300 boss in Boss mode.', maxProgress: 300),
  boss3(title: "What's next?.",         description: 'Kill 500 boss in Boss mode.', maxProgress: 500),

  //TODO: 2

  kill_warlock(title: 'Breaker of Pacts', description: 'Destroy the Warlock and sever his ties with the infernal realms.', maxProgress: 1),
  kill_omniknight(title: 'Fallen Paladin', description: 'Bring the holy knight to his knees and scatter his divine light.', maxProgress: 1),
  kill_riki(title: 'Echoes of the Shadow', description: 'Banish Riki to the void and silence the whispers of the unseen.', maxProgress: 1),
  kill_huskar(title: 'Ashes of Valor', description: "Reduce Huskar's blazing resolve to ashes", maxProgress: 1),
  kill_templar(title: 'Secrets Unveiled', description: 'Tear through the veil of secrecy and expose the true face of the Templar Assassin.', maxProgress: 1),
  kill_anti_mage(title: "Mage's Revenge", description: 'Prove that magic cannot be silenced by defeating the Anti-Mage.', maxProgress: 1),
  kill_juggernaut(title: "Blademaster's Demise", description: "Stand victorious against Juggernaut's unstoppable blade dance", maxProgress: 1),
  kill_blood_seeker(title: 'The End of Thirst', description: "Put an end to Bloodseeker's insatiable bloodlust.", maxProgress: 1),
  kill_drow_ranger(title: 'Frostfall', description: 'Shatter the icy precision of Drow Ranger and end her frozen reign.', maxProgress: 1),
  kill_axe(title: 'Iron Will Broken', description: "Crush Axe's unyielding spirit and silence his battle cry.", maxProgress: 1),
  kill_pudge(title: "Butcher's End", description: "Escape the grip of Pudge's hooks and stop his gruesome feast.", maxProgress: 1),
  kill_wraith_king(title: 'The Crown’s End', description: "Destroy the Wraith King's immortality and end his reign over both life and death.", maxProgress: 1),
  kill_all_bosses(title: 'The Apex Challenger', description: 'Conquer all bosses and prove yourself as the ultimate hero.', maxProgress: 1),

  misc_kill_wk(title: "King's Bane", description: "Put an end to the Wraith King's reign",      maxProgress: 1), //kalktı değiştir
  misc_gold(title: 'Barely Touched', description: 'Economize your gold and amass 10,000 gold.',  maxProgress: 10000);

  //kill_warlock
  //kill_omniknight
  //kill_riki
  //kill_huskar
  //kill_templar
  //kill_anti_mage
  //kill_juggernaut
  //kill_blood_seeker
  //kill_drow_ranger
  //kill_axe
  //kill_pudge // pudge yenilgisine hook takılma sesi ve freshmeat ekle
  //kill_wraith_king
  //kill_all_bosses


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
