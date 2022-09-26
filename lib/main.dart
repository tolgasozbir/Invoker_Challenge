import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:dota2_invoker/providerModels/timerModel.dart';
import 'package:dota2_invoker/screens/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => TimerModel())
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
    );
  }
}