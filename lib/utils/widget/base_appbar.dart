import 'package:book_brain/screen/main_app.dart';
import 'package:flutter/material.dart';

class BaseAppbar extends StatelessWidget implements PreferredSizeWidget {
  BaseAppbar({
    super.key,
    this.title = "",
    this.backgroundColor,
    this.onHomeTap,
    this.textColor,
    this.onBack,
    this.isShowBack = true,
  });
  final String title;
  final Color? textColor;
  final Color? backgroundColor;
  final Function()? onHomeTap;
  final Function()? onBack;
  final bool isShowBack;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.grey,
      automaticallyImplyLeading: isShowBack,
      leading:
          isShowBack
              ? IconButton(
                icon: Icon(Icons.arrow_back, color: textColor ?? Colors.white),
                onPressed: () {
                  onBack?.call() ?? Navigator.of(context).pop();
                },
              )
              : null,

      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor ?? Colors.white, // Màu của tiêu đề
        ),
      ),
      centerTitle: true,
      // Nút Home với màu tùy chỉnh
      actions: [
        IconButton(
          icon: Icon(
            Icons.home,
            color: textColor ?? Colors.white, // Màu của icon home
          ),
          onPressed: () {
            onHomeTap?.call() ??
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  MainApp.routeName,
                  (route) => false,
                );
          },
        ),
      ],

      // Bạn cũng có thể tùy chỉnh màu sắc của toàn bộ theme cho AppBar
      iconTheme: IconThemeData(color: textColor ?? Colors.white),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
