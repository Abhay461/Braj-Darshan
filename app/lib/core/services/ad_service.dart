import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/constants.dart';

class AdService {
  static int _templeViewCount = 0;
  static InterstitialAd? _interstitialAd;

  static Future<void> init() async {
    try {
      await MobileAds.instance.initialize();
      _loadInterstitialAd();
    } catch (e) {
      debugPrint('AdService.init error: $e');
    }
  }

  static void _loadInterstitialAd() {
    try {
      InterstitialAd.load(
        adUnitId: AppConstants.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (error) {
            debugPrint('InterstitialAd failed to load: $error');
            _interstitialAd = null;
          },
        ),
      );
    } catch (e) {
      debugPrint('AdService._loadInterstitialAd error: $e');
    }
  }

  static void incrementTempleViewAndCheckAd() {
    _templeViewCount++;
    if (_templeViewCount >= 6) {
      _templeViewCount = 0;
      if (_interstitialAd != null) {
        try {
          _interstitialAd!.show();
          _loadInterstitialAd();
        } catch (e) {
          debugPrint('AdService.showInterstitialAd error: $e');
        }
      }
    }
  }
}

