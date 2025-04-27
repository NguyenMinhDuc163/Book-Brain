import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:flutter/material.dart';

import '../../ranking/widget/rating_stars_widget.dart';

class EvaluationWidget extends StatelessWidget {
  const EvaluationWidget({
    super.key,
    this.averageRating,
    this.totalReviews,
    this.fiveStarCount,
    this.fourStarCount,
    this.threeStarCount,
    this.twoStarCount,
    this.oneStarCount,
  });

  final String? averageRating;
  final String? totalReviews;
  final String? fiveStarCount;
  final String? fourStarCount;
  final String? threeStarCount;
  final String? twoStarCount;
  final String? oneStarCount;

  // Chuyển đổi từ chuỗi sang double, mặc định là 5.0
  double get score => double.tryParse(averageRating ?? '') ?? 5.0;

  // Chuyển đổi từ chuỗi sang int, mặc định là 0
  int get reviews => int.tryParse(totalReviews ?? '') ?? 1;

  // Tính toán tỷ lệ cho mỗi mức đánh giá
  double _getRatioForStar(int star) {
    if (reviews == 0) return star == 5 ? 1.0 : 0.0; // Nếu không có đánh giá, 5 sao là 100%

    String? countStr;
    switch (star) {
      case 5: countStr = fiveStarCount; break;
      case 4: countStr = fourStarCount; break;
      case 3: countStr = threeStarCount; break;
      case 2: countStr = twoStarCount; break;
      case 1: countStr = oneStarCount; break;
      default: countStr = '0';
    }

    int count = int.tryParse(countStr ?? '') ?? 0;
    return count / reviews; // Tỷ lệ là số lượng đánh giá chia cho tổng số đánh giá
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(kItemPadding)),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                '${score.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 36,
                  color: Color(0xFFFFC107),
                ),
              ),
              Text('Trên 5', style: TextStyle(fontSize: 12),),
              Text('(${reviews} Đánh giá)', style: TextStyle(fontSize: 12),),
            ],
          ),
          SizedBox(width: kMinPadding,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for(int i = 5; i > 0; i--)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        RatingStars(
                          rating: i.toDouble(), // Chuyển đổi từ int sang double
                          activeStar: AssetHelper.icoStarSVG,
                          inactiveStar: AssetHelper.icoStarSVG,
                          starWidth: width_10,
                          starHeight: height_10,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _getRatioForStar(i),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFC107),
                                  borderRadius: BorderRadius.circular(3),
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
          ),
        ],
      ),
    );
  }
}