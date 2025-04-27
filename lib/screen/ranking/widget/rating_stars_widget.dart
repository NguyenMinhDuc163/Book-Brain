import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/core/constants/color_constants.dart';
import '../../../utils/core/helpers/asset_helper.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int totalStars;
  final double starWidth;
  final double starHeight;
  final Color activeColor;
  final Color inactiveColor;
  final String activeStar;
  final String inactiveStar;
  final String? halfStar; // Asset cho nửa sao (tùy chọn)

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
    this.halfStar, // Tham số tùy chọn cho nửa sao
  }) :
        assert(rating >= 0 && rating <= totalStars, 'Rating phải nằm trong khoảng 0 và tổng số sao'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalStars, (index) {
        // Xác định trạng thái sao: đầy, nửa, hoặc không có
        final double difference = rating - index;

        // Sao đầy nếu chênh lệch >= 1.0
        if (difference >= 1.0) {
          return SvgPicture.asset(
            activeStar,
            width: starWidth,
            height: starHeight,
            colorFilter: ColorFilter.mode(
                activeColor,
                BlendMode.srcIn
            ),
          );
        }
        // Nửa sao nếu chênh lệch nằm trong khoảng (0.0, 1.0)
        else if (difference > 0.0) {
          // Nếu có asset nửa sao được cung cấp
          if (halfStar != null) {
            return SvgPicture.asset(
              halfStar!,
              width: starWidth,
              height: starHeight,
              colorFilter: ColorFilter.mode(
                  activeColor,
                  BlendMode.srcIn
              ),
            );
          } else {
            // Nếu không có asset nửa sao, tạo một widget Stack để hiển thị nửa sao
            return Stack(
              children: [
                // Nền không tích cực
                SvgPicture.asset(
                  inactiveStar,
                  width: starWidth,
                  height: starHeight,
                  colorFilter: ColorFilter.mode(
                      inactiveColor,
                      BlendMode.srcIn
                  ),
                ),
                // Phần được tô màu tích cực
                ClipRect(
                  clipper: StarClipper(clipFactor: difference),
                  child: SvgPicture.asset(
                    activeStar,
                    width: starWidth,
                    height: starHeight,
                    colorFilter: ColorFilter.mode(
                        activeColor,
                        BlendMode.srcIn
                    ),
                  ),
                ),
              ],
            );
          }
        }
        // Không có sao
        else {
          return SvgPicture.asset(
            inactiveStar,
            width: starWidth,
            height: starHeight,
            colorFilter: ColorFilter.mode(
                inactiveColor,
                BlendMode.srcIn
            ),
          );
        }
      }),
    );
  }
}

// Custom clipper để cắt một phần của ngôi sao
class StarClipper extends CustomClipper<Rect> {
  final double clipFactor;

  StarClipper({required this.clipFactor});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * clipFactor, size.height);
  }

  @override
  bool shouldReclip(StarClipper oldClipper) {
    return clipFactor != oldClipper.clipFactor;
  }
}