import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:flutter/material.dart';

import '../../ranking/widget/rating_stars_widget.dart';

class EvaluationWidget extends StatelessWidget {
  const EvaluationWidget({super.key, required this.score, this.reviewNum});
  final double score;
  final int? reviewNum;
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
                '$score',
                style: TextStyle(
                  fontSize: 36,
                  color: Color(0xFFFFC107),
                ),
              ),
              Text('Trên 5', style: TextStyle(fontSize: 12),),
              Text('(${reviewNum ?? 9876} Đánh giá)', style: TextStyle(fontSize: 12),),
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
                          rating: i,
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
                              widthFactor: i / 5, 
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
    );;
  }
}
