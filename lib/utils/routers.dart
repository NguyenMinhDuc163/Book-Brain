import 'package:book_brain/screen/forgot_password/view/forgot_password_screen.dart';
import 'package:book_brain/screen/home/view/home_screen.dart';
import 'package:book_brain/screen/main_app.dart';
import 'package:book_brain/screen/sign_up/view/sign_up_screen.dart';
import 'package:book_brain/screen/splash/view/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/utils/router_names.dart';

final Map<String, WidgetBuilder> routes = {
  // noi tong hop ca routes
  RouteNames.loginScreen: (context) => const LoginScreen(),
  RouteNames.forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
  RouteNames.signUpScreen: (context) => const SignUpScreen(),
  RouteNames.homeScreen: (context) => const HomeScreen(),
  RouteNames.mainApp: (context) => const MainApp(),
  RouteNames.introScreen: (context) => const IntroScreen(),
};

MaterialPageRoute<dynamic>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    // case RouteNames.homeScreen:
    //   return MaterialPageRoute(
    //     settings: settings,
    //     builder: (context) =>
    //         ChangeNotifierProvider<HomeViewModel>(
    //           create: (_) => HomeViewModel(),
    //           child: const HomeScreen(),
    //         ),
    //   );
  }
  return null;
}
