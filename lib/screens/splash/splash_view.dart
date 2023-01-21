import 'package:flutter/material.dart';
import 'splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends SplashViewModel {
  @override
  Widget build(BuildContext context) {
    return _bodyView();
  }

  Widget _bodyView() {
    return SafeArea(
      child: SizedBox.expand(
        child: Image.asset(
          getRandomSplahImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}