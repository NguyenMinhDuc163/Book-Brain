import 'package:book_brain/service/api_service/response/search_book_response.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/widgets/native_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:book_brain/screen/search_screen/provider/search_notifier.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/widgets/ad_banner_widget.dart';

class BooksGridView extends StatelessWidget {
  final List<SearchBookResponse> books;
  final Function(SearchBookResponse book) onTap;
  final ScrollController? scrollController;

  const BooksGridView({
    Key? key,
    required this.books,
    required this.onTap,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tạo danh sách item (2 sách 1 hàng)
    List<Widget> rows = [];
    int adInterval = 6;
    int count = 0;
    for (int i = 0; i < books.length; i += 2) {
      // Chèn NativeAd sau mỗi 6 sách
      if (count > 0 && count % adInterval == 0) {
        rows.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: NativeAdWidget(),
          ),
        );
      }
      List<Widget> rowChildren = [];
      rowChildren.add(
        Expanded(
          child: GestureDetector(
            onTap: () => onTap(books[i]),
            child: BookGridItem(book: books[i]),
          ),
        ),
      );
      if (i + 1 < books.length) {
        rowChildren.add(SizedBox(width: 16));
        rowChildren.add(
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(books[i + 1]),
              child: BookGridItem(book: books[i + 1]),
            ),
          ),
        );
      } else {
        rowChildren.add(Expanded(child: SizedBox()));
      }
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowChildren,
        ),
      );
      rows.add(SizedBox(height: 16));
      count += 2;
    }
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.all(16),
      children: rows,
    );
  }
}

class BookGridItem extends StatelessWidget {
  final SearchBookResponse book;

  const BookGridItem({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int rate = int.tryParse((book.rating ?? '10/10').split('/')[0]) ?? 4;
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: _buildBookImage(
                  imageUrl: book.imageUrl,
                  width: double.infinity,
                  height: 140,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    SizedBox(width: 2),
                    Text(
                      '${book.rating ?? 0}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${book.views ?? 0} views',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
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

class BooksListView extends StatelessWidget {
  final List<SearchBookResponse> books;
  final Function(SearchBookResponse book) onTap;
  final ScrollController? scrollController;

  const BooksListView({
    Key? key,
    required this.books,
    required this.onTap,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.only(bottom: 16),
      itemCount: books.length + (books.length ~/ 6), // Thêm số lượng banner ads
      itemBuilder: (context, index) {
        // Tính toán index thực tế cho books sau khi đã thêm ads
        int actualIndex = index - (index ~/ 7);

        // Hiển thị banner ads sau mỗi 6 items
        if (index > 0 && index % 7 == 6) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: NativeAdWidget(),
          );
        }

        if (actualIndex >= books.length) return SizedBox.shrink();

        final book = books[actualIndex];
        return GestureDetector(
          onTap: () => onTap(book),
          child: BookListItem(book: book),
        );
      },
    );
  }
}

class BookListItem extends StatelessWidget {
  final SearchBookResponse book;

  const BookListItem({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int rate = int.tryParse((book.rating ?? '10/10').split('/')[0]) ?? 4;
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: _buildBookImage(
                  imageUrl: book.imageUrl,
                  width: 100,
                  height: 130,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    book.authorName ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    book.categoryName ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 2),
                          Text(
                            '${book.rating ?? 0}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Lượt xem: ${book.views ?? 0}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
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

Widget _buildRatingBadge(int? rating) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: Color(0xFF6A5AE0),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      '${rating ?? 0}',
      style: TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _buildBookImage({
  required String? imageUrl,
  required double width,
  required double height,
}) {
  return (imageUrl != null && imageUrl.isNotEmpty)
      ? Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            AssetHelper.defaultImage,
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
              ),
            ),
          );
        },
      )
      : Image.asset(
        AssetHelper.defaultImage,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
}

class BookScreenExample extends StatelessWidget {
  final List<SearchBookResponse> books = [];
  final bool isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Books')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child:
            isGridView
                ? BooksGridView(
                  books: books,
                  onTap: (book) {
                    Navigator.pushNamed(
                      context,
                      '/preview',
                      arguments: book.title,
                    );
                  },
                )
                : BooksListView(
                  books: books,
                  onTap: (book) {
                    Navigator.pushNamed(
                      context,
                      '/preview',
                      arguments: book.title,
                    );
                  },
                ),
      ),
    );
  }
}
