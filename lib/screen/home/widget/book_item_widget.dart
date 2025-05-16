import 'package:book_brain/screen/preview/view/preview_screen.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart'
    show ExtendedTextStyle, TextStyles;
import 'package:flutter/material.dart';

import '../../../utils/core/helpers/network_image_handler.dart';

class BookItem extends StatelessWidget {
  final String name;
  final String image;
  final String rating;

  const BookItem({
    Key? key,
    required this.name,
    required this.image,
    this.rating = "5.0",
  }) : super(key: key);

  int _getRatingStars() {
    try {
      // Chuyển đổi rating từ string sang double
      final ratingValue = double.parse(rating);
      // Chuyển đổi từ thang điểm 5 sang số sao (làm tròn)
      return ratingValue.round();
    } catch (e) {
      return 5; // Giá trị mặc định nếu có lỗi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageHandler(imageUrl: image, width: 140, height: 200),
          SizedBox(height: 8),

          SizedBox(
            width: 140,
            child: Text(
              name,
              style: TextStyles.defaultStyle.bold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 4),

          Row(
            children: List.generate(
              5,
              (starIndex) => Icon(
                starIndex < _getRatingStars() ? Icons.star : Icons.star_border,
                color: Color(0xFFFFC107),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalBookList extends StatelessWidget {
  final String title;
  final String seeAllText;
  final List<BookInfoResponse> books;
  final Function()? onSeeAllPressed;

  const HorizontalBookList({
    super.key,
    required this.title,
    this.seeAllText = 'Tất cả',
    required this.books,
    this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Spacer(),
            GestureDetector(
              onTap: onSeeAllPressed,
              child: Text(
                seeAllText,
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ),
          ],
        ),
        SizedBox(height: kMediumPadding),

        SizedBox(
          height: height_180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PreviewScreen(bookId: book.bookId),
                    ),
                  );
                },
                child: BookItem(
                  name: book.title ?? "",
                  image: book.imageUrl ?? "",
                  rating: book.rating ?? "5.0",
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
