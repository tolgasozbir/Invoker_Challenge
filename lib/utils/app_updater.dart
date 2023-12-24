import 'dart:developer';
import 'package:dota2_invoker_game/constants/app_strings.dart';
import 'package:tuple/tuple.dart';
import '../services/config/remote_config_service.dart';

class AppUpdater {
  AppUpdater._();

  static final AppUpdater _instance = AppUpdater._();
  static AppUpdater get instance => _instance;

  Tuple2<bool, bool> checkUpdate() {
    final appVersionStr = FirebaseRemoteConfigService.instance.getRemoteConfigValue<String>(RemoteConfigKeys.app_version);
    final forceUpdate = FirebaseRemoteConfigService.instance.getRemoteConfigValue<bool>(RemoteConfigKeys.force_update);
    
    final deviceVersion = v2i(AppStrings.appVersion);
    final currentVersion = v2i(appVersionStr);

    if (deviceVersion == null || currentVersion == null) {
      log('Invalid version number or version conversion error');
      return const Tuple2(false, false);
    }

    final hasUpdate = deviceVersion < currentVersion;
    
    return Tuple2(hasUpdate, forceUpdate);
  }

  ///version to integer
  int? v2i(String version) {
    final cleanedVersion = version.replaceAll('.', '');
    return int.tryParse(cleanedVersion);
  }
  
}
