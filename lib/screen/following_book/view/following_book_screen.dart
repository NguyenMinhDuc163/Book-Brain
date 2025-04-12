import 'package:book_brain/utils/widget/base_appbar.dart';
import 'package:flutter/material.dart';

class FollowingBookScreen extends StatefulWidget {
  const FollowingBookScreen({super.key});
  static const String routeName = '/following_book_sceen';
  @override
  State<FollowingBookScreen> createState() => _FollowingBookScreenState();
}

class _FollowingBookScreenState extends State<FollowingBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar(backgroundColor: Colors.white, textColor: Colors.black, title: "Sách theo dõi",),
      body: Align(
        alignment: Alignment.center,
          child: Container(child: Text("chưa có gì"),)),
    );
  }
}
