class AppStrings {
  AppStrings._();
  
  static const String appName = 'Invoker Game';
  static const String appVersion = 'Beta 1.0';

  //Main menu
  static const String titleTraining = 'Training';
  static const String titleWithTimer = 'With Timer';
  static const String titleChallanger = 'Challanger';
  static const String titleBossMode = 'Boss Mode';
  static const String quitGame = 'Quit Game';
  static const String settings = 'Settings';
  static const String profile = 'Profile';
  static const String achievements = 'Achievements';

  //Common
  static const String leaderboard = 'Leaderboard';
  static const String showMore = 'Show more';
  static const String result = 'Results';
  static const String send = 'Submit';
  static const String start = 'Start';
  static const String close = 'Close';
  static const String back = 'Back';
  static const String logout = 'Logout';

  static const String time = 'Time';
  static const String score = 'Score';
  static const String bestScore = 'Best Score';
  static const String exp = 'Experience';
 
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
  static const String unlockBossModeMessage = 'You have to unlock the boss mode to enter. (Requires level 10)';
  static const String sbInfo = 'Info';
  static const String sbSuccess = 'Success';
  static const String sbError = 'Error';
  static const String sbNoMoreData = 'No more data!';
  static const String sbWaitAnimation = 'Button is inactive, it will be enabled in 3 seconds. Please wait.';

  //Talent tree
  static const String talentTree = 'Talent Tree';
  static const String talent10 = '+2 exp multiplier';
  static const talents = const [
    'Unlock Boss Mode',
    '+1 Challenger Life',
    '+2 Exp Multiplier',
    'D. Dmg to Bosses',
  ];

  //Settings
  static const String aboutMe = 'About me';
  static const String feedback = 'Feedback';
  static const String rateApp = 'Rate this app';
  static const String volume = 'Volume';

  //About me
  static const String bio = "Heyy, I'm Tolga Sözbir from Turkey. I'm a Freelance mobile developer. If you wants to contact me to build your product leave message.";
  static const String langsAndTools = 'Languages and Tools:';

  //Feedback
  static const String fbTitleFirst = 'Send me your';
  static const String fbTitleSecond = 'Feedback!';
  static const String fbMidText = 'Tell me how your experience was and let me know what I can improve.';
  static const String fbHint = 'Drop me any suggestions, questions or complaints to improve :)';
  static const String fbSendBtn = 'Send Feedback';


}

//
class LottiePaths {
  LottiePaths._();
  static const String _root = 'assets/lottie';

  static const String lottieNoData = '$_root/lottie_no_data.json';
  static const String lottieFeedback = '$_root/lottie_feedback.json';
  static const String lottieSending = '$_root/lottie_sending.json';
}

class ImagePaths {
  ImagePaths._();
  static const String _root = 'assets/images';
  static const String _splash = '$_root/splash_images';
  static const String _qweGif = '$_root/qwe_gifs';
  static const String _other = '$_root/other';
  static const String elements = '$_root/elements/';
  static const String spells = '$_root/spells/';
  static const String bosses = '$_root/bosses/';

  //svg
  static const String _svgRoot = 'assets/svg';

  static const String svgQuas = '$_svgRoot/quas.svg';
  static const String svgWex = '$_svgRoot/wex.svg';
  static const String svgExort = '$_svgRoot/exort.svg';
  static const String svgTalentTree = '$_svgRoot/talent_tree.svg';
  static const String svgDota2Logo = '$_svgRoot/dota2.svg';
  static const svgInvokerLogo = const [
    '$_svgRoot/invoker1.svg',
    '$_svgRoot/invoker2.svg',
  ];

  static const ratingFaces = const [
    '$_svgRoot/rate1.svg',
    '$_svgRoot/rate2.svg',
    '$_svgRoot/rate3.svg',
    '$_svgRoot/rate4.svg',
    '$_svgRoot/rate5.svg',
  ];

  //splash
  static const String splashImage1 = '$_splash/1.gif';
  static const String splashImage2 = '$_splash/2.jpg';
  static const String splashImage3 = '$_splash/3.jpg';
  //main menu element gifs
  static const String quas = '$_qweGif/quas.gif';
  static const String wex = '$_qweGif/wex.gif';
  static const String exort = '$_qweGif/exort.gif';  
  //other
  static const String spellImage = '$_other/quas-wex-exort.jpg';
  static const String loadingGif = '$_other/qweLoading.gif';
  static const String todClock =   '$_other/time_of_day_clock.png';
  static const String profilePic = '$_other/profile.jpeg';
  static const String icFlutter =  '$_other/ic_flutter.png';
  static const String icCsharp =   '$_other/ic_csharp.png';
  static const String icFirebase = '$_other/ic_firebase.png';
  static const String icInvokerHead = '$_other/ic_invoker_head.png';
  static const String icInvokeLine = '$_other/ic_invoke_line.png';

  static const String icAchievements = '$_root/achievements/ic_achievements.png';

}

