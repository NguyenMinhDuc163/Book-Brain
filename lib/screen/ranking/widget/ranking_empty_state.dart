import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:flutter/material.dart';

class RankingEmptyState extends StatelessWidget {
  const RankingEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF5F2FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorPalette.primaryColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primaryColor.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorPalette.lavenderWhite,
                  border: Border.all(
                    color: ColorPalette.primaryColor.withValues(alpha: 0.16),
                  ),
                ),
                child: Icon(icon, size: 42, color: ColorPalette.primaryColor),
              ),
              const SizedBox(height: 22),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.defaultStyle.fontHeader.bold.copyWith(
                  color: ColorPalette.text1Color,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyles.defaultStyle.copyWith(
                  height: 1.5,
                  color: ColorPalette.subTitleColor,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _RankBar(height: 20, colorOpacity: 0.18),
                  const SizedBox(width: 6),
                  _RankBar(height: 32, colorOpacity: 0.32),
                  const SizedBox(width: 6),
                  _RankBar(height: 25, colorOpacity: 0.24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RankBar extends StatelessWidget {
  const _RankBar({required this.height, required this.colorOpacity});

  final double height;
  final double colorOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: height,
      decoration: BoxDecoration(
        color: ColorPalette.primaryColor.withValues(alpha: colorOpacity),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
      ),
    );
  }
}
