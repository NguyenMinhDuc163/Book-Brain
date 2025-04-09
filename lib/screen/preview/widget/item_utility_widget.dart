import 'package:flutter/material.dart';

class NutTheoDoi extends StatefulWidget {
  const NutTheoDoi({Key? key}) : super(key: key);

  @override
  State<NutTheoDoi> createState() => _NutTheoDoiState();
}

class _NutTheoDoiState extends State<NutTheoDoi> {
  bool _dangTheoDoi = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _dangTheoDoi = !_dangTheoDoi;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFBB86FC), // Màu tím giống hình ảnh
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Theo dõi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              _dangTheoDoi ? Icons.check : Icons.add,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}