import 'package:book_brain/screen/detail_book/view/detail_book_screen.dart';
import 'package:book_brain/screen/detail_book/widget/bottom_sheet_selector.dart';
import 'package:book_brain/screen/login/widget/button_widget.dart';
import 'package:book_brain/screen/preview/widget/item_utility_widget.dart';
import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/mock_data.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  static const String routeName = '/preview_screen';
  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _dangTheoDoi = false;
  final List<String> _chapters = MockData.mockChapters;
  String _selectedChapter = "-- Harry Potter và Hòn đá phù thủy - Chương 01";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ImageHelper.loadFromAsset(AssetHelper.harryPotterCover,
                fit: BoxFit.fill),
          ),
          Positioned(
              top: kMediumPadding * 3,
              left: kMediumPadding,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(kItemPadding),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(kDefaultPadding)),
                    color: Colors.white,
                  ),
                  child: Icon(
                    FontAwesomeIcons.arrowLeft,
                    size: 18,
                  ),
                ),
              )),
          Positioned(
              top: kMediumPadding * 3,
              right: kMediumPadding,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(kItemPadding),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(kDefaultPadding)),
                    color: Colors.white,
                  ),
                  child: Icon(
                    FontAwesomeIcons.solidHeart,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
              )),
          DraggableScrollableSheet(
            // mot man hinh nho co the keo len kheo xuong
            initialChildSize: 0.3,
            maxChildSize: 0.8,
            minChildSize: 0.3,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: kMediumPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(kDefaultPadding * 2),
                    topRight: Radius.circular(kDefaultPadding * 2),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: kDefaultPadding),
                      child: Container(
                        height: 5,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(kItemPadding)),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Harry Potter và Hòn đá phù thủy",
                                  maxLines: 2,
                                  style: TextStyles.defaultStyle.fontHeader.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: width_16,),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _dangTheoDoi = !_dangTheoDoi;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _dangTheoDoi ?  Color(0xFFBB86FC) : ColorPalette.colorGreen,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                       Text(
                                        _dangTheoDoi ? 'Theo dõi' : 'Đã theo dõi',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        _dangTheoDoi ? Icons.add : Icons.check,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          Row(
                            children: [
                               Icon(
                                FontAwesomeIcons.user,
                                size: 18,
                              ),
                              SizedBox(
                                width: kMinPadding,
                              ),
                              Text(
                                  "J. K. Rowling",
                              )
                            ],
                          ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          Row(
                            children: [
                              ImageHelper.loadFromAsset(AssetHelper.icoStar),
                              SizedBox(
                                width: kMinPadding,
                              ),
                              Text(
                                '4.2/5 ',
                              ),
                              Text(
                                '(2456 đánh giá)',
                                style: TextStyle(
                                    color: ColorPalette.subTitleColor),
                              )
                            ],
                          ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          Text(
                            'Thể loại',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          Text(
                            'Văn học phương Tây, Phiêu lưu, Hành động.',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          // ItemUtilityWidge(),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          Text(
                            'Mô tả',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          Text(
                            MockData.describe,
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          // ImageHelper.loadFromAsset(AssetHelper.imageMap),
                          // SizedBox(
                          //   height: kDefaultPadding * 2,
                          // ),
                          BottomSheetSelector(
                            title: 'Chọn chương sách',
                            items: _chapters,
                            selectedValue: _selectedChapter,
                            onValueChanged: (value) {
                              setState(() {
                                _selectedChapter = value;
                              });
                            },
                            placeholder: 'Vui lòng chọn chương sách',
                          ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          ButtonWidget(
                            title: 'Bắt đầu đọc',
                            ontap: () {
                              Navigator.of(context)
                                  .pushNamed(DetailBookScreen.routeName);
                            },
                          ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    ;
  }
}
