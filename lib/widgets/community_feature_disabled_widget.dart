import 'package:flutter/material.dart';

class CommunityFeatureDisabledScreen extends StatelessWidget {
  const CommunityFeatureDisabledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tính năng cộng đồng')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.forum_outlined,
                  size: 64,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tính năng cộng đồng tạm thời chưa khả dụng',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bạn vẫn có thể đọc sách, lưu yêu thích, theo dõi sách, '
                  'xem lịch sử đọc và sử dụng ghi chú cá nhân.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed:
                      Navigator.of(context).canPop()
                          ? () => Navigator.of(context).pop()
                          : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Quay lại'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
