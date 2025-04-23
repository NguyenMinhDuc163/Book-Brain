import 'package:book_brain/screen/history_reading/provider/history_notifier.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/preview/view/preview_screen.dart';
import 'package:book_brain/service/api_service/response/history_response.dart';
import 'package:book_brain/utils/core/helpers/network_image_handler.dart';
import 'package:book_brain/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/core/constants/dimension_constants.dart';
import '../../../utils/core/helpers/asset_helper.dart';

class HistoryReadingScreen extends StatefulWidget {
  const HistoryReadingScreen({super.key});
  static const String routeName = '/history_reading_screen';
  @override
  State<HistoryReadingScreen> createState() => _HistoryReadingScreenState();
}

class _HistoryReadingScreenState extends State<HistoryReadingScreen> {
  int _selectedIndex = 0;

  final List<String> _tabTitles = ['Tất cả', 'Đang đọc', 'Đã đọc'];
  late List<int> totalNumber;

  final List<IconData> _tabIcons = [
    Icons.book_outlined,
    Icons.bookmark_outline,
    Icons.check_circle_outline,
  ];
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<HistoryNotifier>(context).getData();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<HistoryNotifier>(context);
    return Scaffold(
      body: AppBarContainerWidget(
        titleString: "Lịch sử đọc sách",
        bottomWidget: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: Row(
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
                    padding: EdgeInsets.all(height_5),
                    decoration: BoxDecoration(
                      color: _selectedIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: _selectedIndex == index
                          ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ]
                          : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _tabIcons[index],
                          size: 18,
                          color: _selectedIndex == index
                              ? Color(0xFF6A5AE0)
                              : Colors.white,
                        ),
                        SizedBox(width: 6),
                        Text(
                          _tabTitles[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _selectedIndex == index
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
        ),
        paddingContent: EdgeInsets.symmetric(
          horizontal: kMediumPadding,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTabHeader(),

            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _buildAllReading(presenter.allHistory),
                  _buildCurrentlyReading(presenter.currentHistory),
                  _buildFinishedReading(presenter.completedHistory),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabHeader() {
    String description = '';

    switch (_selectedIndex) {
      case 0:
        description = "Những cuốn sách bạn đang theo dõi và đọc dở";
        break;
      case 1:
        description = "Danh sách sách bạn muốn đọc trong tương lai";
        break;
      case 2:
        description = "Những cuốn sách bạn đã đọc xong";
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _tabTitles[_selectedIndex],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A5AE0),
          ),
        ),
        SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }


  Widget _buildAllReading(List<HistoryResponse> allHistory) {

    return ListView.builder(
      itemCount: allHistory.length,
      padding: EdgeInsets.only(top: height_12),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PreviewScreen(bookId: allHistory[index].bookId,)));
          },
          child: _buildReadingBookItem(
            title: allHistory[index].title ?? '',
            author: allHistory[index].authorName ?? '',
            progress: Utils.convertCompletionRate( allHistory[index].completionRate ?? '5'),
            lastRead: Utils.convertToFormattedDate(allHistory[index].lastReadAt.toString()),
            coverAsset:allHistory[index].imageUrl ??  AssetHelper.defaultImage,
          ),
        );
      },
    );
  }


  Widget _buildCurrentlyReading(List<HistoryResponse> currentHistory) {
    return GridView.builder(
      padding: EdgeInsets.only(top: height_12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 0.7,
      ),
      itemCount: currentHistory.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PreviewScreen(bookId: currentHistory[index].bookId,)));
          },
          child: _buildBookCard(
            title:  currentHistory[index].title ?? '',
            author:  currentHistory[index].authorName ?? '',
            coverAsset: currentHistory[index].imageUrl ?? AssetHelper.defaultImage,
            addedDate: Utils.convertToFormattedDate(currentHistory[index].lastReadAt.toString()),
          ),
        );
      },
    );
  }


  Widget _buildFinishedReading(List<HistoryResponse> completedHistory) {
    return ListView.builder(
      itemCount: completedHistory.length,
      padding: EdgeInsets.only(top: height_12),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PreviewScreen(bookId: completedHistory[index].bookId,)));
          },
          child: _buildFinishedBookItem(
            title:  completedHistory[index].title ?? '' ,
            author:  completedHistory[index].authorName ?? '',
            rating: Utils.convertCompletionRate( completedHistory[index].completionRate ?? '5').toDouble(),
            finishedDate: Utils.convertToFormattedDate(completedHistory[index].finishDate ?? ''),
            coverAsset: completedHistory[index].imageUrl ?? AssetHelper.harryPotterCover,
          ),
        );
      },
    );
  }


  Widget _buildReadingBookItem({
    required String title,
    required String author,
    required int progress,
    required String lastRead,
    required String coverAsset,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:  NetworkImageHandler(
              imageUrl: coverAsset, // URL hình ảnh của bạn
              width: 70,
              height: 110,
            ),
          ),
          SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tiến độ: $progress%",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Đọc lần cuối: $lastRead",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A5AE0)),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Tiếp tục đọc",
                            style: TextStyle(
                              color: Color(0xFF6A5AE0),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: Color(0xFF6A5AE0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBookCard({
    required String title,
    required String author,
    required String coverAsset,
    required String addedDate,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: NetworkImageHandler(
              imageUrl: coverAsset,
              width: double.infinity,
              height: 140,
              fit:  BoxFit.fitWidth,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Thêm: $addedDate",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                    Icon(
                      Icons.bookmark,
                      size: 16,
                      color: Color(0xFF6A5AE0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFinishedBookItem({
    required String title,
    required String author,
    required double rating,
    required String finishedDate,
    required String coverAsset,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: NetworkImageHandler(
              imageUrl: coverAsset, // URL hình ảnh của bạn
              width: 70,
              height: 100,
              fit: BoxFit.cover,
            ),

          ),
          SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [

                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < rating.floor()
                                  ? Icons.star
                                  : (index < rating)
                                  ? Icons.star_half
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 18,
                            );
                          }),
                        ),
                        SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Đọc xong: $finishedDate",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Đánh giá",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.rate_review_outlined,
                            size: 14,
                            color: Colors.grey[700],
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Đọc lại",
                            style: TextStyle(
                              color: Color(0xFF6A5AE0),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.refresh,
                            size: 14,
                            color: Color(0xFF6A5AE0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
