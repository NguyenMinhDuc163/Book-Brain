import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/network_image_config.dart';
import 'package:flutter/material.dart';

class NetworkImageHandler extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final String defaultImagePath;
  final BoxFit fit;

  const NetworkImageHandler({
    super.key,
    required this.imageUrl,
    this.width = 140,
    this.height = 200,
    this.defaultImagePath = AssetHelper.defaultImage,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = this.imageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildFallbackImage();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        headers: NetworkImageConfig.headers,
        errorBuilder: (_, __, ___) => _buildFallbackImage(),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      defaultImagePath,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
