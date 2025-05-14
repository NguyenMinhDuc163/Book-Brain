import 'package:book_brain/screen/main_app.dart';
import 'package:flutter/material.dart';

class BaseAppbar extends StatelessWidget implements PreferredSizeWidget{
   BaseAppbar({super.key, this.title = "", this.backgroundColor, this.onHomeTap, this.textColor, this.onBack, this.isShowBack = true});
  String title;
  Color? textColor;
  Color? backgroundColor;
  Function()? onHomeTap;
  Function()? onBack;
  bool isShowBack;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.grey,

      leading: isShowBack ? IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: textColor ??  Colors.white,
        ),
        onPressed: () {
          onBack?.call() ?? Navigator.of(context).pop();
        },
      ): SizedBox.shrink(),

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
            onHomeTap?.call() ??Navigator.pushNamedAndRemoveUntil(context, MainApp.routeName, (route) => false);

          },
        ),
      ],

      // Bạn cũng có thể tùy chỉnh màu sắc của toàn bộ theme cho AppBar
      iconTheme: IconThemeData(color: textColor ??  Colors.white),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
