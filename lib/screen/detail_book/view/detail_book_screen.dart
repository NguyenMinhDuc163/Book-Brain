import 'package:book_brain/screen/detail_book/widget/bottom_sheet_selector.dart';
import 'package:book_brain/screen/home/view/home_screen.dart';
import 'package:book_brain/screen/main_app.dart';
import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailBookScreen extends StatefulWidget {
  const DetailBookScreen({super.key});
  static const String routeName = "/detailBookScreen";
  @override
  State<DetailBookScreen> createState() => _DetailBookScreenState();
}

class _DetailBookScreenState extends State<DetailBookScreen> {
  String _selectedChapter = "-- Harry Potter và Hòn đá phù thủy - Chương 01";
  final ScrollController _scrollController = ScrollController();

  // Danh sách các mục chương sách
  final List<String> _chapters = MockData.mockChapters;

  Widget _buttonWidget(String text, Function ()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding_10),
          decoration: BoxDecoration(
              color: ColorPalette.kAccent5,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: ColorPalette.kAccent1.withOpacity(0.2),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ]
          ),
          child: Text(text, style: TextStyle(fontSize: fontSize_13sp),),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundColor,
      body: Column(
        children: [
          // Phần header cố định
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + height_20,
                left: width_25,
                right: width_25,
                bottom: height_20
            ),
            child: Column(
              children: [
                // Nút quay lại và home
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(
                        FontAwesomeIcons.arrowLeft,
                        size: 20,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamedAndRemoveUntil(context, MainApp.routeName, (route) => false);
                      },
                      child: Icon(
                        FontAwesomeIcons.house,
                        size: 20,
                      ),
                    )
                  ],
                ),

                SizedBox(height: height_12),

                // Tiêu đề và chương
                Column(
                  children: [
                    Text(
                      "Harry Potter và Hòn đá phù thủy - Chương 01",
                      style: TextStyle(fontSize: fontSize_13sp),
                    ),
                    Text(
                        "Chương 1 - ĐỨA BÉ VẪN SỐNG",
                        style: TextStyle(fontSize: fontSize_15sp, color: colorRed)
                    )
                  ],
                ),
              ],
            ),
          ),

          // Phần nội dung cuộn được
          Expanded(
            child: RawScrollbar(
              thumbColor: Colors.grey.withOpacity(0.5),
              radius: Radius.circular(20),
              thickness: 15,
              thumbVisibility: true,
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: width_25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nội dung sách
                    Text(
                      MockData.contentBook,
                      style: TextStyle(
                        fontSize: fontSize_13sp,
                        height: 1.5,
                      ),
                    ),

                    // Khoảng cách trước selector
                    SizedBox(height: height_20),

                    // Bottom sheet selector
                    BottomSheetSelector(
                      title: 'Chọn chương sách',
                      items: _chapters,
                      backgroundColor: ColorPalette.backgroundColor2,
                      selectedValue: _selectedChapter,
                      onValueChanged: (value) {
                        setState(() {
                          _selectedChapter = value;
                        });
                      },
                      placeholder: 'Vui lòng chọn chương sách',
                    ),
                    SizedBox(height: height_12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buttonWidget("Chương trước", () {
                          // Logic cho nút "Chương trước"
                        }),
                        _buttonWidget("Chương sau", () {
                          // Logic cho nút "Chương sau"
                        }),
                      ],
                    ),
                    // Khoảng cách cuối cùng
                    SizedBox(height: height_50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}