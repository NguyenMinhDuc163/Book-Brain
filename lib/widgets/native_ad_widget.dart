import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:book_brain/service/service_config/admob_service.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({Key? key}) : super(key: key);

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;
  bool _isAdVisible = true;
  DateTime? _adHiddenTime;
  static const Duration _adHideDuration = Duration(minutes: 4);

  @override
  void initState() {
    super.initState();
    String isAds = LocalStorageHelper.getValue("isAds");
    if(isAds == 'off'){
      _loadNativeAd();
    }
    _checkAdVisibility();
  }

  void _checkAdVisibility() {
    if (_adHiddenTime != null) {
      final now = DateTime.now();
      if (now.difference(_adHiddenTime!) > _adHideDuration) {
        setState(() {
          _isAdVisible = true;
          _adHiddenTime = null;
        });
      }
    }
  }

  void _hideAd() {
    setState(() {
      _isAdVisible = false;
      _adHiddenTime = DateTime.now();
    });
    // Tự động hiện lại sau 10 phút
    Future.delayed(_adHideDuration, () {
      if (mounted) {
        setState(() {
          _isAdVisible = true;
          _adHiddenTime = null;
        });
      }
    });
  }

  Future<void> _loadNativeAd() async {
    try {
      _nativeAd = NativeAd(
        adUnitId: AdMobService().getAdUnitId('native'),
        factoryId: 'listTile',
        listener: NativeAdListener(
          onAdLoaded: (_) {
            print('Native Ad loaded successfully');
            if (mounted) {
              setState(() {
                _isAdLoaded = true;
              });
            }
          },
          onAdFailedToLoad: (ad, error) {
            print('Native Ad failed to load: ${error.message}');
            ad.dispose();
            _nativeAd = null;
            if (mounted) {
              setState(() {
                _isAdLoaded = false;
              });
            }
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle: NativeTemplateStyle(
          templateType: TemplateType.medium,
          mainBackgroundColor: Colors.white,
          callToActionTextStyle: NativeTemplateTextStyle(
            textColor: Colors.white,
            backgroundColor: Colors.blue,
          ),
          primaryTextStyle: NativeTemplateTextStyle(
            textColor: Colors.black,
            backgroundColor: Colors.transparent,
          ),
          secondaryTextStyle: NativeTemplateTextStyle(
            textColor: Colors.grey,
            backgroundColor: Colors.transparent,
          ),
          tertiaryTextStyle: NativeTemplateTextStyle(
            textColor: Colors.grey,
            backgroundColor: Colors.transparent,
          ),
        ),
      );

      await _nativeAd!.load();
    } catch (e) {
      print('Error loading native ad: $e');
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String isAds = LocalStorageHelper.getValue("isAds");
    if(isAds == 'off'){
      return SizedBox.shrink();
    }

    if (!_isAdVisible || !_isAdLoaded) {
      return const SizedBox.shrink();
    }

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: 120,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: AdWidget(ad: _nativeAd!),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: _hideAd,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 16, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
