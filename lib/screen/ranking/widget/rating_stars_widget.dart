import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/core/constants/color_constants.dart';
import '../../../utils/core/helpers/asset_helper.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  final int totalStars;
  final double starWidth;
  final double starHeight;
  final Color activeColor;
  final Color inactiveColor;
  final String activeStar;
  final String inactiveStar;

  const RatingStars({
    Key? key,
    required this.rating,
    this.totalStars = 5,
    this.starWidth = 12,
    this.starHeight = 12,
    this.activeColor = Colors.orange,
    this.inactiveColor = ColorPalette.lavenderWhite,
    required this.activeStar,
    required this.inactiveStar,
  }) :
        assert(rating >= 0 && rating <= totalStars, 'Rating must be between 0 and total stars'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalStars, (index) {
        return SvgPicture.asset(
          index < rating ? activeStar : inactiveStar,
          width: starWidth,
          height: starHeight,
          colorFilter: ColorFilter.mode(
              index < rating ? activeColor : inactiveColor,
              BlendMode.srcIn
          ),
        );
      }),
    );
  }
}

// Ví dụ sử dụng
class RatingStarsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ví dụ hiển thị 3 sao vàng, 2 sao xám
            RatingStars(
              rating: 3,
              activeStar: AssetHelper.icoStarSVG,
              inactiveStar: AssetHelper.icoStarSVG,
            ),

            // SizedBox(height: 20),

            // Ví dụ với các tùy chọn khác
            RatingStars(
              rating: 4,
              totalStars: 5,
              starWidth: 20,
              starHeight: 20,
              activeColor: Colors.amber,
              inactiveColor: Colors.grey.shade300,
              activeStar: AssetHelper.icoStarSVG,
              inactiveStar: AssetHelper.icoStarSVG,
            ),
          ],
        ),
      ),
    );
  }
}