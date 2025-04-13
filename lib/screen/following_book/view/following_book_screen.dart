import 'package:book_brain/utils/widget/base_appbar.dart';
import 'package:flutter/material.dart';

import '../../../utils/core/constants/dimension_constants.dart';
import '../../../utils/core/helpers/asset_helper.dart';
import '../../../utils/core/helpers/image_helper.dart';
import '../../login/widget/app_bar_continer_widget.dart';

class FollowingBookScreen extends StatefulWidget {
  const FollowingBookScreen({super.key});
  static const String routeName = '/following_book_sceen';
  @override
  State<FollowingBookScreen> createState() => _FollowingBookScreenState();
}

class _FollowingBookScreenState extends State<FollowingBookScreen> {
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
        titleString: "Theo dõi",
        child: Column(
          children: [
            Row(
              children: List.generate(
                _tabTitles.length,
                    (index) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color:
                        _selectedIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color:
                          _selectedIndex == index
                              ? Colors.transparent
                              : Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _tabIcons[index],
                            size: 18,
                            color:
                            _selectedIndex == index
                                ? Color(0xFF6A5AE0)
                                : Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            _tabTitles[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                              _selectedIndex == index
                                  ? Color(0xFF6A5AE0)
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: height_20),

            // Nội dung tab
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [_buildItem(), _buildItem(), _buildItem()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Số cột
        mainAxisSpacing: 10, // Khoảng cách giữa các hàng
        crossAxisSpacing: 10, // Khoảng cách giữa các cột
        childAspectRatio: 0.7,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: [
              ImageHelper.loadFromAsset(
                AssetHelper.harryPotterCover,
                width: width_150,
                height: height_180,
                fit: BoxFit.cover,
              ),
            ],
          ),
        );
      },
    );
  }
}
