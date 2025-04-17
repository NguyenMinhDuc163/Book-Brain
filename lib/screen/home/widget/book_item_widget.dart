
import 'package:book_brain/screen/preview/view/preview_screen.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart' show ExtendedTextStyle, TextStyles;
import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final String name;
  final String image;
  final int rating;

  const BookItem({
    Key? key,
    required this.name,
    required this.image,
    this.rating = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Container(
            width: 140,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          
          Container(
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
                starIndex < rating ? Icons.star : Icons.star_border,
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
    Key? key,
    required this.title,
    this.seeAllText = 'Tất cả',
    required this.books,
    this.onSeeAllPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

        
        Container(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              int rate = int.tryParse((book.rating ?? '10/10').split('/')[0]) ?? 4;
              return InkWell(
                onTap: (){
                  Navigator.pushNamed(context, PreviewScreen.routeName);
                },
                child: BookItem(
                  name: book.title ?? "",
                  image: book.imageUrl ?? "",
                  rating: rate,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}