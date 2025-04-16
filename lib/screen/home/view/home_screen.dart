import 'package:book_brain/screen/following_book/view/following_book_screen.dart';
import 'package:book_brain/screen/home/widget/book_item_widget.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/notification/view/notification_screen.dart';
import 'package:book_brain/screen/preview/view/preview_screen.dart';
import 'package:book_brain/screen/ranking/view/ranking_screen.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/mock_data.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:book_brain/utils/core/extentions/size_extension.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:book_brain/screen/search_book/view/search_screen.dart';
import '../../history_reading/view/history_reading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home_screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> _listAllBooks = MockData.listAllBooks;

  Widget _buildItemCategory({
    required Widget icon,
    required Color color,
    required Function() onTap,
    required String title,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: width_100,
            height: height_50,
            padding: EdgeInsets.symmetric(vertical: kMediumPadding),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(kItemPadding),
            ),
            child: icon,
          ),
          SizedBox(height: kItemPadding),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildImageHomScreen(String name, String image) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(PreviewScreen.routeName);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: kDefaultPadding),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ImageHelper.loadFromAsset(
              image,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              radius: BorderRadius.circular(kItemPadding),
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Icon(Icons.favorite, color: Colors.red),
            ),
            Positioned(
              left: kDefaultPadding,
              bottom: kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyles.defaultStyle.whiteTextColor.bold,
                  ),
                  SizedBox(height: kItemPadding),
                  Container(
                    padding: EdgeInsets.all(kMinPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kMinPadding),
                      color: Colors.white.withOpacity(0.4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.star, color: Color(0xffFFC107)),
                        SizedBox(width: kItemPadding),
                        Text('4.5'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'home',
      isShowBackButton: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kItemPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: kMinPadding),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kItemPadding),
                color: Colors.white,
              ),
              child: Icon(FontAwesomeIcons.user, color: Colors.black, size: 30),
            ),
            SizedBox(width: width_16),
            Column(
              spacing: height_5,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nguyen Minh Đức',
                  style: TextStyles.defaultStyle.fontHeader.whiteTextColor.bold,
                ),
                Text(
                  'Bạn sẽ đọc cuốn sách nào hôm nay?',
                  style: TextStyles.defaultStyle.fontCaption.whiteTextColor,
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Badge.count(
                count: 1,
                child: Icon(
                  FontAwesomeIcons.bell,
                  color: Colors.white,
                  size: height_20,
                ),
              ),

              onPressed: () {
                Navigator.pushNamed(context, NotificationScreen.routeName);
              },
            ),
          ],
        ),
      ),
      bottomWidget: InkWell(
        child: TextField(
          enabled: false,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm cuốn sách của bạn',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                FontAwesomeIcons.magnifyingGlass,
                color: Colors.black,
                size: 14,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(kItemPadding)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: kItemPadding,
            ),
          ),
          style: TextStyles.defaultStyle,
          onChanged: (value) {},
          onSubmitted: (String submitValue) {},
        ),
        onTap: () {
          Navigator.pushNamed(context, SearchScreen.routeName);
        },
      ),
      paddingContent: EdgeInsets.all(kDefaultPadding),
      topPadding: 10,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildItemCategory(
                          icon: Icon(
                            FontAwesomeIcons.rankingStar,
                            color: Color(0xffFE9C5E),
                          ),
                          color: Color(0xffFE9C5E),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              HistoryReadingScreen.routeName,
                            );
                          },
                          title: 'Lịch sử',
                        ),
                      ),
                      SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: _buildItemCategory(
                          icon: Icon(
                            FontAwesomeIcons.rankingStar,
                            color: Color(0xffF77777),
                          ),
                          color: Color(0xffF77777),
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(RankingScreen.routeName);
                          },
                          title: 'Xếp hạng',
                        ),
                      ),
                      SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: _buildItemCategory(
                          icon: Icon(
                            FontAwesomeIcons.bookBookmark,
                            color: Color(0xff3EC8BC),
                          ),

                          color: Color(0xff3EC8BC),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              FollowingBookScreen.routeName,
                            );
                          },
                          title: 'Sách theo dõi',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: kMediumPadding),
                  HorizontalBookList(
                    title: 'Top thinh hành',
                    books: _listAllBooks,
                    onSeeAllPressed: () {},
                  ),

                  HorizontalBookList(
                    title: 'Dành cho bạn',
                    books: _listAllBooks,
                    onSeeAllPressed: () {},
                  ),

                  HorizontalBookList(
                    title: 'Mới xuất bản',
                    books: _listAllBooks,
                    onSeeAllPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
