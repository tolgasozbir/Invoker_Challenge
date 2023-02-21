import 'package:dota2_invoker/providers/user_manager.dart';
import 'package:dota2_invoker/widgets/app_dialogs.dart';

import 'services/app_services.dart';
import 'services/database/firestore_service.dart';
import 'services/firebase_auth_service.dart';
import 'services/local_storage/local_storage_service.dart';

import 'widgets/app_snackbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/app_strings.dart';
import 'providers/game_provider.dart';
import 'providers/spell_provider.dart';
import 'screens/splash/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  await AppServices.instance.initServices(
    databaseService: FirestoreService.instance, 
    localStorageService: LocalStorageService.instance,
    firebaseAuthService: FirebaseAuthService.instance,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => GameProvider()),
      ChangeNotifierProvider(create: (context) => SpellProvider()),
      ChangeNotifierProvider(create: (context) => UserManager.instance),
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
