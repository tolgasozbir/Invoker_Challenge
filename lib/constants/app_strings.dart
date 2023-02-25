class AppStrings {
  AppStrings._();
  
  static const String appName = 'Invoker Game';
  static const String appVersion = 'Beta 1.0';

  //Main menu
  static const String titleTraining = 'Training';
  static const String titleWithTimer = 'With Timer';
  static const String titleChallanger = 'Challanger';
  static const String quitGame = 'Quit Game';
  static const String settings = 'Settings';

  //Training
  static const String secPassed = 'Seconds passed';
  static const String toolTipCPS = 'Click per seconds average by elapsed time.';
  static const String cps = ' Cps';
  static const String toolTipSCPS = 'Skill cast per seconds average by elapsed time.';
  static const String scps = ' SCps';

  //Common
  static const String start = 'Start';
  static const String leaderboard = 'Leaderboard';
  static const String result = 'Result';
  static const String unNamed = 'Unnamed'; //
 
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
  static const String sbInfo = 'Info';
  static const String sbSuccess = 'Success';
  static const String sbWarning = 'Warning';
  static const String sbError = 'Error';

  static const String time = 'Time';
  static const String score = 'Score';
  static const String showMore = 'Show more';
  static const String noMoreData = 'No more data!';

  static const String trueCombinations = 'True Combinations'; //score
  static const String bestScore = 'Your best score is';
  static const String back = 'Back';
  static const String close = 'Close';
  static const String send = 'Submit';

  //Talent tree
  static const String talentTree = 'Talent Tree';
  static const String talent10 = '+2 exp multiplier';
  static const List<String> talents = const [
    '+2 exp multiplier',
    '15 Talent Tree',
    '20 Talent Tree',
    '25 Talent Tree',
  ];



  //Settings
  static const String aboutUs = 'About us';
  static const String feedback = 'Feedback';
  static const String rateApp = 'Rate this app';
  static const String volume = 'Volume';
}

//
class LottiePaths {
  static const String _root = 'assets/lottie';

  static const String lottieNoData = '$_root/lottie_no_data.json';
}

class ImagePaths {
  ImagePaths._();
  static const String _root = 'assets/images';
  static const String _splash = '$_root/splash_images';
  static const String _qweGif = '$_root/qwe_gifs';
  static const String _other = '$_root/other';
  static const String elements = '$_root/elements/';
  static const String spells = '$_root/spells/';

  //svg
  static const String _svgRoot = 'assets/svg';

  static const String svgQuas = '$_svgRoot/quas.svg';
  static const String svgWex = '$_svgRoot/wex.svg';
  static const String svgExort = '$_svgRoot/exort.svg';
  static const String svgDota2 = '$_svgRoot/dota2.svg';
  static const String svgInvoker = '$_svgRoot/invoker.svg';
  static const String svgTalentTree = '$_svgRoot/talent_tree.svg';

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
  static const String todClock = '$_other/time_of_day_clock.png';
}

class SoundPaths {
  SoundPaths._();
  static const String _root = 'sounds';
  static const String _failSounds = '$_root/fail_sounds';
  static const String _ggSounds = '$_root/gg_sounds';
  static const String _loadingSounds = '$_root/loading_sounds';
  static const String _spellSounds = '$_root/spell_sounds';
  static const String _misc = '$_root/misc';

  //misc
  static const String meepMerp = '$_misc/meep_merp.mp3';

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

}
