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

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
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
    if (!_isAdLoaded) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: AdWidget(ad: _nativeAd!),
    );
  }
}
