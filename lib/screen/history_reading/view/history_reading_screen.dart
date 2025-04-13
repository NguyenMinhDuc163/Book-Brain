import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/extentions/size_extension.dart';
import 'package:flutter/material.dart';

import '../../../utils/core/constants/dimension_constants.dart';
import '../../../utils/core/constants/mock_data.dart';
import '../../../utils/core/helpers/asset_helper.dart';
import '../../../utils/core/helpers/image_helper.dart';
import '../../home/widget/book_item_widget.dart';

class HistoryReadingScreen extends StatefulWidget {
  const HistoryReadingScreen({super.key});
  static const String routeName = '/history_reading_screen';
  @override
  State<HistoryReadingScreen> createState() => _HistoryReadingScreenState();
}

class _HistoryReadingScreenState extends State<HistoryReadingScreen> {
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
    final List<Map<String, String>> _listAllBooks =  MockData.listAllBooks;

    return Scaffold(
      body: AppBarContainerWidget(
        titleString: "Lịch sử đọc sách",
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(top: height_70),
            child: Column(
              children: [
                HorizontalBookList(
                  title: 'Sách đang đọc',
                  books: _listAllBooks,
                  onSeeAllPressed: () {},
                ),
                HorizontalBookList(
                  title: 'Sách đã đọc',
                  books: _listAllBooks,
                  onSeeAllPressed: () {},
                ),
              ],
            ),
          ),
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
        return  Container(
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
