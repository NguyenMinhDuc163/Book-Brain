import 'package:flutter/material.dart';
import 'package:book_brain/service/service_config/admob_service.dart';

class InterstitialAdWidget extends StatefulWidget {
  final Widget child;
  final int showAfterCount;

  const InterstitialAdWidget({
    Key? key,
    required this.child,
    this.showAfterCount = 3,
  }) : super(key: key);

  @override
  State<InterstitialAdWidget> createState() => _InterstitialAdWidgetState();
}

class _InterstitialAdWidgetState extends State<InterstitialAdWidget> {
  int _interactionCount = 0;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  Future<void> _loadInterstitialAd() async {
    await AdMobService().loadInterstitialAd();
  }

  void _incrementInteractionCount() {
    _interactionCount++;
    if (_interactionCount >= widget.showAfterCount) {
      _interactionCount = 0;
      AdMobService().showInterstitialAd();
      _loadInterstitialAd(); // Tải quảng cáo mới sau khi hiển thị
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _incrementInteractionCount,
      child: widget.child,
    );
  }
}
