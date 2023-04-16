import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsHelper {
  AdsHelper._();
  static AdsHelper _instance = AdsHelper._();
  static AdsHelper get instance => _instance;

  bool enableAndroidTestIds = kDebugMode;

  //Ads Id's

  String get bannerAdUnitId {
    if (enableAndroidTestIds) return 'ca-app-pub-3940256099942544/6300978111';

    if (Platform.isAndroid) {
      return FlutterConfig.get("BANNER_AD_UNIT_ID_ANDROID");
    }

    if (Platform.isIOS) {
      return FlutterConfig.get("BANNER_AD_UNIT_ID_IOS");
    }

    throw new UnsupportedError("Unsupported platform");
  }
  
  String get appOpenAdUnitId {
    if (enableAndroidTestIds) return 'ca-app-pub-3940256099942544/3419835294';

    if (Platform.isAndroid) {
      return FlutterConfig.get("APP_OPEN_AD_ANDROID");
    }

    if (Platform.isIOS) {
      return FlutterConfig.get("APP_OPEN_AD_IOS");
    }

    throw new UnsupportedError("Unsupported platform");
  }
  
  String get rewardedInterstitialAdUnitId {
    if (enableAndroidTestIds) return 'ca-app-pub-3940256099942544/5354046379';

    if (Platform.isAndroid) {
      return FlutterConfig.get("REWARDED_INTERSTITIAL_AD_ANDROID");
    }

    if (Platform.isIOS) {
      return FlutterConfig.get("REWARDED_INTERSTITIAL_AD_IOS");
    }

    throw new UnsupportedError("Unsupported platform");
  }

  //AppOpenAd
  Future<void> AppOpenAdLoad() async {
    AppOpenAd? appOpenAd;
    await AppOpenAd.load(
      adUnitId: appOpenAdUnitId, 
      request: const AdRequest(), 
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          appOpenAd!.show();
        }, 
        onAdFailedToLoad: (error) => log('Ad failed to load: ' + error.message),
      ), 
      orientation: AppOpenAd.orientationPortrait
    );
  }

  //RewardedAd
  RewardedInterstitialAd? rewardedInterstitialAd;
  Future<void> rewardedInterstitialAdLoad() async {
    await RewardedInterstitialAd.load(
      adUnitId: rewardedInterstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) => rewardedInterstitialAd = ad,
        onAdFailedToLoad: (error) => log('Ad failed to load: ' + error.message),
      ),
    );
  }

}

//BANNER

class AdBanner extends StatefulWidget {
  const AdBanner({super.key, this.adSize = AdSize.banner});

  final AdSize adSize;

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  void _initBannerAd() {
    _bannerAd = BannerAd(
      size: widget.adSize, 
      adUnitId: AdsHelper.instance.bannerAdUnitId, 
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          log('Ad failed to load: ' + error.message);
        },
      ), 
      request: const AdRequest(httpTimeoutMillis: 5000)
    )..load();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initBannerAd());
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded 
      ? bannerBox(child: AdWidget(ad: _bannerAd!)) 
      : bannerBox();
  }

  SizedBox bannerBox({Widget? child}) => SizedBox(
    height: _bannerAd?.size.height.toDouble() ?? 50,
    child: child,
  );
}
