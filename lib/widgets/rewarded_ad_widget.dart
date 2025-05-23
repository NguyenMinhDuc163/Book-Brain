import 'package:flutter/material.dart';
import 'package:book_brain/service/service_config/admob_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onRewarded;
  final String buttonText;

  const RewardedAdWidget({
    Key? key,
    required this.child,
    required this.onRewarded,
    this.buttonText = 'Xem quảng cáo',
  }) : super(key: key);

  @override
  State<RewardedAdWidget> createState() => _RewardedAdWidgetState();
}

class _RewardedAdWidgetState extends State<RewardedAdWidget> {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  Future<void> _loadRewardedAd() async {
    try {
      await RewardedAd.load(
        adUnitId: AdMobService().getAdUnitId('rewarded'),
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            print('Rewarded Ad loaded successfully');
            _rewardedAd = ad;
            if (mounted) {
              setState(() {
                _isAdLoaded = true;
              });
            }
          },
          onAdFailedToLoad: (error) {
            print('Rewarded Ad failed to load: ${error.message}');
            _rewardedAd = null;
            if (mounted) {
              setState(() {
                _isAdLoaded = false;
              });
            }
          },
        ),
      );
    } catch (e) {
      print('Error loading rewarded ad: $e');
    }
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (_, reward) {
          print('User earned reward: ${reward.amount} ${reward.type}');
          widget.onRewarded();
        },
      );
      _rewardedAd = null;
      setState(() {
        _isAdLoaded = false;
      });
      // Tải lại quảng cáo mới
      _loadRewardedAd();
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.child,
        if (_isAdLoaded)
          ElevatedButton(
            onPressed: _showRewardedAd,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(widget.buttonText),
          ),
      ],
    );
  }
}
