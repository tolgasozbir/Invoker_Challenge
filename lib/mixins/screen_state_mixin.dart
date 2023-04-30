import 'package:flutter/material.dart';

mixin ScreenStateMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = false;
  void changeLoadingState({bool forceUI = true}) {
    if (!mounted) return;
    isLoading = !isLoading;
    if (!forceUI) return;
    setState(() {});
  }

  void updateScreen({VoidCallback? fn}) {
    if (!mounted) return;
    setState(() => fn?.call());
  }
}
//Respect VB10
