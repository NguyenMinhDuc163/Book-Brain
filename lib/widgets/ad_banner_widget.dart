import 'package:book_brain/service/service_config/admob_service.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({Key? key}) : super(key: key);

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  String? _errorMessage;
  bool _isBannerVisible = true;
  DateTime? _bannerHiddenTime;
  static const Duration _bannerHideDuration = Duration(minutes: 4);

  bool get _adsEnabled => LocalStorageHelper.getValue("isAds") != 'off';

  @override
  void initState() {
    super.initState();
    if (_adsEnabled) {
      _loadBannerAd();
    }
    _checkBannerVisibility();
  }

  void _checkBannerVisibility() {
    if (_bannerHiddenTime != null) {
      final now = DateTime.now();
      if (now.difference(_bannerHiddenTime!) > _bannerHideDuration) {
        setState(() {
          _isBannerVisible = true;
          _bannerHiddenTime = null;
        });
      }
    }
  }

  void _hideBannerAd() {
    setState(() {
      _isBannerVisible = false;
      _bannerHiddenTime = DateTime.now();
    });
    // Tự động hiện lại sau 10 phút
    Future.delayed(_bannerHideDuration, () {
      if (mounted) {
        setState(() {
          _isBannerVisible = true;
          _bannerHiddenTime = null;
        });
      }
    });
  }

  void _loadBannerAd() {
    _bannerAd = AdMobService().createBannerAd();
    _bannerAd
        ?.load()
        .then((_) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
              _errorMessage = null;
            });
          }
        })
        .catchError((error) {
          if (mounted) {
            setState(() {
              _errorMessage = error.toString();
            });
          }
        });
  }

  @override
  void dispose() {
    if (_adsEnabled) {
      _bannerAd?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_adsEnabled) {
      return SizedBox.shrink();
    }

    if (!_isBannerVisible) {
      return SizedBox.shrink();
    }

    if (_errorMessage != null) {
      return Container(
        height: 50,
        color: Colors.grey[200],
        child: Center(
          child: Text(
            'Không thể tải quảng cáo: $_errorMessage',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (!_isAdLoaded) {
      return Container(
        height: 50,
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          alignment: Alignment.center,
          // Keep the platform-view state tied to this exact ad instance.
          // This prevents Flutter from reusing an AdWidget state when the ad
          // is replaced during a rebuild or hot reload.
          child: AdWidget(key: ObjectKey(_bannerAd), ad: _bannerAd!),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: _hideBannerAd,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 20, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
