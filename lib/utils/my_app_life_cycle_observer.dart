import 'dart:developer';

import 'package:flutter/material.dart';

import 'ads_helper.dart';

class MyAppLifecycleObserver with WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // Uygulama tekrar ön planda
        log('Uygulama tekrar ön planda');
        break;
      case AppLifecycleState.inactive:
        // Uygulama durdu
        log('Uygulama durdu');
        break;
      case AppLifecycleState.paused:
        // Uygulama arka planda alındı
        log('Uygulama arka planda alındı');
        await AdsHelper.instance.appOpenAdLoad();
        break;
      case AppLifecycleState.detached:
        // Uygulama tamamen durduruldu
        log('Uygulama tamamen durduruldu');
        break;
    }
  }
}
