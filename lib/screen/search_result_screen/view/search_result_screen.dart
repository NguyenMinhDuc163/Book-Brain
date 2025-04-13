import 'package:flutter/material.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/screen/preview/view/preview_screen.dart';

class SearchResultScreen extends StatefulWidget {
  final String keyword;

  const SearchResultScreen({super.key, required this.keyword});

  static const String routeName = "/searchResultScreen";

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  String _sortOption = 'Phổ biến';
  bool _isGridView = true;
  final List<String> _sortOptions = ['Phổ biến', 'Mới nhất', 'Đánh giá cao', 'A-Z'];

  
  List<Map<String, dynamic>> _filterBooks(String keyword) {
    
    return [
      {
        'title': 'Harry Potter và Hòn Đá Phù Thủy',
        'author': 'J.K. Rowling',
        'rating': 4.8,
        'coverAsset': AssetHelper.harryPotterCover,
        'releaseDate': '1997',
        'category': 'Tiểu thuyết, Kỳ ảo',
        'matchScore': 95,
      },
      {
        'title': 'Harry Potter và Phòng Chứa Bí Mật',
        'author': 'J.K. Rowling',
        'rating': 4.7,
        'coverAsset': AssetHelper.harryPotterCover,
        'releaseDate': '1998',
        'category': 'Tiểu thuyết, Kỳ ảo',
        'matchScore': 90,
      },
      {
        'title': 'Harry Potter và Tù Nhân Azkaban',
        'author': 'J.K. Rowling',
        'rating': 4.9,
        'coverAsset': AssetHelper.harryPotterCover,
        'releaseDate': '1999',
        'category': 'Tiểu thuyết, Kỳ ảo',
        'matchScore': 85,
      },
      {
        'title': 'Harry Potter và Chiếc Cốc Lửa',
        'author': 'J.K. Rowling',
        'rating': 4.7,
        'coverAsset': AssetHelper.harryPotterCover,
        'releaseDate': '2000',
        'category': 'Tiểu thuyết, Kỳ ảo',
        'matchScore': 80,
      },
      {
        'title': 'Harry Potter và Hội Phượng Hoàng',
        'author': 'J.K. Rowling',
        'rating': 4.6,
        'coverAsset': AssetHelper.harryPotterCover,
        'releaseDate': '2003',
        'category': 'Tiểu thuyết, Kỳ ảo',
        'matchScore': 75,
      },
      {
        'title': 'Harry Potter và Hoàng Tử Lai',
        'author': 'J.K. Rowling',
        'rating': 4.8,
        'coverAsset': AssetHelper.harryPotterCover,
        'releaseDate': '2005',
        'category': 'Tiểu thuyết, Kỳ ảo',
        'matchScore': 70,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    
    final filteredBooks = _filterBooks(widget.keyword);

    return Scaffold(
      body: AppBarContainerWidget(
        titleString: "Kết quả tìm kiếm",
        
        bottomWidget: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: widget.keyword,
              prefixIcon: Icon(Icons.search, color: Color(0xff6357CC)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              suffixIcon: Icon(Icons.mic, color: Color(0xff6357CC)),
            ),
          ),
        ),
        paddingContent: EdgeInsets.symmetric(
          horizontal: kMediumPadding,
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(
              'Kết quả cho "${widget.keyword}"',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A5AE0),
              ),
            ),
            SizedBox(height: 4),

            
            Text(
              'Tìm thấy ${filteredBooks.length} sách',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),

            
            _buildToolbar(),
            SizedBox(height: 16),

            
            Expanded(
              child: _isGridView
                  ? _buildGridView(filteredBooks)
                  : _buildListView(filteredBooks),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildToolbar() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  offset: Offset(0, 40),
                  onSelected: (String value) {
                    setState(() {
                      _sortOption = value;
                    });
                  },
                  itemBuilder: (context) {
                    return _sortOptions.map((String option) {
                      return PopupMenuItem<String>(
                        value: option,
                        child: Row(
                          children: [
                            Icon(
                              option == _sortOption ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                              color: Color(0xFF6A5AE0),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              option,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: option == _sortOption ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Color(0xFFf8f8f8), Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort,
                          size: 18,
                          color: Color(0xFF6A5AE0),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Sắp xếp: $_sortOption',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF6A5AE0),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              
              Container(
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isGridView = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: _isGridView
                                  ? Color(0xFF6A5AE0)
                                  : Colors.white,
                              gradient: _isGridView
                                  ? LinearGradient(
                                colors: [Color(0xFF8F67E8), Color(0xFF6357CC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                                  : null,
                            ),
                            child: Icon(
                              Icons.grid_view_rounded,
                              size: 20,
                              color: _isGridView ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),

                    
                    ClipRRect(
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isGridView = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: !_isGridView
                                  ? Color(0xFF6A5AE0)
                                  : Colors.white,
                              gradient: !_isGridView
                                  ? LinearGradient(
                                colors: [Color(0xFF8F67E8), Color(0xFF6357CC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                                  : null,
                            ),
                            child: Icon(
                              Icons.view_list_rounded,
                              size: 20,
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
          ),

        ],
      ),
    );
  }


  
  Widget _buildGridView(List<Map<String, dynamic>> books) {
    return GridView.builder(
      padding: EdgeInsets.only(bottom: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
                context,
                PreviewScreen.routeName,
                arguments: book['title']
            );
          },
          child: _buildGridBookItem(book),
        );
      },
    );
  }

  
  Widget _buildGridBookItem(Map<String, dynamic> book) {
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
                child: ImageHelper.loadFromAsset(
                  book['coverAsset'],
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Color(0xFF6A5AE0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${book['matchScore']}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                  book['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),

                
                Text(
                  book['author'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),

                
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 14,
                    ),
                    SizedBox(width: 2),
                    Text(
                      '${book['rating']}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      book['releaseDate'],
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
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

  
  Widget _buildListView(List<Map<String, dynamic>> books) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 16),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
                context,
                PreviewScreen.routeName,
                arguments: book['title']
            );
          },
          child: _buildListBookItem(book),
        );
      },
    );
  }

  
  Widget _buildListBookItem(Map<String, dynamic> book) {
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
                child: ImageHelper.loadFromAsset(
                  book['coverAsset'],
                  width: 100,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Color(0xFF6A5AE0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${book['matchScore']}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                    book['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),

                  
                  Text(
                    book['author'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),

                  
                  Text(
                    book['category'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),

                  
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          SizedBox(width: 2),
                          Text(
                            '${book['rating']}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Xuất bản: ${book['releaseDate']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
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
    );
  }
}