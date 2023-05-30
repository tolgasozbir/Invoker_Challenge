import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'constants/app_strings.dart';
import 'firebase_options.dart';
import 'providers/boss_battle_provider.dart';
import 'providers/game_provider.dart';
import 'providers/spell_provider.dart';
import 'providers/user_manager.dart';
import 'screens/splash/splash_view.dart';
import 'services/app_services.dart';
import 'services/database/firestore_service.dart';
import 'services/auth/firebase_auth_service.dart';
import 'services/local_storage/local_storage_service.dart';
import 'utils/my_app_life_cycle_observer.dart';
import 'widgets/app_dialogs.dart';
import 'widgets/app_snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //App state observer
  final observer = MyAppLifecycleObserver();
  WidgetsBinding.instance.addObserver(observer);
  //Environment variables
  await FlutterConfig.loadEnvVariables();
  //Ads
  await MobileAds.instance.initialize();
  //Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //App orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //Services
  await AppServices.instance.initServices(
    databaseService: FirestoreService.instance, 
    localStorageService: LocalStorageService.instance,
    firebaseAuthService: FirebaseAuthService.instance,
  );
  //Providers
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => GameProvider()),
      ChangeNotifierProvider(create: (context) => SpellProvider()),
      ChangeNotifierProvider(create: (context) => UserManager.instance),
      ChangeNotifierProvider(create: (context) => BossBattleProvider()),
    ],
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: ThemeData.dark(),
      home: const SplashView(),
      navigatorKey: AppDialogs.navigatorKey,
      scaffoldMessengerKey: AppSnackBar.scaffoldMessengerKey,
    );
  }
}
