import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final Function()? ontap;
  final Color? opacity;
  final bool? isign;
  const ButtonWidget(
      {Key? key, required this.title, this.ontap, this.opacity, this.isign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kMediumPadding),
          gradient:
          opacity != null ? null : Gradients.defaultGradientBackground,
          color: opacity,
        ),
        alignment: Alignment.center,
        child: (isign == true)
            ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
            ))
            : Text(
          title,
          style: TextStyles.defaultStyle.bold.copyWith(
            color: opacity != null
                ? ColorPalette.primaryColor
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
