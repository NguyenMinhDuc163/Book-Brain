import 'package:book_brain/screen/home/provider/home_notiffier.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';

import '../../../utils/core/constants/dimension_constants.dart';
import '../../../utils/core/helpers/asset_helper.dart';
import '../../../utils/core/helpers/image_helper.dart';
import '../../../utils/widget/empty_data.dart';
import '../../login/widget/app_bar_continer_widget.dart';
import '../../preview/view/preview_screen.dart';

class AllBookScreen extends StatefulWidget {
  AllBookScreen({super.key, this.title});
  static const routeName = "/all_book_screen";
  String? title;
  @override
  State<AllBookScreen> createState() => _AllBookScreenState();
}

class _AllBookScreenState extends State<AllBookScreen> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<HomeNotiffier>(context);

    return KeyboardDismisser(
      gestures: const [GestureType.onTap],
      child: Scaffold(
        body: AppBarContainerWidget(
          titleString: widget.title ?? "",
          child: Column(
            children: [
              SizedBox(height: height_20),
              _buildHeader(title: "Danh sách sách ${widget.title ?? ""}"),
              SizedBox(height: 16),

              Expanded(
                child:
                    presenter.isLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF6357CC),
                          ),
                        )
                        : _buildBookContent(presenter.bookInfo),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff6357CC),
            ),
          ),
        ),
        Container(
          height: 36,
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
                      height: 36,
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
                        size: 18,
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
                      height: 36,
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
                        size: 18,
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
    return GridView.builder(
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
    );
  }

  Widget _buildListView(List<BookInfoResponse> books) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return _buildListItem(books[index]);
      },
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
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            ImageHelper.loadFromAsset(
                              AssetHelper.defaultImage,
                              width: double.infinity,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                  )
                  : ImageHelper.loadFromAsset(
                    AssetHelper.defaultImage,
                    width: double.infinity,
                    height: 160,
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
                      SizedBox(height: 2),
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
                        width: 100,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                ImageHelper.loadFromAsset(
                                  AssetHelper.defaultImage,
                                  width: 100,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                      )
                      : ImageHelper.loadFromAsset(
                        AssetHelper.defaultImage,
                        width: 100,
                        height: 140,
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
