import 'package:flutter/material.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/screen/search_result_screen/view/search_result_screen.dart';
import 'package:intl/intl.dart'; 

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const String routeName = "/searchScreen";
  @override
  State<SearchScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SearchScreen> {
  final TextEditingController _keywordController = TextEditingController();
  // Danh sách tìm kiếm gần đây 
  final List<Map<String, dynamic>> recentSearches = [
    {'keyword': 'Harry Potter', 'timestamp': DateTime.now().subtract(Duration(days: 3))},
    {'keyword': 'Lord of the Rings', 'timestamp': DateTime.now().subtract(Duration(days: 2))},
    {'keyword': 'Doraemon', 'timestamp': DateTime.now().subtract(Duration(days: 1))},
    {'keyword': 'Naruto', 'timestamp': DateTime.now()},
  ];

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  void _search() {
    final String keyword = _keywordController.text.trim();
    if (keyword.isNotEmpty) {
      setState(() {
        // Kiểm tra xem từ khóa đã có chưa
        int existingIndex = recentSearches.indexWhere((item) => item['keyword'].toLowerCase() == keyword.toLowerCase());
        if (existingIndex != -1) {
          // Nếu từ khóa đã có, cập nhật 
          recentSearches.removeAt(existingIndex);
          recentSearches.insert(0, {'keyword': keyword, 'timestamp': DateTime.now()});
        } else {
          // Nếu từ khóa mới, thêm vào đầu
          recentSearches.insert(0, {'keyword': keyword, 'timestamp': DateTime.now()});
        }
        // Sắp xếp theo timestamp giảm dần
        recentSearches.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
      });

      // Giả lập lưu vào CSDL
      _saveToDatabase();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(keyword: keyword),
        ),
      );
    }
  }

  void _removeSearch(int index) {
    setState(() {
      recentSearches.removeAt(index);
      // Giả lập cập nhật CSDL
      _saveToDatabase();
    });
  }

  // Giả lập lưu vào CSDL
  void _saveToDatabase() {
    
    print('Lưu vào CSDL: $recentSearches');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: AppBarContinerWidget(
        titleString: "Tìm kiếm sách",
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: kDefaultPadding * 2),
              TextField(
                controller: _keywordController,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Nhập tựa đề sách / tác giả',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: Colors.black,
                      size: 14,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Icon(
                        FontAwesomeIcons.forward,
                        size: 14,
                      ),
                      onTap: () => _search(),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(kItemPadding)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: kItemPadding),
                ),
                style: TextStyles.defaultStyle,
                onSubmitted: (value) {
                  _search();
                },
              ),
              SizedBox(height: kDefaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kItemPadding, vertical: 0),
                child: Text(
                  "Tìm kiếm gần đây",
                  style: TextStyles.defaultStyle.bold.copyWith(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kItemPadding, vertical: 0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: recentSearches.length,
                  itemBuilder: (context, index) {
                    final searchItem = recentSearches[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: kItemPadding),
                      title: Text(
                        searchItem['keyword'],
                        style: TextStyles.defaultStyle.copyWith(fontSize: 14),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.xmark,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () => _removeSearch(index),
                      ),
                      onTap: () {
                        _keywordController.text = searchItem['keyword'];
                        _search();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}