class SoundPaths {
  SoundPaths._();
  static const String _root = 'sounds';
  static const String _failSounds = '$_root/fail_sounds';
  static const String _ggSounds = '$_root/gg_sounds';
  static const String _loadingSounds = '$_root/loading_sounds';
  static const String _spellSounds = '$_root/spell_sounds';
  static const String _castTriggerSounds = '$_spellSounds/cast_trigger_sounds';
  static const String _misc = '$_root/misc';

  //misc
  static const String meepMerp = '$_misc/meep_merp.mp3';
  static const String invoke = '$_misc/Invoke.mpeg';

  //fail sounds
  static const String fail1 = '$_failSounds/fail1.mp3';
  static const String fail2 = '$_failSounds/fail2.mp3';
  static const String fail3 = '$_failSounds/fail3.mp3';
  static const String fail4 = '$_failSounds/fail4.mp3';
  static const String fail5 = '$_failSounds/fail5.mp3';
  static const String fail6 = '$_failSounds/fail6.mp3';
  static const String fail7 = '$_failSounds/fail7.mp3';

  //gg sounds
  static const String gg1 = '$_ggSounds/gg1.mpeg';
  static const String gg2 = '$_ggSounds/gg2.mpeg';
  static const String gg3 = '$_ggSounds/gg3.mpeg';
  static const String gg4 = '$_ggSounds/gg4.mpeg';

  //loading sounds
  static const String begin1 = '$_loadingSounds/begin1.mp3';
  static const String begin2 = '$_loadingSounds/begin2.mp3';
  static const String begin3 = '$_loadingSounds/begin3.mp3';
  static const String begin4 = '$_loadingSounds/begin4.mp3';
  static const String begin5 = '$_loadingSounds/begin5.mp3';
  
  //spell sounds
  static const String alacrity1 = '$_spellSounds/alacrity1.mp3';
  static const String alacrity2 = '$_spellSounds/alacrity2.mp3';

  static const String blast1 = '$_spellSounds/blast1.mp3';
  static const String blast2 = '$_spellSounds/blast2.mp3';
  static const String blast3 = '$_spellSounds/blast3.mp3';

  static const String cold_snap1 = '$_spellSounds/cold_snap1.mp3';
  static const String cold_snap2 = '$_spellSounds/cold_snap2.mp3';
  static const String cold_snap3 = '$_spellSounds/cold_snap3.mp3';

  static const String emp1 = '$_spellSounds/emp1.mp3';
  static const String emp2 = '$_spellSounds/emp2.mp3';
  static const String emp3 = '$_spellSounds/emp3.mp3';

  static const String forge_spirit1 = '$_spellSounds/forge_spirit1.mp3';
  static const String forge_spirit2 = '$_spellSounds/forge_spirit2.mp3';

  static const String ghost_walk1 = '$_spellSounds/ghost_walk1.mp3';
  static const String ghost_walk2 = '$_spellSounds/ghost_walk2.mp3';
  static const String ghost_walk3 = '$_spellSounds/ghost_walk3.mp3';

  static const String icewall1 = '$_spellSounds/icewall1.mp3';
  static const String icewall2 = '$_spellSounds/icewall2.mp3';

  static const String meteor1 = '$_spellSounds/meteor1.mp3';
  static const String meteor2 = '$_spellSounds/meteor2.mp3';

  static const String sunstrike1 = '$_spellSounds/sunstrike1.mp3';
  static const String sunstrike2 = '$_spellSounds/sunstrike2.mp3';
  static const String sunstrike3 = '$_spellSounds/sunstrike3.mp3';

  static const String tornado1 = '$_spellSounds/tornado1.mp3';
  static const String tornado2 = '$_spellSounds/tornado2.mp3';
  static const String tornado3 = '$_spellSounds/tornado3.mp3';

  //Spell Cast and Trigger Sounds
  static const String coldSnapCast = '$_castTriggerSounds/cold_snap_cast.mpeg';
  static const String coldSnapTrigger = '$_castTriggerSounds/cold_snap_trigger.mpeg';
  static const String ghostWalkCast = '$_castTriggerSounds/ghost_walk_cast.mpeg';
  static const String iceWallCast = '$_castTriggerSounds/ice_wall_cast.mpeg';
  static const String empCast = '$_castTriggerSounds/emp_cast.mpeg';
  static const String tornadoCast = '$_castTriggerSounds/tornado_cast.mpeg';
  static const String alacrityCast = '$_castTriggerSounds/alacrity_cast.mpeg';
  static const String deafeningBlastCast = '$_castTriggerSounds/deafening_blast_cast.mpeg';
  static const String sunStrikeCast = '$_castTriggerSounds/sun_strike_cast.mpeg';
  static const String forgeSpiritCast = '$_castTriggerSounds/forge_spirit_cast.mpeg';
  static const String chaosMeteorCast = '$_castTriggerSounds/chaos_meteor_cast.mpeg';

}
