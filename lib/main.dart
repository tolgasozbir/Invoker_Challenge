import 'dart:async';

import 'package:dota2_invoker_game/providers/app_context_provider.dart';
import 'package:dota2_invoker_game/services/config/remote_config_service.dart';
import 'package:dota2_invoker_game/utils/ads_helper.dart';
import 'package:dota2_invoker_game/utils/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'constants/app_strings.dart';
import 'firebase_options.dart';
import 'providers/boss_battle_provider.dart';
import 'providers/game_provider.dart';
import 'providers/spell_provider.dart';
import 'screens/splash/splash_view.dart';
import 'services/app_services.dart';
import 'services/auth/firebase_auth_service.dart';
import 'services/database/firestore_service.dart';
import 'services/local_storage/local_storage_service.dart';
import 'services/user_manager.dart';
import 'widgets/app_dialogs.dart';
import 'widgets/app_snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Localization
  await EasyLocalization.ensureInitialized();
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
  //Remote config
  await FirebaseRemoteConfigService.instance.initConfigs();
  //Providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(create: (context) => SpellProvider()),
        ChangeNotifierProvider(create: (context) => UserManager.instance),
        ChangeNotifierProvider(create: (context) => BossBattleProvider()),
        ChangeNotifierProvider(create: (context) => AppContextProvider()),
      ],
      child: LocalizationManager(
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late StreamSubscription<FGBGType> subscription;

  @override
  void initState() {
    super.initState();
    subscription = FGBGEvents.instance.stream.listen((event) async {
      if (event == FGBGType.foreground) {
        await AdsHelper.instance.appOpenAdLoad();
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: ThemeData.dark(useMaterial3: false),
      navigatorKey: AppDialogs.navigatorKey,
      scaffoldMessengerKey: AppSnackBar.scaffoldMessengerKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const SplashView(),
    );
  }
}
