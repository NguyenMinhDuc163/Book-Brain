import 'package:flutter/material.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/screen/search_result_screen/view/search_result_screen.dart'; 
import '../../login/widget/button_widget.dart' show ButtonWidget; 

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const String routeName = "/searchScreen";
  @override
  State<SearchScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SearchScreen> {
  final TextEditingController _keywordController = TextEditingController();

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
          //builder: (context) => SearchResultScreen(keyword: keyword),
          builder: (context) => SearchResultScreen(),
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
            spacing: 5,
            children: [
              //SizedBox(height: kDefaultPadding * 3),
              TextField(
                controller: _keywordController, // Gắn controller
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm cuốn sách của bạn',
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
                  _search(); // Tìm kiếm khi nhấn Enter trên bàn phím
                },
              ),
              SizedBox(height: kDefaultPadding),
              
            ],
          ),
        ),
      ),
    );
  }
}