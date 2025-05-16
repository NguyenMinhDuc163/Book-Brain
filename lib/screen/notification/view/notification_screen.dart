import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/notification/provider/notification_notifier.dart';
import 'package:book_brain/service/api_service/response/notification_response.dart';
import 'package:book_brain/utils/core/common/toast.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/widget/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../utils/core/constants/color_constants.dart';
import '../../../utils/widget/loading_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  static const String routeName = '/notification_screen';
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<NotificationNotifier>(context, listen: false).getData(),
    );
  }

  // Hàm hiển thị bottom sheet chi tiết thông báo
  void _showNotificationDetails(NotificationResponse notification) async {
    // Đánh dấu thông báo đã đọc
    if (notification.isRead != true) {
      final presenter = Provider.of<NotificationNotifier>(
        context,
        listen: false,
      );
      await presenter.markNotification(notification.notificationId ?? 0);
      // Cập nhật lại danh sách thông báo
      await presenter.getNotification();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    // Icon và tiêu đề
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Color(0xFF6357CC).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            notification.chapterUrl != null &&
                                    notification.chapterUrl!.isNotEmpty
                                ? Icons.menu_book
                                : Icons.notifications,
                            color: Color(0xFF6357CC),
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            notification.title ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Thông tin sách và chương
                    if (notification.bookTitle != null &&
                        notification.bookTitle!.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (notification.bookTitle != null &&
                                notification.bookTitle!.isNotEmpty)
                              Row(
                                children: [
                                  Icon(
                                    Icons.book,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Sách: ${notification.bookTitle}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (notification.chapterTitle != null &&
                                notification.chapterTitle!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.menu_book,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "Chương: ${notification.chapterTitle}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    SizedBox(height: 16),
                    // Thời gian
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 8),
                        Text(
                          _formatDateTime(notification.createdAt),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Nội dung chi tiết
                    Text(
                      notification.message ?? '',

                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                    // Nút đọc ngay nếu có chương
                    if (notification.chapterUrl != null &&
                        notification.chapterUrl!.isNotEmpty)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Thêm code để mở trang đọc chương tại đây
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6357CC),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.menu_book, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Đóng',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
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
      },
    );
  }

  // Format datetime từ API
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('HH:mm - dd/MM/yyyy').format(dateTime);
  }

  // Hiển thị xác nhận xóa thông báo
  void _confirmDeleteNotification(NotificationResponse notification) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Xóa thông báo"),
            content: Text("Bạn có chắc muốn xóa thông báo này không?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Hủy"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteNotification(notification);
                },
                child: Text("Xóa", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  // Hiển thị xác nhận xóa tất cả thông báo
  void _confirmDeleteAllNotifications() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Xóa tất cả thông báo"),
            content: Text("Bạn có chắc muốn xóa tất cả thông báo không?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Hủy"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteAllNotifications();
                },
                child: Text("Xóa tất cả", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  // Xóa một thông báo
  void _deleteNotification(NotificationResponse notification) async {
    final presenter = Provider.of<NotificationNotifier>(context, listen: false);
    bool isSucc = await presenter.deleteNotification(
      notification.notificationId ?? 1,
    );
    if (!isSucc) {
      showToastTop(message: "Xóa thông báo thất bại");
      return;
    }
    await presenter.getNotification();
  }

  // Xóa tất cả thông báo
  void _deleteAllNotifications() async {
    final presenter = Provider.of<NotificationNotifier>(context, listen: false);
    bool isSucc = await presenter.deleteAllNotification();
    if (!isSucc) {
      showToastTop(message: "Xóa tất cả thông báo thất bại");
      return;
    }
    await presenter.getNotification();
  }

  // Đánh dấu đã đọc tất cả
  void _markAllAsRead() async {
    final presenter = Provider.of<NotificationNotifier>(context, listen: false);
    bool isSucc = await presenter.markAllNotification();
    if (!isSucc) {
      showToastTop(message: "Đánh dấu đã đọc thất bại");
      return;
    }
    await presenter.getNotification();
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<NotificationNotifier>(context);

    return Scaffold(
      body: Stack(
        children: [
          AppBarContainerWidget(
            titleString: "Thông báo",
            backgroundColor: ColorPalette.lavenderWhite,
            bottomWidget: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.done_all, color: Colors.white),
                  onPressed: _markAllAsRead,
                  tooltip: 'Đánh dấu đã đọc tất cả',
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: _confirmDeleteAllNotifications,
                  tooltip: 'Xóa tất cả',
                ),
              ],
            ),
            child:
                presenter.isLoading
                    ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6357CC),
                      ),
                    )
                    : (presenter.listNotifications == null ||
                        presenter.listNotifications!.isEmpty)
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: presenter.listNotifications?.length ?? 0,
                      itemBuilder: (context, index) {
                        final notification =
                            presenter.listNotifications![index];
                        return _buildNotificationItem(notification);
                      },
                    ),
          ),
          presenter.isLoading ? const LoadingWidget() : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationResponse notification) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: () => _showNotificationDetails(notification),
        child: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
            border:
                notification.isRead != true
                    ? Border.all(color: Color(0xFF6357CC), width: 1.5)
                    : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon thông báo
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                      notification.isRead != true
                          ? Color(0xFF6357CC).withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  notification.chapterUrl != null &&
                          notification.chapterUrl!.isNotEmpty
                      ? Icons.menu_book
                      : Icons.notifications,
                  color:
                      notification.isRead != true
                          ? Color(0xFF6357CC)
                          : Colors.grey,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (notification.isRead != true)
                          Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Color(0xFF6357CC),
                              shape: BoxShape.circle,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            notification.title ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  notification.isRead != true
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                              color:
                                  notification.isRead != true
                                      ? Colors.black87
                                      : Colors.black54,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.grey[400],
                          ),
                          onPressed:
                              () => _confirmDeleteNotification(notification),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      notification.message ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[400],
                        ),
                        SizedBox(width: 4),
                        Text(
                          _formatDateTime(notification.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        if (notification.chapterUrl != null &&
                            notification.chapterUrl!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF6357CC).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Có chương mới',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6357CC),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_notification.png',
            width: 200,
            height: 200,
            errorBuilder:
                (context, error, stackTrace) => Icon(
                  Icons.notifications_off_outlined,
                  size: 100,
                  color: Colors.grey[400],
                ),
          ),
          SizedBox(height: 16),
          Text(
            "Không có thông báo nào",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Các thông báo mới sẽ xuất hiện ở đây",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
