import 'dart:io';

class AdHelper {
  const AdHelper._();
  static AdHelper _instance = AdHelper._();
  static AdHelper get instance => _instance;

  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4671677138522189/1450770700';
    }

    if (Platform.isIOS) {
      return 'ca-app-pub-4671677138522189/8391266343';
    }

    throw new UnsupportedError("Unsupported platform");
  }

}
