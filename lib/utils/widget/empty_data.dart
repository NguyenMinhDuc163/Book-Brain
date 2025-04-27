import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/constants/dimension_constants.dart';


class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({
    super.key,
    this.title,
    this.styleTitle,
    this.height,
    this.width,
    this.mainAxisSize,
    this.mainAxisAlignment,
  });

  final String? title;
  final TextStyle? styleTitle;
  final double? height;
  final double? width;
  final MainAxisSize? mainAxisSize;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mainAxisAlignment == null ? Alignment.center : Alignment.topCenter,
      child: Column(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: mainAxisSize ?? MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AssetHelper.iconEmptyData,
            height: height ?? height_300,
            width: width ?? width_300,
          ),
          Text(
            title ?? "account.no_data".tr(),
            style: styleTitle  ?? TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

