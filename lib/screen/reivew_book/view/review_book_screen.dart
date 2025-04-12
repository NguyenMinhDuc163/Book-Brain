import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/reivew_book/widget/feedBack_widget.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:flutter/material.dart';

import '../../../utils/core/constants/mock_data.dart' show MockData;
import '../widget/evaluation_widget.dart';

class ReviewBookScreen extends StatefulWidget {
  const ReviewBookScreen({super.key});
  static const String routeName = '/review_book_screen';

  @override
  State<ReviewBookScreen> createState() => _ReviewBookScreenState();
}

class _ReviewBookScreenState extends State<ReviewBookScreen> {
  double _userRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showReviewBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Đánh giá của bạn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _userRating ? Icons.star : Icons.star_border,
                            color: Color(0xFFFFC107),
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              _userRating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _commentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Chia sẻ cảm nhận của bạn về cuốn sách này...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6A5AE0), width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () {
                            
                          },
                        ),
                        Text('Thêm hình ảnh (tùy chọn)'),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _userRating > 0 ? () {
                        
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cảm ơn bạn đã đánh giá!')),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6A5AE0),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Gửi đánh giá',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBarContinerWidget(
        titleString: 'Reviews',
        child: SingleChildScrollView(
          child: Column(
            children: [
              const EvaluationWidget(score: 4.9),
              const SizedBox(height: kDefaultPadding),
              const FeedBackWidget(
                avatar: AssetHelper.avatar,
                name: 'Nguyen Minh Duc',
                rate: 4,
                comment: MockData.rv1,
                image: [AssetHelper.harryPotterCover, AssetHelper.harryPotterCover],
                time: 24,
              ),
              const SizedBox(height: kDefaultPadding),
              const FeedBackWidget(
                avatar: AssetHelper.avatar,
                name: 'Nguyen Van Nam',
                rate: 4,
                comment: MockData.rv2,
                image: [AssetHelper.harryPotterCover, AssetHelper.harryPotterCover],
                time: 11,
              ),
              const SizedBox(height: kDefaultPadding),
              const FeedBackWidget(
                avatar: AssetHelper.avatar,
                name: 'Hoang Son Hai',
                rate: 5,
                comment: MockData.rv3,
                image: [AssetHelper.harryPotterCover, AssetHelper.harryPotterCover],
                time: 43,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showReviewBottomSheet,
        backgroundColor: Color(0xFF6A5AE0),
        child: Icon(Icons.rate_review, color: Colors.white),
      ),
    );
  }
}