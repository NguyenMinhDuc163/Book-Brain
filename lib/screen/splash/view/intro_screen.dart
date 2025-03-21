import 'dart:async';

import 'package:book_brain/screen/login/widget/button_widget.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/utils/router_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});
  static String routeName = '/intro_screen';
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  final StreamController<int> _streamController = StreamController<int>();

  // tao ra widget dung trung: truyen cac tham so
  Widget _buildItemIntroScreen(String image, String title, String descripton,
      AlignmentGeometry alignmentDirectional) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            alignment: alignmentDirectional,
            child: ImageHelper.loadFromAsset(image,
                height: 400, fit: BoxFit.fitHeight)),
        const SizedBox(
          height: kMediumPadding * 2, // cach khoang 50 px
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kMediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.defaultStyle.bold,
              ),
              const SizedBox(
                height: kMediumPadding, // cach khoang 50 px
              ),
              Text(
                descripton,
                style: TextStyles.defaultStyle,
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController.addListener(() {
      _streamController.add(_pageController.page!.toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: [
                _buildItemIntroScreen(
                    AssetHelper.slide1,
                    "Khám phá thế giới qua những trang sách",
                    'Đắm chìm vào thế giới với những câu chuyện bất tận. Hãy khám phá những cuốn sách tuyệt vời ngay hôm nay!',
                    Alignment.centerRight),
                _buildItemIntroScreen(
                    AssetHelper.slide2,
                    "Gợi ý cá nhân hóa",
                    'Dựa trên sở thích của bạn, chúng tôi mang đến những cuốn sách mà bạn sẽ yêu thích. Hãy bắt đầu chương mới của bạn ngay hôm nay!',
                    Alignment.centerRight),
                _buildItemIntroScreen(
                    AssetHelper.slide3,
                    "Bắt đầu đọc",
                    'Cuộc phiêu lưu tiếp theo đang chờ đón bạn. Cầm một cuốn sách lên và bắt đầu đọc ngay thôi!',
                    Alignment.centerLeft),
              ],
            ),
            Positioned(
              left: kMediumPadding,
              right: kMediumPadding,
              bottom: kMediumPadding * 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        dotWidth: kMinPadding,
                        dotHeight: kMinPadding,
                        activeDotColor: Colors.orange,
                      ),
                    ),
                  ),
                  StreamBuilder<int>(
                    // neu dung nhu the nay chi rendew buttom chu khong render ca man hinh
                      stream: _streamController.stream,
                      initialData: 0, // tranh gt null
                      builder: (context, snapshot) {
                        return Expanded(
                          flex: 4,
                          child: ButtonWidget(
                            title: (snapshot.data != 2) ? 'Tiếp theo' : 'Bắt đầu',
                            ontap: () {
                              if (_pageController.page != 2) {
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInSine);
                              } else {
                                Navigator.of(context).pushNamed(RouteNames.loginScreen);
                              }
                            },
                          ),
                        );
                      }),
                ],
              ),
            )
          ],
        ));
  }
}
