
import 'package:flutter/material.dart';

/// Widget đơn giản để hiển thị nội dung sách với thanh trượt
class SimpleBookReader extends StatefulWidget {
  /// Nội dung sách cần hiển thị
  final String content;

  /// Tiêu đề sách (tùy chọn)
  final String? title;

  /// Kích thước chữ
  final double fontSize;

  const SimpleBookReader({
    Key? key,
    required this.content,
    this.title,
    this.fontSize = 16.0,
  }) : super(key: key);

  @override
  _SimpleBookReaderState createState() => _SimpleBookReaderState();
}

class _SimpleBookReaderState extends State<SimpleBookReader> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title != null ? AppBar(title: Text(widget.title!)) : null,
      body: RawScrollbar(
        // Sử dụng RawScrollbar để tùy chỉnh thanh cuộn
        thumbColor: Colors.grey.withOpacity(0.5),
        radius: Radius.circular(20),
        thickness: 50.0,
        thumbVisibility: true,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.all(16.0),
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null && AppBar() == null) ...[
                Text(
                  widget.title!,
                  style: TextStyle(
                    fontSize: widget.fontSize * 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
              ],
              Text(
                widget.content,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  height: 1.5,
                ),
              ),
              // Khoảng trống cuối cùng
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // Nút trở về đầu trang
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(Icons.arrow_upward),
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
