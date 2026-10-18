import 'dart:developer';

import 'package:tuple/tuple.dart';

import '../constants/app_strings.dart';
import '../services/config/remote_config_service.dart';

class AppUpdater {
  AppUpdater._();

  static final AppUpdater _instance = AppUpdater._();
  static AppUpdater get instance => _instance;

  Tuple2<bool, bool> checkUpdate() {
    final appVersionStr = FirebaseRemoteConfigService.instance.getRemoteConfigValue<String>(RemoteConfigKeys.app_version);
    final forceUpdate = FirebaseRemoteConfigService.instance.getRemoteConfigValue<bool>(RemoteConfigKeys.force_update);
    
    final deviceVersion = _parseVersion(AppStrings.appVersion);
    final currentVersion = _parseVersion(appVersionStr);

    if (deviceVersion == null || currentVersion == null) {
      log('Invalid version number or version conversion error');
      return const Tuple2(false, false);
    }

    final hasUpdate = _compareVersions(deviceVersion, currentVersion) < 0;

    return Tuple2(hasUpdate, forceUpdate);
  }

  /// "2.10.0" → [2, 10, 0]. Noktaları silip birleştirmek 2.10.0'ı 3.0.0'dan büyük sayıyordu.
  List<int>? _parseVersion(String version) {
    final parts = version.trim().split('+').first.split('.');
    final numbers = parts.map(int.tryParse).toList();
    if (numbers.isEmpty || numbers.contains(null)) return null;
    return numbers.cast<int>();
  }

  /// Ana, ara ve küçük numarayı sırayla karşılaştırır; eksik parçalar 0 sayılır.
  int _compareVersions(List<int> a, List<int> b) {
    final length = a.length > b.length ? a.length : b.length;
    for (var i = 0; i < length; i++) {
      final x = i < a.length ? a[i] : 0;
      final y = i < b.length ? b[i] : 0;
      if (x != y) return x.compareTo(y);
    }
    return 0;
  }

}
