import 'package:dota2_invoker/screens/splashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dota 2 Invoker',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
