import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/constants.dart';

class AdService {
  static int _templeViewCount = 0;
  static InterstitialAd? _interstitialAd;

  static Future<void> init() async {
    await MobileAds.instance.initialize();
    _loadInterstitialAd();
  }

  static void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AppConstants.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  // Increment view counter and show interstitial after 6 views
  static void incrementTempleViewAndCheckAd() {
    _templeViewCount++;
    if (_templeViewCount >= 6) {
      _templeViewCount = 0;
      if (_interstitialAd != null) {
        _interstitialAd!.show();
        _loadInterstitialAd();
      }
    }
  }

  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: AppConstants.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }
}
