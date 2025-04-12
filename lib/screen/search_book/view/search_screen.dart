import 'package:flutter/material.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/screen/search_result_screen/view/search_result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const String routeName = "/searchScreen";
  @override
  State<SearchScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SearchScreen> {
  final TextEditingController _keywordController = TextEditingController();
  // Danh sách tìm kiếm gần đây 
  final List<String> recentSearches = [
    "Harry Potter",
    "Lord of the Rings",
    "Doraemon",
    "Naruto",
  ];

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  void _search() {
    final String keyword = _keywordController.text.trim();
    if (keyword.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => SearchResultScreen(keyword: keyword),
        //  builder: (context) => SearchResultScreen(),
        ),
      );
    }
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
                padding: const EdgeInsets.symmetric(horizontal: kItemPadding),
                child: Text(
                  "Tìm kiếm gần đây",
                  style: TextStyles.defaultStyle.bold.copyWith(fontSize: 16),
                ),
              ),
              //SizedBox(height: kDefaultPadding / 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kItemPadding),
                child: ListView.builder(
                  shrinkWrap: true, // Giới hạn chiều cao theo nội dung
                  physics: NeverScrollableScrollPhysics(), // Tắt cuộn riêng của ListView
                  itemCount: recentSearches.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero, // Xóa padding mặc định
                      title: Text(
                        recentSearches[index],
                        style: TextStyles.defaultStyle.copyWith(fontSize: 14),
                      ),
                      onTap: () {
                        _keywordController.text = recentSearches[index]; // Điền từ khóa vào TextField
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