import 'package:book_brain/screen/home/provider/home_notifier.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';

import '../../../utils/core/constants/dimension_constants.dart';
import '../../../utils/core/helpers/asset_helper.dart';
import '../../../utils/core/helpers/image_helper.dart';
import '../../../utils/widget/empty_data.dart';
import '../../../utils/widget/loading_widget.dart';
import '../../login/widget/app_bar_continer_widget.dart';
import '../../preview/view/preview_screen.dart';

class AllBookScreen extends StatefulWidget {
  AllBookScreen({super.key, this.title, required this.book});
  static const routeName = "/all_book_screen";
  String? title;
  List<BookInfoResponse> book;
  @override
  State<AllBookScreen> createState() => _AllBookScreenState();
}

class _AllBookScreenState extends State<AllBookScreen> {
  bool _isGridView = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<HomeNotifier>(context);

    return KeyboardDismisser(
      gestures: const [GestureType.onTap],
      child: Scaffold(
        body: Stack(
          children: [
            AppBarContainerWidget(
              titleString: widget.title ?? "",
              child: Column(
                children: [
                  SizedBox(height: height_20),
                  _buildHeader(title: widget.title ?? ""),
                  SizedBox(height: 16),

                  Expanded(
                    child:
                        presenter.isLoading
                            ? Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF6357CC),
                              ),
                            )
                            : _buildBookContent(widget.book),
                  ),
                ],
              ),
            ),
            presenter.isLoading ? const LoadingWidget() : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _scrollToTop,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff6357CC),
              ),
            ),
          ),
        ),
        Container(
          height: height_30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(18),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isGridView = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      height: height_20,
                      decoration: BoxDecoration(
                        gradient:
                            _isGridView
                                ? LinearGradient(
                                  colors: [
                                    Color(0xFF8F67E8),
                                    Color(0xFF6357CC),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                        color: _isGridView ? null : Colors.white,
                      ),
                      child: Icon(
                        Icons.grid_view_rounded,
                        size: height_12,
                        color: _isGridView ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(18),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isGridView = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      height: height_24,
                      decoration: BoxDecoration(
                        gradient:
                            !_isGridView
                                ? LinearGradient(
                                  colors: [
                                    Color(0xFF8F67E8),
                                    Color(0xFF6357CC),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                        color: !_isGridView ? null : Colors.white,
                      ),
                      child: Icon(
                        Icons.view_list_rounded,
                        size: height_12,
                        color: !_isGridView ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookContent(List<BookInfoResponse> book) {
    if (book.isEmpty) {
      return _buildEmptyState(book);
    }

    return _isGridView ? _buildGridView(book) : _buildListView(book);
  }

  Widget _buildGridView(List<BookInfoResponse> books) {
    final presenter = Provider.of<HomeNotifier>(context);
    bool isLoadingMore =
        widget.title == 'Top thinh hành'
            ? presenter.isLoadingMoreTrending
            : presenter.isLoadingMoreRecommend;
    bool hasMore =
        widget.title == 'Top thinh hành'
            ? presenter.hasMoreTrending
            : presenter.hasMoreRecommend;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          if (widget.title == 'Top thinh hành') {
            Provider.of<HomeNotifier>(
              context,
              listen: false,
            ).loadMoreTrendingBooks();
          } else {
            Provider.of<HomeNotifier>(
              context,
              listen: false,
            ).loadMoreRecommendBooks();
          }
        }
        return true;
      },
      child: Stack(
        children: [
          RawScrollbar(
            thumbColor: Color(0xFF6357CC).withOpacity(0.5),
            radius: Radius.circular(20),
            thickness: 6,
            thumbVisibility: true,
            controller: _scrollController,
            child: GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                return _buildGridItem(books[index]);
              },
            ),
          ),
          if (isLoadingMore || !hasMore)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildLoadingIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildListView(List<BookInfoResponse> books) {
    final presenter = Provider.of<HomeNotifier>(context);
    bool isLoadingMore =
        widget.title == 'Top thinh hành'
            ? presenter.isLoadingMoreTrending
            : presenter.isLoadingMoreRecommend;
    bool hasMore =
        widget.title == 'Top thinh hành'
            ? presenter.hasMoreTrending
            : presenter.hasMoreRecommend;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          if (widget.title == 'Top thinh hành') {
            Provider.of<HomeNotifier>(
              context,
              listen: false,
            ).loadMoreTrendingBooks();
          } else {
            Provider.of<HomeNotifier>(
              context,
              listen: false,
            ).loadMoreRecommendBooks();
          }
        }
        return true;
      },
      child: Stack(
        children: [
          RawScrollbar(
            thumbColor: Color(0xFF6357CC).withOpacity(0.5),
            radius: Radius.circular(20),
            thickness: 6,
            thumbVisibility: true,
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: books.length,
              itemBuilder: (context, index) {
                return _buildListItem(books[index]);
              },
            ),
          ),
          if (isLoadingMore || !hasMore)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildLoadingIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BookInfoResponse book) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PreviewScreen(bookId: book.bookId),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh bìa sách
              (book.imageUrl ?? '') != ''
                  ? Image.network(
                    book.imageUrl ?? "",
                    width: double.infinity,
                    height: height_110,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            ImageHelper.loadFromAsset(
                              AssetHelper.defaultImage,
                              width: double.infinity,
                              height: height_80,
                              fit: BoxFit.cover,
                            ),
                  )
                  : ImageHelper.loadFromAsset(
                    AssetHelper.defaultImage,
                    width: double.infinity,
                    height: height_80,
                    fit: BoxFit.cover,
                  ),

              // Thông tin sách
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: height_2),
                      Text(
                        book.authorName ?? "",
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          SizedBox(width: 2),
                          Text(
                            book.rating?.toString() ?? "0.0",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(BookInfoResponse book) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PreviewScreen(bookId: book.bookId),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child:
                  (book.imageUrl ?? '') != ''
                      ? Image.network(
                        book.imageUrl ?? "",
                        width: width_90,
                        height: height_100,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                ImageHelper.loadFromAsset(
                                  AssetHelper.defaultImage,
                                  width: width_90,
                                  height: height_100,
                                  fit: BoxFit.cover,
                                ),
                      )
                      : ImageHelper.loadFromAsset(
                        AssetHelper.defaultImage,
                        width: width_90,
                        height: height_100,
                        fit: BoxFit.cover,
                      ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      book.authorName ?? "",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          book.rating?.toString() ?? "0.0",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " (${book.views ?? '0'} lượt xem)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    final presenter = Provider.of<HomeNotifier>(context);
    bool isLoadingMore =
        widget.title == 'Top thinh hành'
            ? presenter.isLoadingMoreTrending
            : presenter.isLoadingMoreRecommend;
    bool hasMore =
        widget.title == 'Top thinh hành'
            ? presenter.hasMoreTrending
            : presenter.hasMoreRecommend;

    if (!isLoadingMore && !hasMore) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        color: Colors.white,
        child: Center(
          child: Text(
            'Đã hết dữ liệu',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      color: Colors.white,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF6357CC),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(List<BookInfoResponse> book) {
    return book.isNotEmpty
        ? Center(
          child: EmptyDataWidget(
            title: "Không tìm thấy sách phù hợp",
            styleTitle: TextStyle(fontSize: 14, color: Colors.grey[600]),
            height: height_200,
            width: width_200,
          ),
        )
        : Center(
          child: EmptyDataWidget(
            title: "Bạn chưa theo dõi sách nào",
            styleTitle: TextStyle(fontSize: 14, color: Colors.grey[600]),
            height: height_200,
            width: width_200,
          ),
        );
  }
}
