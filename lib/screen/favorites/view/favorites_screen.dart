import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';

import '../../../utils/core/constants/dimension_constants.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  static String routeName = '/favorites_screen';
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _selectedIndex = 0;
  final List<String> _tabTitles = ['Yêu thích', 'Đang Đọc', 'Hoàn Thành'];

  final List<IconData> _tabIcons = [
    Icons.favorite_outline,
    Icons.book_outlined,
    Icons.check_circle_outline,
  ];

  // Danh sách màu cho mỗi tab
  final List<Color> _tabColors = [Colors.red, Colors.blue, Colors.green];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBarContinerWidget(
        titleString: "Yêu thích",
        paddingContent: EdgeInsets.only(
          top: height_30,
          left: kDefaultPadding,
          right: kDefaultPadding,
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Số cột
                  mainAxisSpacing: 10, // Khoảng cách giữa các hàng
                  crossAxisSpacing: 10, // Khoảng cách giữa các cột
                  childAspectRatio: 0.7,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildItem();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem() {
    return Container(
      child: Column(
        children: [
          ImageHelper.loadFromAsset(
            AssetHelper.harryPotterCover,
            width: width_200,
            height: height_200,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
