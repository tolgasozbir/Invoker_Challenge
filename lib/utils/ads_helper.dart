import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsHelper {
  AdsHelper._();
  static AdsHelper _instance = AdsHelper._();
  static AdsHelper get instance => _instance;

  //Ads Id's

  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      //return 'ca-app-pub-4671677138522189/9703298269';
      return 'ca-app-pub-3940256099942544/6300978111'; //test
    }

    if (Platform.isIOS) {
      return '';
    }

    throw new UnsupportedError("Unsupported platform");
  }
  
  String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/3419835294';
    }

    if (Platform.isIOS) {
      return '';
    }

    throw new UnsupportedError("Unsupported platform");
  }
  
  String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5354046379';
    }

    if (Platform.isIOS) {
      return '';
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
      adUnitId: rewardedAdUnitId,
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
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  void _initBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner, 
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
  Widget build(BuildContext context) {
    return _isAdLoaded 
      ? bannerBox(child: AdWidget(ad: _bannerAd!)) 
      : bannerBox();
  }

  SizedBox bannerBox({Widget? child}) => SizedBox(width: 320, height: 50, child: child);
}
