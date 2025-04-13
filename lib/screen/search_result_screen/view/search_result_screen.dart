import 'package:flutter/material.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/screen/preview/view/preview_screen.dart';

class SearchResultScreen extends StatelessWidget {
  final String keyword;

  const SearchResultScreen({super.key, required this.keyword});

  static const String routeName = "/searchResultScreen";

  // Danh sách giả lập các cuốn sách 
  static const List<Map<String, String>> _books = [
    {
      'title': 'Harry Potter và Hòn đá Phù thủy',
      'author': 'J.K. Rowling',
      'imageUrl': '', 
    },
    {
      'title': 'Harry Potter và Phòng chứa Bí mật',
      'author': 'J.K. Rowling',
      'imageUrl': '',
    },
    {
      'title': 'Lord of the Rings',
      'author': 'J.R.R. Tolkien',
      'imageUrl': '',
    },
    {
      'title': 'Doraemon',
      'author': 'Fujiko F. Fujio',
      'imageUrl': '',
    },
    {
      'title': 'Naruto',
      'author': 'Masashi Kishimoto',
      'imageUrl': '',
    },
  ];

  // Lọc sách dựa trên từ khóa
  List<Map<String, String>> _filterBooks(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    return _books.where((book) {
      final title = book['title']!.toLowerCase();
      final author = book['author']!.toLowerCase();
      return title.contains(lowerKeyword) || author.contains(lowerKeyword);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách sách liên quan
    final filteredBooks = _filterBooks(keyword);

    return Scaffold(
      body: AppBarContainerWidget(
        titleString: "Kết quả tìm kiếm",
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kDefaultPadding * 2),
                Text(
                  'Kết quả cho: "$keyword"',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: kDefaultPadding),
                filteredBooks.isEmpty
                    ? Text(
                        'Hiện tại chưa có kết quả cụ thể. Từ khóa bạn nhập là: $keyword',
                        style: TextStyle(fontSize: 16),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = filteredBooks[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                book['imageUrl']!,
                                width: 60, 
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 60,
                                  height: 90,
                                  color: Colors.grey.shade300,
                                  child: Icon(Icons.book, color: Colors.grey.shade600),
                                ),
                              ),
                            ),
                            title: Text(
                              book['title']!,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              'Tác giả: ${book['author']}',
                              style: TextStyle(fontSize: 14),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, PreviewScreen.routeName);
                            },
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}