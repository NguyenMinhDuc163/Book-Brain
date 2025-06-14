import 'package:book_brain/screen/detail_book/view/detail_book_screen.dart';
import 'package:book_brain/screen/detail_book/widget/bottom_sheet_selector.dart';
import 'package:book_brain/screen/login/widget/button_widget.dart';
import 'package:book_brain/screen/preview/provider/preview_notifier.dart';
import 'package:book_brain/screen/reivew_book/view/review_book_screen.dart';
import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/mock_data.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/widgets/native_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:book_brain/service/service_config/admob_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';

import '../../../utils/widget/loading_widget.dart';

class PreviewScreen extends StatefulWidget {
  PreviewScreen({super.key, this.bookId});
  static const String routeName = '/preview_screen';

  int? bookId;
  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  String _selectedChapter = "";
  late int chapterNumber;
  bool _isRewardedLoading = false;
  int? _pendingChapterNumber;

  @override
  void initState() {
    super.initState();
    chapterNumber = 1;
    Future.microtask(
      () => Provider.of<PreviewNotifier>(
        context,
        listen: false,
      ).getData(widget.bookId ?? 1),
    );
    _selectedChapter = "";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _selectedChapter = "";
  }

  Future<void> _showRewardedInterstitialAdAndContinue(
    int chapterNumber,
    int bookId,
  ) async {
    String isAds = LocalStorageHelper.getValue("isAds");
    if (isAds == 'off') {
      _onRewardedAdCompleted(bookId);
      return;
    }

    setState(() {
      _isRewardedLoading = true;
      _pendingChapterNumber = chapterNumber;
    });

    int retryCount = 0;
    const maxRetries = 3;
    bool isAdLoaded = false;

    while (retryCount < maxRetries && !isAdLoaded) {
      try {
        if (retryCount > 0) {
          await Future.delayed(Duration(seconds: 2));
        }

        await RewardedInterstitialAd.load(
          adUnitId: AdMobService().getAdUnitId('rewarded_interstitial'),
          request: const AdRequest(),
          rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              isAdLoaded = true;
              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  if (_pendingChapterNumber != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Bạn cần xem hết quảng cáo để tiếp tục đọc chương tiếp theo!',
                        ),
                      ),
                    );
                    setState(() {
                      _isRewardedLoading = false;
                    });
                  }
                  ad.dispose();
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  print('Ad failed to show: $error');
                  ad.dispose();
                  setState(() {
                    _isRewardedLoading = false;
                  });
                  if (retryCount < maxRetries) {
                    retryCount++;
                    isAdLoaded = false;
                  }
                },
              );

              Future.delayed(Duration(milliseconds: 500), () {
                if (mounted) {
                  ad.show(
                    onUserEarnedReward: (_, reward) {
                      _onRewardedAdCompleted(bookId);
                      ad.dispose();
                    },
                  );
                }
              });

              setState(() {
                _isRewardedLoading = false;
              });
            },
            onAdFailedToLoad: (error) {
              print('Ad failed to load: $error');
              retryCount++;
              if (retryCount >= maxRetries) {
                setState(() {
                  _isRewardedLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Không thể tải quảng cáo, vui lòng thử lại sau!',
                    ),
                  ),
                );
              }
            },
          ),
        );
      } catch (e) {
        print('Error loading ad: $e');
        retryCount++;
        if (retryCount >= maxRetries) {
          setState(() {
            _isRewardedLoading = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Có lỗi khi tải quảng cáo!')));
        }
      }
    }
  }

  void _onRewardedAdCompleted(int bookId) {
    final int? chapterToOpen = _pendingChapterNumber ?? chapterNumber;
    if (chapterToOpen != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) =>
                  DetailBookScreen(bookId: bookId, chapterId: chapterToOpen),
        ),
      );
      setState(() {
        _pendingChapterNumber = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không xác định được chương để mở!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<PreviewNotifier>(context);

    final List<String>? _chapters =
        presenter.bookDetail?.chapters
            .map(
              (chapter) => "Chương ${chapter.chapterOrder}: ${chapter.title}",
            )
            .toList();

    if (_selectedChapter.isEmpty &&
        presenter.bookDetail?.currentChapter != null) {
      _selectedChapter =
          "Chương ${presenter.bookDetail?.currentChapter?.chapterOrder}: ${presenter.bookDetail?.currentChapter?.title}";
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image:
                  presenter.bookDetail?.imageUrl != null &&
                          presenter.bookDetail!.imageUrl.isNotEmpty
                      ? NetworkImage(presenter.bookDetail!.imageUrl)
                          as ImageProvider
                      : AssetImage(AssetHelper.defaultImage) as ImageProvider,
              fit: BoxFit.fill,
            ),
          ),

          Positioned(
            top: kMediumPadding * 3,
            left: kMediumPadding,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(kItemPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(kDefaultPadding),
                  ),
                  color: Colors.white,
                ),
                child: Icon(FontAwesomeIcons.arrowLeft, size: 18),
              ),
            ),
          ),

          Positioned(
            top: kMediumPadding * 3,
            right: kMediumPadding,
            child: GestureDetector(
              onTap: () {
                presenter.setFavorites(!presenter.isFavorites);
              },
              child: Container(
                padding: EdgeInsets.all(kItemPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(kDefaultPadding),
                  ),
                  color: Colors.white,
                ),
                child: Icon(
                  presenter.isFavorites
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  size: 18,
                  color: presenter.isFavorites ? Colors.red : Colors.grey,
                ),
              ),
            ),
          ),

          Column(
            children: [
              Expanded(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  maxChildSize: 0.8,
                  minChildSize: 0.3,
                  builder: (context, scrollController) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: kMediumPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(kDefaultPadding * 2),
                          topRight: Radius.circular(kDefaultPadding * 2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: kDefaultPadding),
                            child: Container(
                              height: 5,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(kItemPadding),
                                ),
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: kDefaultPadding),

                          Expanded(
                            child: ListView(
                              controller: scrollController,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        presenter.bookDetail?.title ?? "",
                                        maxLines: 2,
                                        style:
                                            TextStyles
                                                .defaultStyle
                                                .fontHeader
                                                .bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: width_16),
                                    GestureDetector(
                                      onTap: () {
                                        presenter.setFollowing(
                                          !presenter.isFollowing,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              presenter.isFollowing
                                                  ? Color(0xFFBB86FC)
                                                  : ColorPalette.colorGreen,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              presenter.isFollowing
                                                  ? 'Đã theo dõi'
                                                  : 'Theo dõi',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              presenter.isFollowing
                                                  ? Icons.check
                                                  : Icons.add,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: kDefaultPadding),
                                Row(
                                  children: [
                                    Icon(FontAwesomeIcons.user, size: 18),
                                    SizedBox(width: kMinPadding),
                                    Text(
                                      presenter.bookDetail?.authorName ?? "",
                                    ),

                                    SizedBox(width: width_30),
                                    Icon(FontAwesomeIcons.eye, size: 18),
                                    SizedBox(width: kMinPadding),
                                    Text(
                                      presenter.bookDetail?.views.toString() ??
                                          "",
                                    ),
                                  ],
                                ),
                                SizedBox(height: kDefaultPadding),
                                Row(
                                  children: [
                                    ImageHelper.loadFromAsset(
                                      AssetHelper.icoStar,
                                    ),
                                    SizedBox(width: kMinPadding),
                                    Text(
                                      '${presenter.bookDetail?.rating.toString().split('.')[0]}/5' ??
                                          "4/5",
                                    ),
                                    SizedBox(width: kMinPadding),
                                    Text(
                                      ' ${presenter.bookDetail?.totalReviews ?? 0} ',
                                      style: TextStyle(
                                        color: ColorPalette.subTitleColor,
                                      ),
                                    ),
                                    Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ReviewBookScreen(
                                                  bookId:
                                                      presenter
                                                          .bookDetail
                                                          ?.bookId ??
                                                      1,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Text("Xem thêm"),
                                    ),
                                  ],
                                ),
                                SizedBox(height: kDefaultPadding),
                                Text(
                                  'Thể loại',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: kDefaultPadding),
                                Text(
                                  presenter.bookDetail?.categoryName ?? "",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                SizedBox(height: kDefaultPadding),

                                SizedBox(height: kDefaultPadding),
                                Text(
                                  'Mô tả',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: kDefaultPadding),
                                Text(
                                  presenter.bookDetail?.excerpt ??
                                      MockData.describe,
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                  maxLines: 8,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: kDefaultPadding),
                                Text(
                                  "Danh sách chương",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: kDefaultPadding),

                                BottomSheetSelector(
                                  title: 'Chọn chương sách',
                                  items: _chapters ?? [],
                                  selectedValue: _selectedChapter,
                                  onValueChanged: (value) {
                                    setState(() {
                                      _selectedChapter = value;
                                      final pattern = RegExp(r'Chương (\d+):');
                                      final match = pattern.firstMatch(value);
                                      if (match != null &&
                                          match.groupCount >= 1) {
                                        chapterNumber =
                                            int.tryParse(
                                              match.group(1) ?? "",
                                            ) ??
                                            1;
                                        if (chapterNumber != null) {
                                          print("=====>${chapterNumber}");
                                        }
                                      }
                                    });
                                  },
                                  placeholder: 'Vui lòng chọn chương sách',
                                ),

                                SizedBox(height: kMediumPadding),
                                NativeAdWidget(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(kDefaultPadding),
                color: Colors.white,
                child: ButtonWidget(
                  title: 'Bắt đầu đọc',
                  ontap: () {
                    print("======> $chapterNumber");
                    String isAds = LocalStorageHelper.getValue("isAds");
                    if (chapterNumber < 3 || isAds == 'off') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => DetailBookScreen(
                                bookId: presenter.bookDetail?.bookId ?? 1,
                                chapterId: chapterNumber,
                              ),
                        ),
                      );
                    } else {
                      _showRewardedInterstitialAdAndContinue(
                        chapterNumber,
                        presenter.bookDetail?.bookId ?? 1,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          presenter.isLoading ? const LoadingWidget() : const SizedBox(),
          if (_isRewardedLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
