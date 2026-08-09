import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/config/constants.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    try {
      _bannerAd = BannerAd(
        adUnitId: AppConstants.bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (mounted) {
              setState(() {
                _isAdLoaded = true;
                _hasError = false;
              });
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (mounted) {
              setState(() {
                _isAdLoaded = false;
                _hasError = true;
                _bannerAd = null;
              });
            }
          },
        ),
      );
      _bannerAd?.load();
    } catch (e) {
      debugPrint('AdBannerWidget._loadAd error: $e');
      if (mounted) {
        setState(() {
          _isAdLoaded = false;
          _hasError = true;
          _bannerAd = null;
        });
      }
    }
  }

  @override
  void dispose() {
    try {
      _bannerAd?.dispose();
    } catch (e) {
      debugPrint('AdBannerWidget.dispose error: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || !_isAdLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: KeyedSubtree(
        key: ValueKey(_bannerAd.hashCode),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
