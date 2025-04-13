import 'package:book_brain/screen/ranking/widget/ranking_podium_widget.dart';
import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/mock_data.dart';
import 'package:book_brain/utils/widget/base_appbar.dart';
import 'package:book_brain/utils/widget/tab_widget.dart';
import 'package:flutter/material.dart';

import 'book_ranking_screen.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});
  static const routeName = "/ranking_screen";
  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final topUsers =  MockData.topUsers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.color6A5AE0,
      appBar: BaseAppbar(
        title: "Bảng xếp hạng",
        backgroundColor: ColorPalette.color6A5AE0,
      ),
      body: Tabwidget(
        tabs: [
          TabModel(
            title: Text(
              "Tác giả",
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            view: Padding(
              padding: EdgeInsets.all(kDefaultPadding),
              child: RankingPodium(topUsers: topUsers,),
            )
          ),
          TabModel(
            title: Text(
              "Sách",
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            view: Padding(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: BookRankingScreen(),
            ),
          ),
        ],
      ),
    );
  }
}
