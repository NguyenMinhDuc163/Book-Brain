import 'package:flutter/material.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/screen/preview/view/preview_screen.dart';

class SearchResultScreen extends StatefulWidget {
  final String keyword;

  const SearchResultScreen({super.key, required this.keyword});

  static const String routeName = "/searchResultScreen";

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  static const List<Map<String, dynamic>> _books = [
    {
      'title': 'Harry Potter và Hòn đá Phù thủy',
      'author': 'J.K. Rowling',
      'imageUrl': "https://m.media-amazon.com/images/I/71-++hbbERL.jpg",
      'genres': ['Fantasy', 'Adventure'],
      'rating': 4.8,
      'views': 1000,
      'publishedDate': '1997-06-26',
    },
    {
      'title': 'Naruto',
      'author': 'Masashi Kishimoto',
      'imageUrl': "",
      'genres': ['Manga', 'Action'],
      'rating': 4.6,
      'views': 1100,
      'publishedDate': '1999-09-21',
    },
    {
      'title': 'Doraemon',
      'author': 'Fujiko F. Fujio',
      'imageUrl':
          "",
      'genres': ['Manga', 'Comedy'],
      'rating': 4.5,
      'views': 800,
      'publishedDate': '1969-12-01',
    },
    {
      'title': 'Lord of the Rings',
      'author': 'J.R.R. Tolkien',
      'imageUrl': "",
      'genres': ['Fantasy', 'Epic'],
      'rating': 4.9,
      'views': 1200,
      'publishedDate': '1954-07-29',
    },
    {
      'title': 'The Alchemist',
      'author': 'Paulo Coelho',
      'imageUrl': "",
      'genres': ['Adventure', 'Philosophy'],
      'rating': 4.7,
      'views': 1500,
      'publishedDate': '1988-05-01',
    },
    {
      'title': '1984',
      'author': 'George Orwell',
      'imageUrl':
          "",
      'genres': ['Dystopian', 'Political'],
      'rating': 4.5,
      'views': 2000,
      'publishedDate': '1949-06-08',
    },
    {
      'title': 'The Great Gatsby',
      'author': 'F. Scott Fitzgerald',
      'imageUrl': "",
      'genres': ['Classic', 'Drama'],
      'rating': 4.4,
      'views': 1300,
      'publishedDate': '1925-04-10',
    },
    {
      'title': 'The Catcher in the Rye',
      'author': 'J.D. Salinger',
      'imageUrl': "",
      'genres': ['Classic', 'Fiction'],
      'rating': 4.2,
      'views': 1100,
      'publishedDate': '1951-07-16',
    },
    {
      'title': 'To Kill a Mockingbird',
      'author': 'Harper Lee',
      'imageUrl': "",
      'genres': ['Classic', 'Fiction'],
      'rating': 4.8,
      'views': 1400,
      'publishedDate': '1960-07-11',
    },
    {
      'title': 'Pride and Prejudice',
      'author': 'Jane Austen',
      'imageUrl': "",
      'genres': ['Romance', 'Classic'],
      'rating': 4.6,
      'views': 1200,
      'publishedDate': '1813-01-28',
    },
  ];

  String _sortBy = 'none';
  Set<String> _selectedGenres = {};

  // Mapping English genre -> Vietnamese
  static const Map<String, String> genreMap = {
    'Fantasy': 'Viễn tưởng',
    'Adventure': 'Phiêu lưu',
    'Classic': 'Kinh điển',
    'Romance': 'Lãng mạn',
    'Comedy': 'Hài kịch',
    'Action': 'Hành động',
    'History': 'Lịch sử',
    'Manga': 'Truyện tranh',
    'Epic': 'Anh hùng ca',
  };

  List<Map<String, dynamic>> _filterBooks(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    List<Map<String, dynamic>> filtered =
        _books.where((book) {
          final title = book['title'].toLowerCase();
          final author = book['author'].toLowerCase();
          bool matchesKeyword =
              title.contains(lowerKeyword) || author.contains(lowerKeyword);
          bool matchesGenres =
              _selectedGenres.isEmpty ||
              book['genres'].any((genre) => _selectedGenres.contains(genre));
          return matchesKeyword && matchesGenres;
        }).toList();

    switch (_sortBy) {
      case 'newest':
        filtered.sort(
          (a, b) => DateTime.parse(
            b['publishedDate'],
          ).compareTo(DateTime.parse(a['publishedDate'])),
        );
        break;
      case 'oldest':
        filtered.sort(
          (a, b) => DateTime.parse(
            a['publishedDate'],
          ).compareTo(DateTime.parse(b['publishedDate'])),
        );
        break;
      case 'best_rated':
        filtered.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
      case 'most_popular':
        filtered.sort((a, b) => b['views'].compareTo(a['views']));
        break;
    }

    return filtered;
  }

  void _showGenreFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chọn thể loại',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: kDefaultPadding),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children:
                        genreMap.entries.map((entry) {
                          return FilterChip(
                            label: Text(entry.value),
                            selected: _selectedGenres.contains(entry.key),
                            onSelected: (selected) {
                              setModalState(() {
                                if (selected) {
                                  _selectedGenres.add(entry.key);
                                } else {
                                  _selectedGenres.remove(entry.key);
                                }
                              });
                              setState(() {});
                            },
                          );
                        }).toList(),
                  ),
                  SizedBox(height: kDefaultPadding),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _selectedGenres.clear();
                      });
                      setState(() {});
                    },
                    child: Text('Bỏ chọn tất cả các thể loại'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Áp dụng'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _filterBooks(widget.keyword);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      body: AppBarContinerWidget(
        titleString: "Kết quả tìm kiếm",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kDefaultPadding),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: kDefaultPadding,
              ),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton('Mới nhất', 'newest'),
                    SizedBox(width: 8),
                    _buildFilterButton('Cũ nhất', 'oldest'),
                    SizedBox(width: 8),
                    _buildFilterButton('Đánh giá tốt nhất', 'best_rated'),
                    SizedBox(width: 8),
                    _buildFilterButton('Phổ biến nhất', 'most_popular'),
                    SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: _showGenreFilter,
                      child: Text(
                        'Thể loại${_selectedGenres.isEmpty ? '' : ' (${_selectedGenres.length})'}',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                'Kết quả cho: "${widget.keyword}"',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: kDefaultPadding / 2),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                ),
                child:
                    filteredBooks.isEmpty
                        ? Center(
                          child: Text(
                            'Hiện tại chưa có kết quả cụ thể.\nTừ khóa bạn nhập là: ${widget.keyword}',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        )
                        : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isWideScreen ? 2 : 1,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 12,
                                childAspectRatio: 3,
                              ),
                          itemCount: filteredBooks.length,
                          itemBuilder: (context, index) {
                            final book = filteredBooks[index];
                            return GestureDetector(
                              onTap:
                                  () => Navigator.pushNamed(
                                    context,
                                    PreviewScreen.routeName,
                                  ),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        book['imageUrl'] ?? '',
                                        width: 60,
                                        height: 90,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 60,
                                                  height: 90,
                                                  color: Colors.grey.shade300,
                                                  child: Icon(
                                                    Icons.book,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            book['title'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Tác giả: ${book['author']}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, String value) {
    final isSelected = _sortBy == value;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _sortBy = isSelected ? 'none' : value;
        });
      },
      child: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? Colors.blue : null,
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey.shade400,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
