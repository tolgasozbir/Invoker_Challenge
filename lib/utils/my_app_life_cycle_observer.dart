import 'package:flutter/material.dart';

import 'ads_helper.dart';

class MyAppLifecycleObserver with WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // Uygulama tekrar ön planda
        print("Uygulama tekrar ön planda");
        break;
      case AppLifecycleState.inactive:
        // Uygulama durdu
        print("Uygulama durdu");
        break;
      case AppLifecycleState.paused:
        // Uygulama arka planda alındı
        print("Uygulama arka planda alındı");
        await AdsHelper.instance.AppOpenAdLoad();
        break;
      case AppLifecycleState.detached:
        // Uygulama tamamen durduruldu
        print("Uygulama tamamen durduruldu");
        break;
    }
  }
}
