import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/extentions/size_extension.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/core/constants/color_constants.dart';
import '../../../utils/core/helpers/image_helper.dart';
import '../widget/rating_stars_widget.dart';

class BookRankingScreen extends StatefulWidget {
  const BookRankingScreen({super.key});

  @override
  State<BookRankingScreen> createState() => _BookRankingScreenState();
}

class _BookRankingScreenState extends State<BookRankingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1, // Độ dày viền
        ),
      ),
      padding: EdgeInsets.all(kDefaultPadding),
      child: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index) {
          return _bookWidget(index + 1);
        },
      ),
    );
  }

  Widget _bookWidget(int index ){
    Color textColor = index == 1 ? ColorPalette.colorFF6B00 : Colors.black;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1, // Độ dày viền
        ),
      ),
      padding: EdgeInsets.all(kDefaultPadding),
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Row(
        spacing: width_8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: Text(index.toString(), style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold, color: textColor),)),
          Expanded(
              flex: 3,
              child: ImageHelper.loadFromAsset(AssetHelper.harryPotterCover, width: width_100, height: height_100)),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: height_4,
              children: [
                Text("Pobres criaturas"),
                Text("J.K.Rowling"),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: width_2,
                    children: [
                      elementWidget("320 trang"),
                      elementWidget("2021"),
                      elementWidget("Viễn tưởng"),
                    ],
                  ),
                ),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: width_8,
                  children: [
                    Text("7.8", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Padding(
                      padding:  EdgeInsets.only(top: height_5),
                      child: RatingStars(
                        rating: 3,
                        activeStar: AssetHelper.icoStarSVG,
                        inactiveStar: AssetHelper.icoStarSVG,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget elementWidget(String content){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width_8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey,
          width: 1, // Độ dày viền
        ),
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
