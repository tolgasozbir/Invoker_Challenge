import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdUnit {
  banner(
    androidKey: 'BANNER_AD_UNIT_ID_ANDROID',
    iosKey: 'BANNER_AD_UNIT_ID_IOS',
    testId: 'ca-app-pub-3940256099942544/6300978111',
  ),
  appOpen(
    androidKey: 'APP_OPEN_AD_ANDROID',
    iosKey: 'APP_OPEN_AD_IOS',
    testId: 'ca-app-pub-3940256099942544/9257395921',
  ),
  interstitial(
    androidKey: 'INTERSTITIAL_AD_ANDROID',
    iosKey: 'INTERSTITIAL_AD_IOS',
    testId: 'ca-app-pub-3940256099942544/8691691433',
  ),
  rewarded(
    androidKey: 'REWARDED_AD_ANDROID',
    iosKey: 'REWARDED_AD_IOS',
    testId: 'ca-app-pub-3940256099942544/5224354917',
  );

  final String androidKey;
  final String iosKey;
  final String testId;

  const AdUnit({
    required this.androidKey, 
    required this.iosKey, 
    required this.testId,
  });

  String get getAdUnitId {
    if (kDebugMode) return this.testId;

    if (Platform.isAndroid) {
      return FlutterConfig.get(this.androidKey) as String;
    }

    if (Platform.isIOS) {
      return FlutterConfig.get(this.iosKey) as String;
    }

    throw UnsupportedError('Unsupported platform');
  }
}

class AdsHelper {
  AdsHelper._();
  static final AdsHelper instance = AdsHelper._();

  int menuAdCounter = 0; // Menü butonlarına her (X). tıkladığında geçiş reklamı gösterimi için kullanılır.
  int shopEntryAdCounter = 0; // Boss battle modunda shop'a girdiğinde her (X). girişte reklam gösterimi için kullanılır.

  //AppOpenAd
  Future<void> appOpenAdLoad() async {
    AppOpenAd? appOpenAd;
    await AppOpenAd.load(
      adUnitId: AdUnit.appOpen.getAdUnitId, 
      request: const AdRequest(), 
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          appOpenAd!.show();
        }, 
        onAdFailedToLoad: (error) => log('(AppOpenAd) Ad failed to load: ${error.message}'),
      ),
    );
  }

  //InterstitialAd
  InterstitialAd? interstitialAd;
  Future<void> interstitialAdLoad() async {
    await InterstitialAd.load(
      adUnitId: AdUnit.interstitial.getAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              interstitialAdLoad();
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              interstitialAdLoad();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              interstitialAdLoad();
            },
          );
        },
        onAdFailedToLoad: (error) => log('(InterstitialAd) Ad failed to load: ${error.message}'),
      ),
    );
  }

  //RewardedAd
  RewardedAd? rewardedAd;
  Future<void> rewardedAdLoad() async {
    await RewardedAd.load(
      adUnitId: AdUnit.rewarded.getAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              rewardedAdLoad();
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              rewardedAdLoad();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              rewardedAdLoad();
            },
          );
        },
        onAdFailedToLoad: (error) => log('(RewardedAd) Ad failed to load: ${error.message}'),
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
      adUnitId: AdUnit.banner.getAdUnitId, 
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          log('(BannerAd) Ad failed to load: ${error.message}');
        },
      ), 
      request: const AdRequest(httpTimeoutMillis: 5000),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_initBannerAd);
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
    height: _bannerAd?.size.height.toDouble(),
    child: child,
  );
}
