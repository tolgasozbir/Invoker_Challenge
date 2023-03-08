import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  const AdHelper._();
  static AdHelper _instance = AdHelper._();
  static AdHelper get instance => _instance;

  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4671677138522189/9703298269';
    }

    if (Platform.isIOS) {
      return 'ca-app-pub-4671677138522189/8391266343';
    }

    throw new UnsupportedError("Unsupported platform");
  }

}

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
      adUnitId: AdHelper.instance.bannerAdUnitId, 
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() { _isAdLoaded = true; }),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          log('Ad failed to load: ' + error.message);
        },
      ), 
      request: AdRequest(httpTimeoutMillis: 5000)
    )..load();
  }

  @override
  void initState() {
    super.initState();
    //Future.microtask(() => _initBannerAd());
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded 
      ? bannerBox(child: AdWidget(ad: _bannerAd!)) 
      : bannerBox();
  }

  SizedBox bannerBox({Widget? child}) => SizedBox(width: 320, height: 50, child: child);
}
