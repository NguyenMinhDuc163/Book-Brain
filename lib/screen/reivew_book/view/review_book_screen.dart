import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/reivew_book/widget/feedBack_widget.dart';
import 'package:book_brain/utils/core/common/toast.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../utils/widget/loading_widget.dart';
import '../provider/review_book_notifier.dart';
import '../widget/evaluation_widget.dart';
import '../../../service/api_service/response/all_review_response.dart';

class ReviewBookScreen extends StatefulWidget {
  ReviewBookScreen({super.key, this.bookId});
  int? bookId;
  static const String routeName = '/review_book_screen';

  @override
  State<ReviewBookScreen> createState() => _ReviewBookScreenState();
}

class _ReviewBookScreenState extends State<ReviewBookScreen> {
  int _userRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _hasUserReviewed = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ReviewBookNotifier>(
        context,
        listen: false,
      ).getData(widget.bookId ?? 1),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Hàm tính thời gian đã trôi qua
  String _getTimeAgo(String? dateTimeString) {
    if (dateTimeString == null) return "0 phút trước";

    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      DateTime now = DateTime.now();
      Duration difference = now.difference(dateTime);

      if (difference.inDays > 365) {
        return "${(difference.inDays / 365).floor()} năm trước";
      } else if (difference.inDays > 30) {
        return "${(difference.inDays / 30).floor()} tháng trước";
      } else if (difference.inDays > 0) {
        return "${difference.inDays} ngày trước";
      } else if (difference.inHours > 0) {
        return "${difference.inHours} giờ trước";
      } else if (difference.inMinutes > 0) {
        return "${difference.inMinutes} phút trước";
      } else {
        return "Vừa xong";
      }
    } catch (e) {
      return "0 phút trước";
    }
  }

  void _showReviewBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (statefulContext, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(statefulContext).viewInsets.bottom,
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
                            index < _userRating
                                ? Icons.star
                                : Icons.star_border,
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
                        hintText:
                            'Chia sẻ cảm nhận của bạn về cuốn sách này...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6A5AE0),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          _userRating > 0
                              ? () async {
                                // Lưu tham chiếu đến các giá trị cần thiết
                                final reviewNotifier =
                                    Provider.of<ReviewBookNotifier>(
                                      this.context,
                                      listen: false,
                                    );
                                final bookId = widget.bookId ?? 1;
                                final rating = _userRating.toInt() ?? 5;
                                final comment = _commentController.text;

                                // Đóng bottom sheet trước
                                Navigator.pop(bottomSheetContext);

                                // Sau đó xử lý đánh giá với tham chiếu đã lưu
                                bool isSubmit = await reviewNotifier
                                    .createReview(
                                      bookId: bookId,
                                      rating: rating,
                                      comment: comment,
                                    );

                                if (isSubmit) {
                                  showToastTop(
                                    message: "Cảm ơn bạn đã đánh giá!",
                                  );
                                  // Reset form
                                  _userRating = 0;
                                  _commentController.clear();
                                  // Cập nhật lại toàn bộ dữ liệu
                                  await reviewNotifier.getData(bookId);
                                } else {
                                  showToastTop(
                                    message: "Đánh giá không thành công!",
                                  );
                                }
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6A5AE0),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Gửi đánh giá',
                        style: TextStyle(color: Colors.white, fontSize: 16),
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

  // Hàm hiển thị menu xóa/sửa đánh giá
  void _showReviewOptions(AllReviewResponse review) {
    final currentUserId = LocalStorageHelper.getValue("userId") ?? "1";

    // Chỉ hiển thị menu nếu là bình luận của người dùng hiện tại
    if (review.userId != currentUserId) {
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: Color(0xFF6A5AE0)),
                title: Text('Sửa đánh giá'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditReviewSheet(review);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Xóa đánh giá'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteReview(review);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm hiển thị bottom sheet sửa đánh giá
  void _showEditReviewSheet(AllReviewResponse review) {
    _userRating = int.tryParse(review.rating.toString()) ?? 0;
    _commentController.text = review.comment ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (statefulContext, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(statefulContext).viewInsets.bottom,
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
                      'Sửa đánh giá',
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
                            index < _userRating
                                ? Icons.star
                                : Icons.star_border,
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
                        hintText:
                            'Chia sẻ cảm nhận của bạn về cuốn sách này...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6A5AE0),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          _userRating > 0
                              ? () async {
                                final reviewNotifier =
                                    Provider.of<ReviewBookNotifier>(
                                      this.context,
                                      listen: false,
                                    );
                                final bookId = widget.bookId ?? 1;
                                final rating = _userRating.toInt() ?? 5;
                                final comment = _commentController.text;

                                Navigator.pop(bottomSheetContext);

                                bool isSubmit = await reviewNotifier
                                    .createReview(
                                      bookId: bookId,
                                      rating: rating,
                                      comment: comment,
                                    );

                                if (isSubmit) {
                                  showToastTop(
                                    message: "Cập nhật đánh giá thành công!",
                                  );
                                  _userRating = 0;
                                  _commentController.clear();
                                  await reviewNotifier.getData(bookId);
                                } else {
                                  showToastTop(
                                    message: "Cập nhật đánh giá thất bại!",
                                  );
                                }
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6A5AE0),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cập nhật đánh giá',
                        style: TextStyle(color: Colors.white, fontSize: 16),
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

  // Hàm xác nhận xóa đánh giá
  void _confirmDeleteReview(AllReviewResponse review) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Xóa đánh giá"),
            content: Text("Bạn có chắc muốn xóa đánh giá này không?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Hủy"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final reviewNotifier = Provider.of<ReviewBookNotifier>(
                    context,
                    listen: false,
                  );
                  bool isSuccess = await reviewNotifier.deleteReview(
                    reviewId: review.reviewId ?? 0,
                  );

                  if (isSuccess) {
                    showToastTop(message: "Xóa đánh giá thành công!");
                    await reviewNotifier.getData(widget.bookId ?? 1);
                  } else {
                    showToastTop(message: "Xóa đánh giá thất bại!");
                  }
                },
                child: Text("Xóa", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  // Kiểm tra xem người dùng đã đánh giá chưa
  void _checkUserReview(List<AllReviewResponse>? reviews) {
    if (reviews == null) return;

    final currentUserId = LocalStorageHelper.getValue("userId") ?? "1";

    _hasUserReviewed = reviews.any((review) => review.userId == currentUserId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ReviewBookNotifier>(context);

    // Kiểm tra đánh giá của người dùng khi danh sách thay đổi
    if (presenter.reviews != null) {
      _checkUserReview(presenter.reviews);
    }

    return Scaffold(
      body: Stack(
        children: [
          AppBarContainerWidget(
            titleString: 'Đánh giá',
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hiển thị thống kê đánh giá
                  EvaluationWidget(
                    averageRating: presenter.statsReview?.averageRating,
                    totalReviews: presenter.statsReview?.totalReviews,
                    fiveStarCount: presenter.statsReview?.fiveStar,
                    fourStarCount: presenter.statsReview?.fourStar,
                    threeStarCount: presenter.statsReview?.threeStar,
                    twoStarCount: presenter.statsReview?.twoStar,
                    oneStarCount: presenter.statsReview?.oneStar,
                  ),
                  const SizedBox(height: kDefaultPadding),

                  // Hiển thị danh sách đánh giá từ API
                  if (presenter.reviews != null &&
                      presenter.reviews!.isNotEmpty)
                    ...presenter.reviews!
                        .map(
                          (review) => Column(
                            children: [
                              FeedBackWidget(
                                avatar:
                                    (review.avatarUrl ?? '') != ''
                                        ? review.avatarUrl ?? ""
                                        : AssetHelper.avatar,
                                name: review.username ?? '',
                                rate:
                                    int.tryParse(review.rating.toString()) ?? 5,
                                comment: review.comment ?? "",
                                image:
                                    const [], // Hiện tại API không có hình ảnh
                                time: _getTimeAgo(review.createdAt.toString()),
                                helpfulCount:
                                    int.tryParse(review.helpfulCount ?? '0') ??
                                    0,
                                onMorePressed:
                                    review.userId ==
                                            LocalStorageHelper.getValue(
                                              "userId",
                                            )
                                        ? () => _showReviewOptions(review)
                                        : null,
                              ),
                              const SizedBox(height: kDefaultPadding),
                            ],
                          ),
                        )
                        .toList()
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Chưa có đánh giá nào cho sách này",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          presenter.isLoading ? const LoadingWidget() : const SizedBox(),
        ],
      ),
      floatingActionButton:
          _hasUserReviewed
              ? null
              : FloatingActionButton(
                onPressed: _showReviewBottomSheet,
                backgroundColor: Color(0xFF6A5AE0),
                child: Icon(Icons.rate_review, color: Colors.white),
              ),
    );
  }
}
