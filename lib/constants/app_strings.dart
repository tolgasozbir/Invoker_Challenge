class AppStrings {
  const AppStrings._();
  
  static const String appName = 'Invoker Challenge';
  static const String appVersion = 'Beta 0.0.5+8';

  //Main menu
  static const String titleTraining = 'Training / Endless';
  static const String titleWithTimer = 'Time Trial';
  static const String titleChallenger = 'Challenger';
  static const String titleCombo = 'Combo';
  static const String titleBossMode = 'Boss Battle';
  static const String quitGame = 'Quit Game';
  static const String settings = 'Settings';
  static const String profile = 'Profile';
  static const String achievements = 'Achievements';
  static const String bossGallery = ' Boss Gallery ';
  static const String level = 'Level';

  //Loading
  static const List<String> messageList = [
    'Remember, as you level up, your damage, spell damage, mana, and mana regeneration also increase, making it easier for you to defeat bosses. To level up, you can play timer, challenger, and boss modes.',
    "Your data is saved on your device, don't forget to synchronize it from the profile menu to avoid losing your data.",
  ];

  //Common
  static const String leaderboard = 'Leaderboard';
  static const String showMore = 'Show more';
  static const String result = 'Results';
  static const String stageResults = 'Stage Summary';
  static const String send = 'Submit';
  static const String start = 'Start';
  static const String close = 'Close';
  static const String back = 'Back';
  static const String logout = 'Logout';
  static const String victory = 'Victory';
  static const String defeated = 'Defeated';
  static const String last = '(Last) ';
  static const String time = 'Time';
  static const String score = 'Score';
  static const String bestScore = 'Best Score';
  static const String bestScoreByKill = 'Your best score by kill time';
  static const String exp = 'Experience';
  static const String syncData = 'Synchronize and store the data';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String loadGame = 'Load Game';
  static const String nextBoss = 'Next Boss';
  static const String items = 'Items';
  
  //Form-Dialog
  static const String guest = 'Guest';
  static const String eMail = 'Email';
  static const String eMailHint = 'fakeKuroKy@xyz.com';
  static const String username = 'Username';
  static const String usernameHint = 'KuroKy';
  static const String password = 'Password';
  static const String login = 'Login';
  static const String or = '-OR-';
  static const String register = 'Register';
  static const String resetPw = 'Reset your password!';
  static const String reset = 'Reset';

  //Input Validation
  static const String cannotEmpty = 'Cannot be empty';
  static const String invalidMail = 'Invalid email';
  static const String invalidPass = 'Must be at least 6 characters';

  //Snackbar messages
  static const String fillFields = 'Please fill out all required fields';
  static const String errorMessage = 'Something went wrong!';
  static const String errorConnection = 'Check your internet connection and try again.';
  static const String errorSubmitScore1 = 'You must be logged in to submit your score.';
  static const String errorSubmitScore2 = 'To submit your score, you need to beat your previous score.';
  static const String succesSubmitScore = 'Your score has been sent successfully.';
  static const String feedbackInfoMessage = 'Your message must be at least 10 characters.';
  static const String feedbackSuccessMessage = 'Thank you! your feedback will help me improve your experience.';
  static const String qwerHudInfoMessage1 = 'Adjusts the height of the quas, wex, exort, and invoke buttons.';
  static const String qwerHudInfoMessage2 = 'The higher it is, the closer it is to the bottom.';
  static const String syncDataSuccess = 'Your data has been successfully saved.';
  static const String syncDataWait = 'You can perform synchronization every 5 minutes.';
  static const String sbInfo = 'Info';
  static const String sbSuccess = 'Success';
  static const String sbError = 'Error';
  static const String sbNoMoreData = 'No more data!';
  static const String sbWaitAnimation = 'Button is inactive, it will be enabled in 5 seconds. Please wait.';
  static const String sbInventoryFull = 'Inventory is full!';
  static const String sbNotEnoughGold = 'Not enough gold';
  static const String sbCannotFetchMore = 'Cannot show more data';
  static const String sbGameSaved = 'Game saved';
  static const String sbResetPw = 'A password reset request has been sent to your email. Please check your email.';

  //Talent tree
  static const String talentTree = 'Talent Tree';
  static const talents = [
    '+400 Mana in Boss Battle',
    '+1 Challenger Life',
    '+2 Exp Multiplier',
    'D. Dmg to Bosses',
  ];

  //Settings
  static const String feedback = 'Feedback';
  static const String rateApp = 'Rate this app';
  static const String volume = 'Volume';

  //Feedback
  static const String fbTitleFirst = 'Send me your';
  static const String fbTitleSecond = 'Feedback!';
  static const String fbMidText = 'Tell me how your experience was and let me know what I can improve.';
  static const String fbHint = 'Drop me any suggestions, questions or complaints to improve :)';
  static const String fbSendBtn = 'Send Feedback';

  //Boss Battle Info
  static const String aboutTheGame = 'About the game.';
  static const String spellDamageSheet = 'Spell Damage Sheets';
  static const String note = 'Note: Each level increases the spell damage by 2%.';
  static const String circlesMeaning = 'Meaning of Circles';
  static const String outerCircleInfo = "The outer circle represents the boss's health.";
  static const String middleCircleInfo = 'The middle circle represents the number of rounds.';
  static const String innerCircleInfo = 'The inner circle represents the passage of time.';
  static const String roundInfo = 'Each round is 180 seconds long.';
  static const String spell = 'Spell';
  static const String dps = 'DPS';
  static const String duration = 'Duration';
  static const String totalBaseDamage = 'Total Base Damage';
  static const String currentTotalDamage = 'Current Total Damage';

  //LeaderBoard
  static const String boss = 'Boss';
  static const String elapsedTime = 'Elapsed Time';
  static const String second = 'Sec';
  static const String remainingHp = 'Remaining HP';
  static const String AverageDps5Sec = 'Average DPS (Last 5 Sec)';
  static const String AverageDps = 'Average DPS';
  static const String maxDps = 'Max DPS';
  static const String physicalDmg = 'Physical Damage';
  static const String magicalDmg = 'Magical Damage';
  static const String earnedExp = 'Earned Exp';
  static const String earnedGold = 'Earned Gold';


}
