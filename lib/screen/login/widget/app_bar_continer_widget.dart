import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:book_brain/utils/core/extentions/size_extension.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarContainerWidget extends StatelessWidget {
  const AppBarContainerWidget({
    super.key,
    required this.child,
    this.title,
    this.titleString,
    this.paddingContent = const EdgeInsets.symmetric(
      horizontal: kMediumPadding,
    ),
    this.avatar,
    this.backgroundColor,
    this.bottomWidget, this.topPadding,this.isShowBackButton = true,
  }) : assert(title != null || titleString != null,
  'title or titleString can\'t be null');

  final Widget child;
  final Widget? title;
  final String? titleString;
  final EdgeInsets? paddingContent;
  final String? avatar;
  final Color? backgroundColor;
  final Widget? bottomWidget;
  final double? topPadding;
  final bool? isShowBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: Column(
        children: [
          // AppBar container
          SizedBox(
            height: height_150,
            child: Stack(
              children: [
                // Gradient background
                Container(
                  height: height_150,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff8F67E8), Color(0xff6357CC)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                    ),
                  ),
                ),

                // Decorative images
                Positioned(
                  top: 0,
                  left: 0,
                  child: ImageHelper.loadFromAsset(
                    AssetHelper.icoOvalTop,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: ImageHelper.loadFromAsset(
                    AssetHelper.icoOvalBottom,
                  ),
                ),
                // Back button
                Visibility(
                  visible: isShowBackButton ?? true ,
                  child: Positioned(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 16,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            kDefaultPadding,
                          ),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(kItemPadding),
                        child: Icon(
                          FontAwesomeIcons.arrowLeft,
                          size: kDefaultPadding,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: MediaQuery.of(context).padding.top + 30,
                  left: 0,
                  right: 0,
                  child: title != null
                      ? title!
                      : Center(
                    child: Text(
                      titleString ?? '',
                      style: TextStyles.defaultStyle.fontHeader
                          .whiteTextColor.bold,
                    ),
                  ),
                ),

                // Bottom widget (search bar, etc.)
                if (bottomWidget != null)
                  Positioned(
                    bottom: topPadding ?? height_20,
                    left: kMediumPadding,
                    right: kMediumPadding,
                    child: bottomWidget ?? SizedBox(),
                  ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: Padding(
              padding: paddingContent ?? EdgeInsets.zero,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}