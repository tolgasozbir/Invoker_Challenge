import 'dart:developer';
import 'dart:io';

import 'package:dota2_invoker_game/services/user_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
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
      final adUnitId = dotenv.env[this.androidKey];
      if (adUnitId == null) {
        assert(false, 'AdUnitId is null for Android. Please check the .env file.');
        return '';
      }
      return adUnitId;
    }

    if (Platform.isIOS) {
      final adUnitId = dotenv.env[this.iosKey];
      if (adUnitId == null) {
        assert(false, 'AdUnitId is null for iOS. Please check FlutterConfig settings.');
        return '';
      }
      return adUnitId;
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
    if (UserManager.instance.user.isPremium) return; // Premium kullanıcı ise yükleme yapma

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
    if (UserManager.instance.user.isPremium) return; // Premium kullanıcı ise yükleme yapma

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
    if (UserManager.instance.user.isPremium) return; // Premium kullanıcı ise yükleme yapma

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
    if (UserManager.instance.user.isPremium) return; // Premium kullanıcı ise yükleme yapma

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
    // Premium kullanıcı ise gizle
    if (UserManager.instance.user.isPremium) {
      return const SizedBox.shrink();
    }

    return _isAdLoaded && _bannerAd != null 
      ? bannerBox(child: AdWidget(ad: _bannerAd!)) 
      : bannerBox();
  }

  SizedBox bannerBox({Widget? child}) => SizedBox(
    height: _bannerAd?.size.height.toDouble(),
    child: child,
  );
}
