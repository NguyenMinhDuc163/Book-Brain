import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkImageHandler extends StatefulWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final String defaultImagePath;
  final BoxFit fit;

  const NetworkImageHandler({
    Key? key,
    required this.imageUrl,
    this.width = 140,
    this.height = 200,
    this.defaultImagePath = AssetHelper.defaultImage,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  _NetworkImageHandlerState createState() => _NetworkImageHandlerState();
}

class _NetworkImageHandlerState extends State<NetworkImageHandler> {
  String _finalImageUrl = '';
  bool _isValidImage = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _validateImageUrl();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _validateImageUrl() async {
    // Kiểm tra nếu URL null hoặc rỗng
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      _updateImageState(widget.defaultImagePath, false);
      return;
    }

    try {
      // Kiểm tra URL hợp lệ
      final response = await http.head(Uri.parse(widget.imageUrl!));

      if (response.statusCode == 200 &&
          response.headers['content-type']?.startsWith('image/') == true) {
        _updateImageState(widget.imageUrl!, true);
      } else {
        _updateImageState(widget.defaultImagePath, false);
      }
    } catch (e) {
      // Nếu có lỗi kết nối, chuyển sang ảnh mặc định
      _updateImageState(widget.defaultImagePath, false);
    }
  }

  void _updateImageState(String imageUrl, bool isValid) {
    if (!_isDisposed) {
      setState(() {
        _finalImageUrl = imageUrl;
        _isValidImage = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: _buildImageProvider(),
          fit: widget.fit,
        ),
      ),
    );
  }

  ImageProvider _buildImageProvider() {
    // Kiểm tra và xử lý URL
    if (_finalImageUrl.isEmpty || !_isValidImage) {
      return AssetImage(widget.defaultImagePath);
    }

    try {
      // Kiểm tra xem URL có hợp lệ không
      Uri.parse(_finalImageUrl);
      return NetworkImage(_finalImageUrl);
    } catch (e) {
      // Nếu URL không hợp lệ, trả về ảnh mặc định
      return AssetImage(widget.defaultImagePath);
    }
  }
}