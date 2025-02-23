

import 'package:flutter/material.dart';
import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/utils/router_names.dart';

final Map<String, WidgetBuilder> routes = {
  // noi tong hop ca routes
  RouteNames.loginScreen: (context) => const LoginScreen(),
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
}