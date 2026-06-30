import 'package:book_brain/screen/main_app.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/utils/core/helpers/auth_helper.dart';
import 'package:flutter/cupertino.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String routeName = '/splash_screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Đợi 2 giây rồi chuyển màn
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      _openApp();
    }
  }

  Future<void> _openApp() async {
    if (!AuthHelper.isLoggedIn) {
      await AuthHelper.continueAsGuest();
    }

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(MainApp.routeName, (_) => false);
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
        ),
        Positioned.fill(
          child: ImageHelper.loadFromAsset(AssetHelper.circleSplash),
        ),
      ],
    );
  }
}
