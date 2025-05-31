import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdType { banner, interstitial, rewarded, appOpen }

class GoogleAdWidget extends StatefulWidget {
  final AdType adType;

  const GoogleAdWidget({super.key, required this.adType});

  @override
  State<GoogleAdWidget> createState() => _GoogleAdWidgetState();
}

class _GoogleAdWidgetState extends State<GoogleAdWidget> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  AppOpenAd? _appOpenAd;

  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    switch (widget.adType) {
      case AdType.banner:
        _loadBannerAd();
        break;
      case AdType.interstitial:
        _loadInterstitialAd();
        break;
      case AdType.rewarded:
        _loadRewardedAd();
        break;
      case AdType.appOpen:
        _loadAppOpenAd();
        break;
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.show();
        },
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAd!.show(
            onUserEarnedReward: (ad, reward) {
              debugPrint('User earned reward: ${reward.amount}');
            },
          );
        },
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  void _loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/3419835294',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAd!.show();
        },
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.adType == AdType.banner && _isBannerLoaded && _bannerAd != null) {
      return SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }

    // For non-Banner ads, return a button to trigger ad manually
    return ElevatedButton(
      onPressed: () {
        switch (widget.adType) {
          case AdType.interstitial:
            _loadInterstitialAd();
            break;
          case AdType.rewarded:
            _loadRewardedAd();
            break;
          case AdType.appOpen:
            _loadAppOpenAd();
            break;
          default:
            break;
        }
      },
      child: Text('Load ${widget.adType.name} Ad'),
    );
  }
}
