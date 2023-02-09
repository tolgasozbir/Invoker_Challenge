import 'package:dota2_invoker/widgets/app_snackbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/app_strings.dart';
import 'providers/game_provider.dart';
import 'providers/spell_provider.dart';
import 'screens/splash/splash_view.dart';
import 'services/database/firestore_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => GameProvider(databaseService: FirestoreService.instance)),
      ChangeNotifierProvider(create: (context) => SpellProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: ThemeData.dark(),
      home: SplashView(),
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: AppSnackBar.scaffoldMessengerKey,
    );
  }
}