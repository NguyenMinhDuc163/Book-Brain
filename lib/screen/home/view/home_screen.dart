import 'package:book_brain/screen/following_book/view/following_book_screen.dart';
import 'package:book_brain/screen/home/provider/home_notifier.dart';
import 'package:book_brain/screen/home/view/all_book_screen.dart';
import 'package:book_brain/screen/home/widget/book_item_widget.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/notification/view/notification_screen.dart';
import 'package:book_brain/screen/ranking/view/ranking_screen.dart';
import 'package:book_brain/screen/search_screen/view/search_screen.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:book_brain/widgets/ad_banner_widget.dart';
import 'package:book_brain/widgets/native_ad_widget.dart';

import '../../../utils/widget/loading_widget.dart';
import '../../history_reading/view/history_reading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home_screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<HomeNotifier>(context, listen: false).getData(),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<HomeNotifier>(context);
    return Stack(
      children: [
        AppBarContainerWidget(
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
                  child: Icon(
                    FontAwesomeIcons.user,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                SizedBox(width: width_16),
                Column(
                  spacing: height_5,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      presenter.userName ?? "Nguyễn Minh Đức",
                      style:
                          TextStyles
                              .defaultStyle
                              .fontHeader
                              .whiteTextColor
                              .bold,
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
                    count: presenter.unreadNotificationCount,
                    isLabelVisible: presenter.unreadNotificationCount > 0,
                    child: Icon(
                      FontAwesomeIcons.bell,
                      color: Colors.white,
                      size: height_20,
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      NotificationScreen.routeName,
                    );
                    // Cập nhật lại số lượng thông báo khi quay lại
                    if (mounted) {
                      Provider.of<HomeNotifier>(
                        context,
                        listen: false,
                      ).getUnreadNotificationCount();
                    }
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            RankingScreen(isFromHome: true),
                                  ),
                                );
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
                        books: presenter.trendingBook,
                        onSeeAllPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => AllBookScreen(
                                    title: 'Top thinh hành',
                                    book: presenter.trendingBook,
                                  ),
                            ),
                          );
                        },
                      ),

                      // Thêm Native Ad sau danh sách Top thịnh hành
                      SizedBox(height: kMediumPadding),
                      AdBannerWidget(),

                      HorizontalBookList(
                        title: 'Dành cho bạn',
                        books: presenter.recommenlist,
                        onSeeAllPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => AllBookScreen(
                                    title: 'Dành cho bạn',
                                    book: presenter.recommenlist,
                                  ),
                            ),
                          );
                        },
                      ),

                      // Thêm Banner Ad ở cuối màn hình
                      SizedBox(height: kMediumPadding),
                      AdBannerWidget(),
                      SizedBox(height: kMediumPadding),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        presenter.isLoading ? const LoadingWidget() : const SizedBox(),
      ],
    );
  }
}
