import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:book_brain/utils/core/extentions/size_extension.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class AppBarContinerWidget extends StatelessWidget {
  const AppBarContinerWidget({
    Key? key,
    required this.child,
    this.title,
    this.titleString,
    this.subTitleString,
    this.implementTraling = false,
    this.implementLeading = true,
    this.paddingContent = const EdgeInsets.symmetric(
      horizontal: kMediumPadding,
    ),
    this.avatar, this.email,
    this.positon, this.backgroundColor,
  })  : assert(title != null || titleString != null,
  'title or titleString can\'t be null'),
        super(key: key);

  final Widget child;
  final Widget? title;
  final String? titleString;
  final String? subTitleString;
  final bool implementTraling;
  final bool implementLeading;
  final EdgeInsets? paddingContent;
  final String? avatar;
  final String? email;
  final bool? positon;
  final Color? backgroundColor ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ??  Colors.white ,
      body: Stack(
        children: [
          SizedBox(
            height: height_150,
            child: AppBar(
              title: title ??
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (implementLeading)
                          GestureDetector(
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
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  titleString ?? '',
                                  style: TextStyles.defaultStyle.fontHeader
                                      .whiteTextColor.bold,
                                ),
                                if(subTitleString != null && email != null) // dung cho profile screen
                                  Column(
                                    children: [
                                      Text(subTitleString!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                      Text(email!, style: TextStyle(fontSize: 12),)
                                    ],
                                  ),


                                if (subTitleString != null && email == null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: kMediumPadding),
                                    child: Text(
                                      subTitleString!,
                                      style: TextStyles.defaultStyle.fontCaption
                                          .whiteTextColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (implementTraling)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                kDefaultPadding,
                              ),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(kItemPadding),
                            child: Icon(
                              FontAwesomeIcons.bars,
                              size: kDefaultPadding,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                  ),
              flexibleSpace: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff8F67E8), Color(0xff6357CC)],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                      ),
                    ),
                  ),
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
                  if(avatar != null)Positioned(child: ImageHelper.loadFromAsset(avatar!))
                ],
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: 90,
              backgroundColor: ColorPalette.backgroundScaffoldColor,
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 100.h),
            padding: paddingContent,
            child: child,
          ),
        ],
      ),
    );
  }
}
