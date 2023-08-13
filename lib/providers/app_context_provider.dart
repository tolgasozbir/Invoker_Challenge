import 'package:flutter/material.dart';

class AppContextProvider extends ChangeNotifier {
  BuildContext? appContext;

  void setAppContext(BuildContext context) {
    appContext = context;
    notifyListeners();
  }
}
