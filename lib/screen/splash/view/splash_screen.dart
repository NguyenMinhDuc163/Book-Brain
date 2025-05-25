import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/screen/splash/view/intro_screen.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:book_brain/service/service_config/admob_service.dart';
import 'package:flutter/cupertino.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String routeName = '/splash_screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AdMobService _adMobService = AdMobService();
  bool _isAdLoaded = false;
  static const String _appOpenCountKey = 'app_open_count';
  static const int _showAdAfterCount = 3;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    print('Initializing app...');

    // Kiểm tra xem user có phải VIP không
    String isAds = LocalStorageHelper.getValue("isAds") ?? 'on';
    if (isAds == 'off') {
      // Nếu là VIP, chỉ đợi 3 giây rồi chuyển màn
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        redirectIntroScreen();
      }
      return;
    }

    // Tăng số lần mở app
    int openCount =
        (LocalStorageHelper.getValue(_appOpenCountKey) as int?) ?? 0;
    openCount++;
    LocalStorageHelper.setValue(_appOpenCountKey, openCount);

    // Chỉ tải và hiển thị quảng cáo khi đạt đến số lần mở nhất định
    if (openCount >= _showAdAfterCount) {
      // Tải quảng cáo
      await _adMobService.loadAppOpenAd();

      // Đợi 2 giây để đảm bảo quảng cáo được tải đầy đủ
      await Future.delayed(const Duration(seconds: 3));

      // Hiển thị quảng cáo App Open
      _adMobService.showAppOpenAd();

      // Reset số lần mở app về 0
      LocalStorageHelper.setValue(_appOpenCountKey, 0);
    } else {
      // Nếu chưa đủ số lần mở, chỉ đợi 3 giây
      await Future.delayed(const Duration(seconds: 3));
    }

    if (mounted) {
      redirectIntroScreen();
    }
  }

  void redirectIntroScreen() async {
    final ignoreIntroScreen =
        LocalStorageHelper.getValue('ignoreIntroScreen') as bool?;
    if (ignoreIntroScreen != null && ignoreIntroScreen) {
      Navigator.of(context).pushNamed(LoginScreen.routeName);
    } else {
      LocalStorageHelper.setValue('ignoreIntroScreen', true);
      Navigator.of(context).pushNamed(IntroScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ImageHelper.loadFromAsset(
            AssetHelper.backgroundSplash,
            fit: BoxFit.fitWidth,
          ),
        ), // cho full man hinh
        Positioned.fill(
          child: ImageHelper.loadFromAsset(AssetHelper.circleSplash),
        ),
      ],
    );
  }
}
