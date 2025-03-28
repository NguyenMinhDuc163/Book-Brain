import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  static String routeName = '/favorites_screen';
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBarContinerWidget(
        titleString: "Yêu thích",
        child: Column(
          children: [
                      ],
        ),),
    );
  }
}
