import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/mock_data.dart';
import 'package:flutter/material.dart';

import '../../../utils/core/constants/color_constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  static const String routeName = '/notification_screen';
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, String>> _bookAppNotifications = MockData.bookAppNotifications;

  // Hàm hiển thị bottom sheet chi tiết thông báo
  void _showNotificationDetails(Map<String, String> notification) {
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
                    notification['title'] ?? '',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87
                    ),
                  ),
                  SizedBox(height: 10),
                  // Thời gian
                  Text(
                    notification['time'] ?? '',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                  SizedBox(height: 15),
                  // Nội dung chi tiết
                  Text(
                    notification['content'] ?? '',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5
                    ),
                  ),
                  SizedBox(height: 20),
                  // Nút đóng
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Đóng'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.lavenderWhite,
                      foregroundColor: Colors.black87,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBarContainerWidget(
        titleString: "Thông báo",
        backgroundColor: ColorPalette.lavenderWhite,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: height_60),
            child: Column(
              spacing: height_10,
              children: _bookAppNotifications.map((notification) {
                return GestureDetector(
                  onTap: () => _showNotificationDetails(notification),
                  child: _buildItem(
                      notification['title'] ?? '',
                      notification['content'] ?? '',
                      notification['time'] ?? ''
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String title, String content, String time){
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          Text(content, style: TextStyle(fontSize: 14),),
          Text(time, style: TextStyle(fontSize: 14),)
        ],
      ),
    );
  }
}