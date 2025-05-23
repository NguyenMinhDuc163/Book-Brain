import 'package:flutter/material.dart';
import 'package:book_brain/service/service_config/admob_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedInterstitialAdWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onRewarded;
  final int showAfterCount;

  const RewardedInterstitialAdWidget({
    Key? key,
    required this.child,
    required this.onRewarded,
    this.showAfterCount = 3,
  }) : super(key: key);

  @override
  State<RewardedInterstitialAdWidget> createState() =>
      _RewardedInterstitialAdWidgetState();
}

class _RewardedInterstitialAdWidgetState
    extends State<RewardedInterstitialAdWidget> {
  RewardedInterstitialAd? _rewardedInterstitialAd;
  bool _isAdLoaded = false;
  int _interactionCount = 0;

  @override
  void initState() {
    super.initState();
    _loadRewardedInterstitialAd();
  }

  Future<void> _loadRewardedInterstitialAd() async {
    try {
      print('Loading rewarded interstitial ad...');
      final adUnitId = AdMobService().getAdUnitId('rewarded_interstitial');
      print('Using ad unit ID: $adUnitId');

      await RewardedInterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            print('Rewarded Interstitial Ad loaded successfully');
            _rewardedInterstitialAd = ad;
            if (mounted) {
              setState(() {
                _isAdLoaded = true;
              });
            }
          },
          onAdFailedToLoad: (error) {
            print('Rewarded Interstitial Ad failed to load: ${error.message}');
            print('Error code: ${error.code}');
            _rewardedInterstitialAd = null;
            if (mounted) {
              setState(() {
                _isAdLoaded = false;
              });
            }
            // Thử tải lại sau 5 giây nếu thất bại
            Future.delayed(
              const Duration(seconds: 5),
              _loadRewardedInterstitialAd,
            );
          },
        ),
      );
    } catch (e) {
      print('Error loading rewarded interstitial ad: $e');
      // Thử tải lại sau 5 giây nếu có lỗi
      Future.delayed(const Duration(seconds: 5), _loadRewardedInterstitialAd);
    }
  }

  void _incrementInteractionCount() {
    _interactionCount++;
    print('Interaction count: $_interactionCount');

    if (_interactionCount >= widget.showAfterCount) {
      print('Reached interaction threshold');
      if (_isAdLoaded) {
        print('Ad is loaded, showing ad');
        _showRewardedInterstitialAd();
      } else {
        print('Ad is not loaded yet');
      }
      _interactionCount = 0;
    }
  }

  void _showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd != null) {
      print('Showing rewarded interstitial ad');
      _rewardedInterstitialAd!.show(
        onUserEarnedReward: (_, reward) {
          print(
            'User earned reward from interstitial: ${reward.amount} ${reward.type}',
          );
          widget.onRewarded();
        },
      );
      _rewardedInterstitialAd = null;
      setState(() {
        _isAdLoaded = false;
      });
      // Tải lại quảng cáo mới
      _loadRewardedInterstitialAd();
    } else {
      print('Rewarded interstitial ad is null');
    }
  }

  @override
  void dispose() {
    _rewardedInterstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print('Container tapped');
          _incrementInteractionCount();
        },
        child: widget.child,
      ),
    );
  }
}
