import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/search_result_screen/view/search_result_screen.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const String routeName = "/searchScreen";
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _keywordController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<String> recentSearches = ['Harry Potter', 'Nguyễn Nhật Ánh'];

  List<Map<String, dynamic>> popularCategories = [
    {
      'name': 'Tiểu thuyết',
      'icon': FontAwesomeIcons.bookOpen,
      'color': Color(0xFF9C70EB),
    },
    {
      'name': 'Tâm lý học',
      'icon': FontAwesomeIcons.brain,
      'color': Color(0xFF6695EF),
    },
    {
      'name': 'Kinh doanh',
      'icon': FontAwesomeIcons.briefcase,
      'color': Color(0xFF38C9A7),
    },
  ];

  List<Map<String, dynamic>> trendingBooks = [
    {
      'title': 'Atomic Habits',
      'author': 'James Clear',
      'cover': AssetHelper.harryPotterCover,
    },
    {
      'title': 'Đắc Nhân Tâm',
      'author': 'Dale Carnegie',
      'cover': AssetHelper.harryPotterCover,
    },
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _keywordController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _search() {
    final String keyword = _keywordController.text.trim();
    if (keyword.isNotEmpty) {
      // Thêm từ khóa vào danh sách tìm kiếm gần đây nếu chưa có
      if (!recentSearches.contains(keyword)) {
        setState(() {
          recentSearches.insert(0, keyword);
          // Giữ danh sách không quá dài
          if (recentSearches.length > 5) {
            recentSearches.removeLast();
          }
        });
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(keyword: keyword),
        ),
      );
    }
  }

  void _removeRecentSearch(String search) {
    setState(() {
      recentSearches.remove(search);
    });
  }

  void _clearSearch() {
    setState(() {
      _keywordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: AppBarContainerWidget(
        titleString: "Tìm kiếm sách",
        bottomWidget: _buildSearchBar(),
        paddingContent: EdgeInsets.symmetric(
          horizontal: kMediumPadding,
          vertical: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recentSearches.isNotEmpty) ...[
                _buildRecentSearches(),
                SizedBox(height: 20),
              ],

              _buildPopularCategories(),
              SizedBox(height: 20),

              _buildTrendingBooks(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _keywordController,
        focusNode: _searchFocusNode,
        onSubmitted: (_) => _search(),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm tên sách, tác giả...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
          prefixIcon: Icon(
            FontAwesomeIcons.magnifyingGlass,
            color: Color(0xFF6A5AE0),
            size: 16,
          ),
          suffixIcon: _keywordController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: Color(0xFF6A5AE0)),
            onPressed: _clearSearch,
          )
              : Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                // Xử lý khi người dùng nhấn vào biểu tượng tìm kiếm bằng giọng nói
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6A5AE0).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.x,
                  color: Color(0xFF6A5AE0),
                  size: 16,
                ),
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        onChanged: (value) {
          // Force rebuild để hiển thị/ẩn nút xóa
          setState(() {});
        },
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tìm kiếm gần đây',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (recentSearches.isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    recentSearches.clear();
                  });
                },
                child: Text(
                  'Xóa tất cả',
                  style: TextStyle(color: Color(0xFF6A5AE0), fontSize: 14),
                ),
              ),
          ],
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
          recentSearches.map((search) {
            return GestureDetector(
              onTap: () {
                _keywordController.text = search;
                _search();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, color: Colors.grey[600], size: 16),
                    SizedBox(width: 8),
                    Text(
                      search,
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        _removeRecentSearch(search);
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPopularCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh mục phổ biến',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: height_12),
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
          children:
          popularCategories.map((category) {
            return GestureDetector(
              onTap: () {
                _keywordController.text = category['name'];
                _search();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: category['color'].withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: category['color'].withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category['icon'],
                        color: category['color'],
                        size: 24,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      category['name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTrendingBooks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xu hướng tìm kiếm',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trendingBooks.length,
            itemBuilder: (context, index) {
              final book = trendingBooks[index];
              return GestureDetector(
                onTap: () {
                  _keywordController.text = book['title'];
                  _search();
                },
                child: Container(
                  width: 120,
                  margin: EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ImageHelper.loadFromAsset(
                            book['cover'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),

                      Text(
                        book['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Text(
                        book['author'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}