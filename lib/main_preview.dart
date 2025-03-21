import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:book_brain/providers/provider_setup.dart';
import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:book_brain/utils/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  await LocalStorageHelper.initLocalStorageHelper();
  // await dotenv.load(fileName: ".env");
  /// khởi tạo Firebase
  // await Firebase.initializeApp(
  //   options: FirebaseOptions(
  //     apiKey: dotenv.env['API_KEY']!,
  //     appId: dotenv.env['APP_ID']!,
  //     messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
  //     projectId: dotenv.env['PROJECT_ID']!,
  //   ),
  // );

  /// Firebase Service
  // final firebaseService = FirebaseService();

  Locale defaultLocale = const Locale('en', 'US');
  String? savedLocale = LocalStorageHelper.getValue('languageCode');
  if (savedLocale != null) {
    defaultLocale = Locale(savedLocale);
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiProvider(
        providers: ProviderSetup.getProviders(),
        child: DevicePreview(enabled: true, builder: (context) => MyApp()),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,

      builder: (context, child) {
        return MaterialApp(
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          title: 'Fire Guard',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          home: const LoginScreen(),
          navigatorKey: NavigationService.navigatorKey,
          routes: routes,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: generateRoutes,
        );
      },
    );
  }
}
