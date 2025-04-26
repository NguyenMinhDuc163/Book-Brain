import 'package:book_brain/screen/change_password/view/change_password_screen.dart';
import 'package:book_brain/screen/detail_book/view/detail_book_screen.dart';
import 'package:book_brain/screen/edit_profile/view/edit_profile_screen.dart';
import 'package:book_brain/screen/favorites/view/favorites_screen.dart';
import 'package:book_brain/screen/following_book/view/following_book_screen.dart';
import 'package:book_brain/screen/login/view/forgot_password_screen.dart';
import 'package:book_brain/screen/history_reading/view/history_reading_screen.dart';
import 'package:book_brain/screen/home/view/all_book_screen.dart';
import 'package:book_brain/screen/home/view/home_screen.dart';
import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/screen/login/view/sign_up_screen.dart';
import 'package:book_brain/screen/main_app.dart';
import 'package:book_brain/screen/preview/view/preview_screen.dart';
import 'package:book_brain/screen/reivew_book/view/review_book_screen.dart';
import 'package:book_brain/screen/search_screen/view/search_screen.dart';
import 'package:book_brain/screen/splash/view/intro_screen.dart';
import 'package:flutter/material.dart';

import '../screen/notification/view/notification_screen.dart';
import '../screen/ranking/view/ranking_screen.dart';
final Map<String, WidgetBuilder> routes = {
  // noi tong hop ca routes
  LoginScreen.routeName: (context) => const LoginScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  MainApp.routeName: (context) => const MainApp(),
  IntroScreen.routeName: (context) => const IntroScreen(),
  FavoritesScreen.routeName: (context) => const FavoritesScreen(),
  HistoryReadingScreen.routeName: (context) => const HistoryReadingScreen(),
  FollowingBookScreen.routeName: (context) => const FollowingBookScreen(),
  SearchScreen.routeName: (context) => const SearchScreen(),
  EditProfileScreen.routeName: (context) => const EditProfileScreen(),
  PreviewScreen.routeName: (context) =>  PreviewScreen(),
  ChangePasswordScreen.routeName: (context) => const ChangePasswordScreen(),
  RankingScreen.routeName: (context) => const RankingScreen(),
  DetailBookScreen.routeName: (context) =>  DetailBookScreen(),
  ReviewBookScreen.routeName: (context) =>  ReviewBookScreen(),
  NotificationScreen.routeName: (context) => const NotificationScreen(),
  AllBookScreen.routeName: (context) =>  AllBookScreen(),
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
