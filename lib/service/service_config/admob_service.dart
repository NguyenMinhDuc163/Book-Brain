import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  // App ID của ứng dụng
  static const String _appId = 'ca-app-pub-4649011658078977~9956099225';

  // ID quảng cáo test cho môi trường phát triển
  static const Map<String, String> _testAdUnitIds = {
    'banner': 'ca-app-pub-3940256099942544/6300978111', // Test Banner ID
    'interstitial':
        'ca-app-pub-3940256099942544/1033173712', // Test Interstitial ID
    'rewarded': 'ca-app-pub-3940256099942544/5224354917', // Test Rewarded ID
    'rewarded_interstitial':
        'ca-app-pub-3940256099942544/5354046379', // Test Rewarded Interstitial ID
    'native': 'ca-app-pub-3940256099942544/2247696110', // Test Native ID
    'app_open': 'ca-app-pub-3940256099942544/3419835294', // Test App Open ID
  };

  // ID quảng cáo thật cho môi trường production
  static const Map<String, String> _productionAdUnitIds = {
    'banner': 'ca-app-pub-4649011658078977/9470907708',
    'interstitial': 'ca-app-pub-4649011658078977/2972560925',
    'rewarded': 'ca-app-pub-4649011658078977/1060713457',
    'rewarded_interstitial': 'ca-app-pub-4649011658078977/1970470448',
    'native': 'ca-app-pub-4649011658078977/7594332217',
    'app_open': 'ca-app-pub-4649011658078977/2465294465',
  };

  // Chọn môi trường (true = production, false = test)
  bool _isProduction = false; // Chuyển về production để kiếm tiền

  // Lấy ID quảng cáo dựa trên môi trường
  String _getAdUnitId(String type) {
    return _isProduction
        ? _productionAdUnitIds[type] ?? ''
        : _testAdUnitIds[type] ?? '';
  }

  // Phương thức public để lấy ID quảng cáo
  String getAdUnitId(String type) {
    return _getAdUnitId(type);
  }

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  NativeAd? _nativeAd;
  AppOpenAd? _appOpenAd;
  bool _isInitialized = false;
  bool _isShowingAd = false;
  DateTime? _lastAdShownTime;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Khởi tạo MobileAds
      await MobileAds.instance.initialize();

      // Cấu hình test device
      MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: ['EMULATOR']),
      );

      // Tải sẵn quảng cáo
      await Future.wait([
        loadInterstitialAd(),
        loadRewardedAd(),
        loadNativeAd(),
        loadAppOpenAd(),
      ]);

      _isInitialized = true;
      print('AdMob initialized successfully');
    } catch (e) {
      print('Failed to initialize AdMob: $e');
    }
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: _getAdUnitId('banner'),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print('Banner Ad loaded successfully');
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner Ad failed to load: ${error.message}');
          ad.dispose();
        },
      ),
    );
  }

  Future<void> loadInterstitialAd() async {
    try {
      await InterstitialAd.load(
        adUnitId: _getAdUnitId('interstitial'),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            print('Interstitial Ad loaded successfully');
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (error) {
            print('Interstitial Ad failed to load: ${error.message}');
            _interstitialAd = null;
          },
        ),
      );
    } catch (e) {
      print('Error loading interstitial ad: $e');
    }
  }

  Future<void> loadRewardedAd() async {
    try {
      await RewardedAd.load(
        adUnitId: _getAdUnitId('rewarded'),
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            print('Rewarded Ad loaded successfully');
            _rewardedAd = ad;
          },
          onAdFailedToLoad: (error) {
            print('Rewarded Ad failed to load: ${error.message}');
            _rewardedAd = null;
          },
        ),
      );
    } catch (e) {
      print('Error loading rewarded ad: $e');
    }
  }

  Future<void> loadNativeAd() async {
    try {
      _nativeAd = NativeAd(
        adUnitId: _getAdUnitId('native'),
        factoryId: 'listTile',
        listener: NativeAdListener(
          onAdLoaded: (_) {
            print('Native Ad loaded successfully');
          },
          onAdFailedToLoad: (ad, error) {
            print('Native Ad failed to load: ${error.message}');
            ad.dispose();
            _nativeAd = null;
          },
        ),
        request: const AdRequest(),
      );

      await _nativeAd!.load();
    } catch (e) {
      print('Error loading native ad: $e');
    }
  }

  Future<void> loadAppOpenAd() async {
    try {
      await AppOpenAd.load(
        adUnitId: _getAdUnitId('app_open'),
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            print('App Open Ad loaded successfully');
            _appOpenAd = ad;
            _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                print('App Open Ad showed full screen content');
                _isShowingAd = true;
              },
              onAdDismissedFullScreenContent: (ad) {
                print('App Open Ad dismissed full screen content');
                _isShowingAd = false;
                _lastAdShownTime = DateTime.now();
                ad.dispose();
                _appOpenAd = null;
                // Tải lại quảng cáo mới sau khi hiển thị
                loadAppOpenAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                print(
                  'App Open Ad failed to show full screen content: ${error.message}',
                );
                _isShowingAd = false;
                ad.dispose();
                _appOpenAd = null;
                // Tải lại quảng cáo mới sau khi lỗi
                loadAppOpenAd();
              },
            );
          },
          onAdFailedToLoad: (error) {
            print('App Open Ad failed to load: ${error.message}');
            _appOpenAd = null;
            // Thử tải lại sau 1 phút nếu tải thất bại
            Future.delayed(const Duration(minutes: 1), loadAppOpenAd);
          },
        ),
      );
    } catch (e) {
      print('Error loading app open ad: $e');
    }
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      // Tải lại quảng cáo mới sau khi hiển thị
      loadInterstitialAd();
    } else {
      print('Interstitial ad not loaded');
    }
  }

  void showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (_, reward) {
          print('User earned reward: ${reward.amount} ${reward.type}');
        },
      );
      _rewardedAd = null;
      // Tải lại quảng cáo mới sau khi hiển thị
      loadRewardedAd();
    } else {
      print('Rewarded ad not loaded');
    }
  }

  void showAppOpenAd() {
    if (_appOpenAd != null && !_isShowingAd) {
      // Kiểm tra thời gian từ lần hiển thị quảng cáo cuối
      if (_lastAdShownTime != null) {
        final timeSinceLastAd = DateTime.now().difference(_lastAdShownTime!);
        if (timeSinceLastAd < const Duration(minutes: 1)) {
          print('App Open Ad: Too soon to show another ad');
          return;
        }
      }

      print('Showing App Open Ad');
      _appOpenAd!.show();
    } else {
      print('App Open Ad not ready to show');
      // Thử tải lại quảng cáo nếu chưa có
      if (_appOpenAd == null) {
        loadAppOpenAd();
      }
    }
  }

  NativeAd? getNativeAd() {
    return _nativeAd;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _nativeAd?.dispose();
    _appOpenAd?.dispose();
  }
}
