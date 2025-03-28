import 'package:book_brain/screen/favorites/view/favorites_screen.dart';
import 'package:book_brain/screen/forgot_password/view/forgot_password_screen.dart';
import 'package:book_brain/screen/home/view/home_screen.dart';
import 'package:book_brain/screen/main_app.dart';
import 'package:book_brain/screen/preview/view/preview_screen.dart';
import 'package:book_brain/screen/sign_up/view/sign_up_screen.dart';
import 'package:book_brain/screen/splash/view/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/utils/router_names.dart';

final Map<String, WidgetBuilder> routes = {
  // noi tong hop ca routes
  LoginScreen.routeName: (context) => const LoginScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  MainApp.routeName: (context) => const MainApp(),
  IntroScreen.routeName: (context) => const IntroScreen(),
  FavoritesScreen.routeName: (context) => const FavoritesScreen(),
  PreviewScreen.routeName: (context) => const PreviewScreen(),
};

MaterialPageRoute<dynamic>? generateRoutes(RouteSettings settings) {
  // switch (settings.name) {
  //   case LoginScreen.routeName:
  //     return MaterialPageRoute(
  //       settings: settings,
  //       builder: (context) =>
  //           ChangeNotifierProvider<HomeViewModel>(
  //             create: (_) => HomeViewModel(),
  //             child: const HomeScreen(),
  //           ),
  //     );
  // }
  return null;
}
