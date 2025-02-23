import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';

class DialogAlert{
  static showTimeoutDialog(String tile, String content) {
    showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title:  Text(tile),
        content:  Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:  Text('ok'.tr()),
          ),
        ],
      ),
    );
  }
}