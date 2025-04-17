import 'package:book_brain/utils/core/constants/mock_data.dart';
import 'package:book_brain/utils/widget/base_appbar.dart';
import 'package:flutter/material.dart';

import '../../../utils/core/constants/dimension_constants.dart';
import '../../../utils/core/helpers/asset_helper.dart';
import '../../../utils/core/helpers/image_helper.dart';
import '../../home/widget/book_item_widget.dart';
import '../../login/widget/app_bar_continer_widget.dart';

class FollowingBookScreen extends StatefulWidget {
  const FollowingBookScreen({super.key});
  static const String routeName = '/following_book_sceen';
  @override
  State<FollowingBookScreen> createState() => _FollowingBookScreenState();
}

class _FollowingBookScreenState extends State<FollowingBookScreen> {

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> _listAllBooks =  MockData.listAllBooks;

    return Scaffold(
      body: AppBarContainerWidget(
        titleString: "Sách theo dõi",
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(top: height_10),
            child: Column(
              children: [
                // HorizontalBookList(
                //   title: 'Sách đang đọc',
                //   books: _listAllBooks,
                //   onSeeAllPressed: () {},
                // ),
                // HorizontalBookList(
                //   title: 'Sách đã đọc',
                //   books: _listAllBooks,
                //   onSeeAllPressed: () {},
                // ),
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
        crossAxisCount: 2, 
        mainAxisSpacing: 10, 
        crossAxisSpacing: 10, 
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