import 'package:book_brain/screen/preview/view/preview_screen.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/extentions/size_extension.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/network_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../service/api_service/response/book_ranking_response.dart';
import '../../../utils/core/constants/color_constants.dart';
import '../../../utils/core/helpers/image_helper.dart';
import '../provider/ranking_notifier.dart';
import '../widget/rating_stars_widget.dart';

class BookRankingScreen extends StatefulWidget {
  const BookRankingScreen({super.key});

  @override
  State<BookRankingScreen> createState() => _BookRankingScreenState();
}

class _BookRankingScreenState extends State<BookRankingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RankingNotifier>(context, listen: false).getData();
    });
  }


  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<RankingNotifier>(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      padding: EdgeInsets.all(kDefaultPadding),
      child:
          presenter.bookRanking == null || presenter.bookRanking!.isEmpty
              ? Center(
                child: CircularProgressIndicator(),
              ) // Hiển thị loading khi chưa có dữ liệu
              : ListView.builder(
                itemCount: presenter.bookRanking!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewScreen(bookId: presenter.bookRanking?[index].bookId ?? 1,)));
                      },
                      child: _bookWidget(index + 1, presenter.bookRanking![index]));
                },
              ),
    );
  }

  Widget _bookWidget(int index, BookRankingResponse book) {
    Color textColor = index == 1 ? ColorPalette.colorFF6B00 : Colors.black;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      padding: EdgeInsets.all(kDefaultPadding),
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Row(
        spacing: width_10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              index.toString(),
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: NetworkImageHandler(
              imageUrl: book.imageUrl,
              width: 100.h,
              height: 100.h,
            ),
          ),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: height_6,
              children: [
                Text(book.title ?? ""),
                Text(book.authorName ?? ""),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: width_2,
                    children: [
                      elementWidget("320 trang"),
                      elementWidget("2021"),
                      elementWidget(book.categoryName ?? ""),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: width_8,
                  children: [
                    Text(
                      book.rankingScore ?? "5",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height_5),
                      child: RatingStars(
                        rating: double.parse(book.rating.toString()),
                        activeStar: AssetHelper.icoStarSVG,
                        inactiveStar: AssetHelper.icoStarSVG,
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

  Widget elementWidget(String content) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width_8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Text(
        content,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
