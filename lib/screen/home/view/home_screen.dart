import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home_screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> listImageLeft = [
    {
      'name': 'Name',
      'image': AssetHelper.bookMock,
    },
    {
      'name': 'Name',
      'image': AssetHelper.bookMock,
    },
  ];
  final List<Map<String, String>> listImageRight = [
    {
      'name': 'Name',
      'image': AssetHelper.bookMock,
    },
    {
      'name': 'Name',
      'image': AssetHelper.bookMock,
    },
  ];

  Widget _buildItemCategory(
      Widget icon, Color color, Function() onTap, String title) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: kMediumPadding,
            ),
            decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(kItemPadding)),
            child: icon,
          ),
          SizedBox(
            height: kItemPadding,
          ),
          Text(title)
        ],
      ),
    );
  }

  Widget _buildImageHomScreen(String name, String image) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context)
        //     .pushNamed(RouteNames, arguments: name);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: kDefaultPadding),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ImageHelper.loadFromAsset(
              image,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              radius: BorderRadius.circular(kItemPadding),
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
            Positioned(
              left: kDefaultPadding,
              bottom: kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyles.defaultStyle.whiteTextColor.bold,
                  ),
                  SizedBox(
                    height: kItemPadding,
                  ),
                  Container(
                    padding: EdgeInsets.all(kMinPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kMinPadding),
                      color: Colors.white.withOpacity(0.4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.star,
                          color: Color(0xffFFC107),
                        ),
                        SizedBox(
                          width: kItemPadding,
                        ),
                        Text('4.5')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContinerWidget(
      titleString: 'home',
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kItemPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( 'Nguyen Van A',
                    style:
                    TextStyles.defaultStyle.fontHeader.whiteTextColor.bold),
                SizedBox(
                  height: kMediumPadding,
                ),
                Text(
                  'Bạn sẽ đọc cuốn sách nào hôm nay?',
                  style: TextStyles.defaultStyle.fontCaption.whiteTextColor,
                )
              ],
            ),
            Spacer(),
            Icon(
              FontAwesomeIcons.bell,
              size: kDefaultIconSize,
              color: Colors.white,
            ),
            SizedBox(
              width: kMinPadding,
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  kItemPadding,
                ),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(kItemPadding),
              child: ImageHelper.loadFromAsset(
                AssetHelper.avatar,
              ),
            ),
          ],
        ),
      ),
      implementLeading: false,
      child: Column(
        children: [
          InkWell(
            child: TextField(
              enabled: false,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm cuốn sách của bạn',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.black,
                    size: 14,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      kItemPadding,
                    ),
                  ),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: kItemPadding),
              ),
              style: TextStyles.defaultStyle,
              onChanged: (value) {},
              onSubmitted: (String submitValue) {},
            ),
            onTap: (){
              // Navigator.pushNamed(context, RouteNames.searchScreen);
            },
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: _buildItemCategory(
                    ImageHelper.loadFromAsset(
                      AssetHelper.icoHistory,
                      width: kDefaultIconSize,
                      height: kDefaultIconSize,
                    ),
                    Color(0xffFE9C5E), () {
                  // Navigator.of(context).pushNamed(RouteNames.hotelBookingScreen);
                }, 'Lịch sử'),
              ),
              SizedBox(width: kDefaultPadding),
              Expanded(
                child: _buildItemCategory(
                    ImageHelper.loadFromAsset(
                      AssetHelper.icoRank,
                      width: kDefaultIconSize,
                      height: kDefaultIconSize,
                    ),
                    Color(0xffF77777),
                        () {

                      // Navigator.of(context).pushNamed(RouteNames.flightDetailScreen);
                    },
                    'Xếp hạng'),
              ),
              SizedBox(width: kDefaultPadding),
              Expanded(
                child: _buildItemCategory(
                    ImageHelper.loadFromAsset(
                      AssetHelper.icoBookFollow,
                      width: kDefaultIconSize,
                      height: kDefaultIconSize,
                    ),
                    Color(0xff3EC8BC),
                        () {},
                    'Sách theo dõi'),
              ),
            ],
          ),
          SizedBox(
            height: kMediumPadding,
          ),
          Row(
            children: [
              Text(
                'Cuốn sách phổ biến',
                style: TextStyles.defaultStyle.bold,
              ),
              Spacer(),
              Text(
                'Tất cả',
                style: TextStyles.defaultStyle.bold.primaryTextColor,
              ),
            ],
          ),
          SizedBox(
            height: kMediumPadding,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: listImageLeft
                          .map(
                            (e) => _buildImageHomScreen(
                          e['name']!,
                          e['image']!,
                        ),
                      )
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    width: kDefaultPadding,
                  ),
                  Expanded(
                    child: Column(
                      children: listImageRight
                          .map(
                            (e) => _buildImageHomScreen(
                          e['name']!,
                          e['image']!,
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
