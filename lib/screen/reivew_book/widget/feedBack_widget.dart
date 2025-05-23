import 'package:expandable/expandable.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/utils/widget/dash_line_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:book_brain/utils/core/constants/avatar_colors.dart';

class FeedBackWidget extends StatefulWidget {
  const FeedBackWidget({
    Key? key,
    required this.avatar,
    required this.name,
    required this.rate,
    required this.comment,
    required this.image,
    required this.time,
    this.helpfulCount = 0,
    this.onMorePressed,
  }) : super(key: key);

  final String avatar;
  final String name;
  final int rate;
  final String comment;
  final List<String> image;
  final String time;
  final int helpfulCount;
  final VoidCallback? onMorePressed;

  @override
  _FeedBackWidgetState createState() => _FeedBackWidgetState();
}

class _FeedBackWidgetState extends State<FeedBackWidget> {
  bool _isLiked = false;
  bool _isDisLike = false;

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return "Vừa xong";

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
      return "Vừa xong";
    }
  }

  List<Widget> _buildStarIcons() {
    List<Widget> starWidgets = [];

    for (int i = 0; i < widget.rate; i++) {
      starWidgets.add(
        Padding(
          padding: EdgeInsets.only(right: 2),
          child: ImageHelper.loadFromAsset(AssetHelper.icoStar),
        ),
      );
    }

    return starWidgets;
  }

  Widget _buildCollapsed() {
    if (widget.comment.length <= 100) {
      return Text(widget.comment, softWrap: true);
    }
    return Text(
      widget.comment.substring(0, 100) + '...',
      softWrap: true,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildExpanded() {
    return Text(widget.comment, softWrap: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(kItemPadding)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar (hỗ trợ cả local asset và network image)
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    widget.avatar.contains('http')
                        ? null
                        : getColorFromName(widget.name),
                backgroundImage:
                    widget.avatar.contains('http')
                        ? NetworkImage(widget.avatar) as ImageProvider
                        : AssetImage(widget.avatar),
                onBackgroundImageError: (_, __) {
                  // Fallback khi lỗi load ảnh
                  AssetImage(AssetHelper.avatar);
                },
                child:
                    widget.avatar.contains('http')
                        ? null
                        : Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.time, style: TextStyle(fontSize: 10)),
                ],
              ),
              Spacer(),
              Row(children: _buildStarIcons()),
            ],
          ),

          SizedBox(height: 12),

          if (widget.image.isNotEmpty)
            Wrap(
              spacing: 8,
              children:
                  widget.image
                      .map(
                        (e) => ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child:
                                e.startsWith('http')
                                    ? Image.network(
                                      e,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              ImageHelper.loadFromAsset(
                                                AssetHelper.defaultImage,
                                              ),
                                    )
                                    : ImageHelper.loadFromAsset(e),
                          ),
                        ),
                      )
                      .toList(),
            ),

          SizedBox(height: 12),

          ExpandableNotifier(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expandable(
                  collapsed: _buildCollapsed(),
                  expanded: _buildExpanded(),
                ),
                // Chỉ hiển thị nút "Xem thêm" nếu comment đủ dài
                if (widget.comment.length > 100)
                  Builder(
                    builder: (context) {
                      var controller = ExpandableController.of(context);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              controller?.toggle();
                            },
                            child: Text(
                              controller!.expanded ? "Thu gọn" : "Xem thêm",
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),

          DashLineWidget(),

          Row(
            children: [
              // Thông tin về thời gian đánh giá
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    _formatDateTime(widget.time),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              Spacer(),
              // Nút tùy chọn
              if (widget.onMorePressed != null)
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: widget.onMorePressed,
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReportOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Tùy chọn'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã báo cáo đánh giá này')),
                );
              },
              child: Text('Báo cáo đánh giá này'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}
