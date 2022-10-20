import 'constants/app_strings.dart';
import 'providers/spell_provider.dart';
import 'providers/timer_provider.dart';
import 'screens/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => TimerProvider()),
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
    );
  }
}