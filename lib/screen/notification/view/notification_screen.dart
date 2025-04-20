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

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  static const String routeName = '/notification_screen';
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isSelectionMode = false;
  List<NotificationResponse> _selectedNotifications = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => Provider.of<NotificationNotifier>(
        context,
        listen: false,
      ).getData(),
    );
  }

  // Hàm hiển thị bottom sheet chi tiết thông báo
  void _showNotificationDetails(NotificationResponse notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(kDefaultPadding),
              child: ListView(
                controller: scrollController,
                children: [
                  // Tiêu đề
                  Text(
                    notification.title ?? '',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87
                    ),
                  ),
                  SizedBox(height: 10),
                  // Chi tiết sách
                  if (notification.bookTitle != null && notification.bookTitle!.isNotEmpty)
                    Text(
                      "Sách: ${notification.bookTitle}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  if (notification.chapterTitle != null && notification.chapterTitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        "Chương: ${notification.chapterTitle}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  SizedBox(height: 10),
                  // Thời gian
                  Text(
                    _formatDateTime(notification.createdAt),
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                  SizedBox(height: 15),
                  // Nội dung chi tiết
                  Text(
                    notification.message ?? '',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5
                    ),
                  ),
                  SizedBox(height: 20),
                  // Nút đọc ngay nếu có chương
                  if (notification.chapterUrl != null && notification.chapterUrl!.isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Thêm code để mở trang đọc chương tại đây
                      },
                      child: Text('Đọc ngay'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6357CC),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  SizedBox(height: 10),
                  // Nút đóng
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Đóng'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[800],
                    ),
                  )
                ],
              ),
            );
          },
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
      builder: (context) => AlertDialog(
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

  // Hiển thị xác nhận xóa nhiều thông báo
  void _confirmDeleteMultipleNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Xóa thông báo"),
        content: Text("Bạn có chắc muốn xóa ${_selectedNotifications.length} thông báo đã chọn không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSelectedNotifications();
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
      builder: (context) => AlertDialog(
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
    bool isSucc =  await presenter.deleteNotification(notification.notificationId ?? 1);
    if(!isSucc) {
      showToastTop(message: "Xóa thông báo thất bại");
      return;
    }
    await presenter.getNotification();
  }

  // Xóa các thông báo đã chọn
  void _deleteSelectedNotifications() async {
    final presenter = Provider.of<NotificationNotifier>(context, listen: false);


    bool isSucc = await presenter.deleteAllNotification();

    setState(() {
      _isSelectionMode = false;
      _selectedNotifications.clear();
    });

    if(!isSucc){
      showToastTop(message: "Xóa thông báo thất bại");
      return;
    }

    await presenter.getNotification();
  }

  // Xóa tất cả thông báo
  void _deleteAllNotifications() async {
    final presenter = Provider.of<NotificationNotifier>(context, listen: false);
    await presenter.deleteAllNotification();

    // Cập nhật UI
    setState(() {
      _isSelectionMode = false;
      _selectedNotifications.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa tất cả thông báo'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<NotificationNotifier>(context);

    return Scaffold(
      body: AppBarContainerWidget(
        titleString: "Thông báo",
        backgroundColor: ColorPalette.lavenderWhite,
        // actions: [
        //   if (!_isSelectionMode && (presenter.listNotifications?.isNotEmpty ?? false))
        //     IconButton(
        //       icon: Icon(Icons.delete_outline),
        //       onPressed: () {
        //         setState(() {
        //           _isSelectionMode = true;
        //           _selectedNotifications.clear();
        //         });
        //       },
        //     ),
        //   if (_isSelectionMode)
        //     IconButton(
        //       icon: Icon(Icons.close),
        //       onPressed: () {
        //         setState(() {
        //           _isSelectionMode = false;
        //           _selectedNotifications.clear();
        //         });
        //       },
        //     ),
        // ],
        child: presenter.isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6357CC),
          ),
        )
            : (presenter.listNotifications == null || presenter.listNotifications!.isEmpty)
            ? _buildEmptyState()
            : Column(
          children: [
            if (_isSelectionMode) _buildSelectionHeader(presenter),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: presenter.listNotifications?.length ?? 0,
                itemBuilder: (context, index) {
                  final notification = presenter.listNotifications![index];
                  return _buildNotificationItem(notification);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionHeader(NotificationNotifier presenter) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: _selectedNotifications.length == presenter.listNotifications!.length,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedNotifications = List.from(presenter.listNotifications!);
                    } else {
                      _selectedNotifications.clear();
                    }
                  });
                },
              ),
              Text(
                "Đã chọn ${_selectedNotifications.length}/${presenter.listNotifications!.length}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextButton.icon(
                icon: Icon(Icons.delete, color: Colors.red),
                label: Text(
                  "Xóa đã chọn",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: _selectedNotifications.isEmpty
                    ? null
                    : _confirmDeleteMultipleNotifications,
              ),
              SizedBox(width: 8),
              TextButton.icon(
                icon: Icon(Icons.delete_forever, color: Colors.red),
                label: Text(
                  "Xóa tất cả",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: _confirmDeleteAllNotifications,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationResponse notification) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: _isSelectionMode
            ? () {
          setState(() {
            if (_selectedNotifications.contains(notification)) {
              _selectedNotifications.remove(notification);
            } else {
              _selectedNotifications.add(notification);
            }
          });
        }
            : () => _showNotificationDetails(notification),
        onLongPress: !_isSelectionMode
            ? () {
          setState(() {
            _isSelectionMode = true;
            _selectedNotifications = [notification];
          });
        }
            : null,
        child: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: notification.isRead != true
                ? Border.all(color: Color(0xFF6357CC), width: 1.5)
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isSelectionMode)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Checkbox(
                    value: _selectedNotifications.contains(notification),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedNotifications.add(notification);
                        } else {
                          _selectedNotifications.remove(notification);
                        }
                      });
                    },
                  ),
                ),
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
                              fontWeight: notification.isRead != true ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (!_isSelectionMode)
                          IconButton(
                            icon: Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                            onPressed: () => _confirmDeleteNotification(notification),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      notification.message ?? '',
                      style: TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      _formatDateTime(notification.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
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
      child: EmptyDataWidget(
        title: "Không có thông báo nào",
        styleTitle: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
        height: height_200,
        width: width_200,
      ),
    );
  }
}