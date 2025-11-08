import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../constants/app_strings.dart';

enum RemoteConfigKeys {
  app_version(value: AppStrings.appVersion),
  force_update(value: false);

  const RemoteConfigKeys({required this.value});
  final dynamic value;
}

class FirebaseRemoteConfigService {
  FirebaseRemoteConfigService._();

  static final FirebaseRemoteConfigService _instance = FirebaseRemoteConfigService._();
  static FirebaseRemoteConfigService get instance => _instance;

  final _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initConfigs() async {
    await _setConfigSettings();
    await _setDefaultSettings();
    await _fetchAndActivate();
  }

  Future<void> _setConfigSettings() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1), 
        minimumFetchInterval: const Duration(hours: 12),
      ),
    );
  }

  Future<void> _setDefaultSettings() async {
    await _remoteConfig.setDefaults(
      {
        RemoteConfigKeys.app_version.name : RemoteConfigKeys.app_version.value as String,
        RemoteConfigKeys.force_update.name : RemoteConfigKeys.force_update.value as bool,
      }
    );
  }

  Future<void> _fetchAndActivate() async {
    try {
      final updated = await _remoteConfig.fetchAndActivate();
      if (updated) {
        log('The config has been updated.');
      } else {
        log('The config is not updated..');
      }
    } catch (e) {
      log('err _fetchAndActivate() $e');
    }
  }

  T getRemoteConfigValue<T>(RemoteConfigKeys key) {
    try {
      if (T == String) {
        return _remoteConfig.getString(key.name) as T;
      } else if (T == bool) {
        return _remoteConfig.getBool(key.name) as T;
      } else if (T == int) {
        return _remoteConfig.getInt(key.name) as T;
      } else if (T == double) {
        return _remoteConfig.getDouble(key.name) as T;
      } else {
        throw Exception('Unsupported type');
      }
    } catch (e) {
      throw Exception('Error fetching config for key: ${key.name}');
    }
  }

}
