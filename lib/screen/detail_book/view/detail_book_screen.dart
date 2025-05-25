import 'package:book_brain/screen/detail_book/provider/detail_book_notifier.dart';
import 'package:book_brain/screen/detail_book/widget/bottom_sheet_selector.dart';
import 'package:book_brain/screen/reivew_book/service/review_book_service.dart';
import 'package:book_brain/utils/core/common/toast.dart';
import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:book_brain/utils/widget/base_appbar.dart';
import 'package:book_brain/widgets/ad_banner_widget.dart';
import 'package:book_brain/widgets/native_ad_widget.dart';
import 'package:book_brain/widgets/rewarded_interstitial_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../utils/widget/loading_widget.dart';
import '../../main_app.dart';
import 'package:book_brain/service/service_config/admob_service.dart';

class DetailBookScreen extends StatefulWidget {
  DetailBookScreen({super.key, this.bookId, this.chapterId});
  static const String routeName = "/detailBookScreen";
  int? bookId;
  int? chapterId;

  @override
  State<DetailBookScreen> createState() => _DetailBookScreenState();
}

class _DetailBookScreenState extends State<DetailBookScreen> {
  String _selectedChapter = "";
  final ScrollController _scrollController = ScrollController();
  bool _isFabExpanded = false;
  double _fontSize = fontSize_13sp;
  bool _isBookmarked = false;
  int chapterNumber = 1;
  final TextEditingController noteController = TextEditingController();
  String? _selectedText;
  Map<String, String> _notes =
      {}; // Lưu trữ ghi chú với key là vị trí bắt đầu của text

  // Thêm key cho LocalStorage
  static const String _fontSizeKey = 'book_font_size';
  static const String _backgroundColorKey = 'book_background_color';
  static const String _backgroundOpacityKey = 'book_background_opacity';

  Color _backgroundColor = ColorPalette.backgroundColor;
  double _backgroundOpacity = 1.0;

  bool _isBannerVisible = true;
  DateTime? _bannerHiddenTime;
  static const Duration _bannerHideDuration = Duration(minutes: 10);

  bool _isRewardedLoading = false;
  int? _pendingChapterNumber;

  // Thêm key cho LocalStorage để lưu danh sách chương đã xem quảng cáo
  static const String _viewedAdsChaptersKey = 'viewed_ads_chapters';

  // Hàm kiểm tra xem chương đã xem quảng cáo chưa
  bool _hasViewedAdForChapter(int chapterNumber) {
    List<dynamic> viewedChapters =
        LocalStorageHelper.getValue(_viewedAdsChaptersKey) ?? [];
    return viewedChapters.contains(chapterNumber);
  }

  // Hàm lưu chương đã xem quảng cáo
  void _markChapterAsViewed(int chapterNumber) {
    List<dynamic> viewedChapters =
        LocalStorageHelper.getValue(_viewedAdsChaptersKey) ?? [];
    if (!viewedChapters.contains(chapterNumber)) {
      viewedChapters.add(chapterNumber);
      LocalStorageHelper.setValue(_viewedAdsChaptersKey, viewedChapters);
    }
  }

  Widget _buttonWidget(String text, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding_10),
        decoration: BoxDecoration(
          color: ColorPalette.kAccent5,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: ColorPalette.kAccent1.withOpacity(0.2),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(text, style: TextStyle(fontSize: fontSize_13sp)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.chapterId != null) {
      chapterNumber = widget.chapterId!;
    }

    // Khôi phục cài đặt từ LocalStorage
    _restoreSettings();

    Future.microtask(
      () => Provider.of<DetailBookNotifier>(
        context,
        listen: false,
      ).getData(bookId: widget.bookId ?? 1, chapterId: widget.chapterId ?? 1),
    );

    // Lấy danh sách ghi chú khi màn hình được khởi tạo
    Future.microtask(
      () => Provider.of<DetailBookNotifier>(context, listen: false).getNoteBook(
        bookId: widget.bookId ?? 1,
        chapterId: widget.chapterId ?? 1,
      ),
    );

    // Kiểm tra nếu banner đã bị ẩn và hết thời gian thì hiện lại
    if (_bannerHiddenTime != null) {
      final now = DateTime.now();
      if (now.difference(_bannerHiddenTime!) > _bannerHideDuration) {
        _isBannerVisible = true;
        _bannerHiddenTime = null;
      }
    }
  }

  // Thêm phương thức khôi phục cài đặt
  void _restoreSettings() {
    final fontSize = LocalStorageHelper.getValue(_fontSizeKey);
    if (fontSize != null) {
      setState(() {
        _fontSize = fontSize;
      });
    }

    final backgroundColor = LocalStorageHelper.getValue(_backgroundColorKey);
    if (backgroundColor != null) {
      setState(() {
        _backgroundColor = Color(backgroundColor);
      });
    }

    final backgroundOpacity = LocalStorageHelper.getValue(
      _backgroundOpacityKey,
    );
    if (backgroundOpacity != null) {
      setState(() {
        _backgroundOpacity = backgroundOpacity;
      });
    }
  }

  // Thêm phương thức lưu cài đặt
  void _saveSettings() {
    LocalStorageHelper.setValue(_fontSizeKey, _fontSize);
    LocalStorageHelper.setValue(_backgroundColorKey, _backgroundColor.value);
    LocalStorageHelper.setValue(_backgroundOpacityKey, _backgroundOpacity);
  }

  @override
  void dispose() {
    // Reset danh sách chương đã xem quảng cáo khi thoát màn hình
    LocalStorageHelper.setValue(_viewedAdsChaptersKey, []);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _updateChapter(int newChapterNumber, int maxChapterNumber) {
    if (newChapterNumber < 1) {
      showToastTop(message: "Bạn đang ở chương đầu tiên");
      return;
    }

    if (newChapterNumber > maxChapterNumber) {
      showToastTop(message: "Bạn đang ở chương cuối cùng");
      return;
    }

    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    setState(() {
      chapterNumber = newChapterNumber;
    });

    Provider.of<DetailBookNotifier>(context, listen: false).getData(
      bookId:
          Provider.of<DetailBookNotifier>(
            context,
            listen: false,
          ).bookDetail?.bookId ??
          1,
      chapterId: newChapterNumber,
    );
  }

  void _handleChapterChange(int newChapterNumber, int maxChapterNumber) {
    if (newChapterNumber < 4) {
      _updateChapter(newChapterNumber, maxChapterNumber);
      return;
    }

    String isAds = LocalStorageHelper.getValue("isAds");
    if (isAds == 'off') {
      _updateChapter(newChapterNumber, maxChapterNumber);
      return;
    }

    // Kiểm tra xem đã xem quảng cáo cho chương này chưa
    if (_hasViewedAdForChapter(newChapterNumber)) {
      _updateChapter(newChapterNumber, maxChapterNumber);
      return;
    }

    if (!mounted) return;

    setState(() {
      _isRewardedLoading = true;
    });

    // Thêm timeout 3 giây
    Future.delayed(const Duration(seconds: 3), () {
      if (_isRewardedLoading && mounted) {
        setState(() {
          _isRewardedLoading = false;
        });
        _updateChapter(newChapterNumber, maxChapterNumber);
        _markChapterAsViewed(newChapterNumber);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đang tải quảng cáo, vui lòng thử lại sau!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });

    try {
      RewardedAd.load(
        adUnitId: AdMobService().getAdUnitId('rewarded'),
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            if (!mounted) {
              ad.dispose();
              return;
            }

            setState(() {
              _isRewardedLoading = false;
            });

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Bạn cần xem hết quảng cáo để tiếp tục đọc chương tiếp theo!',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                print('Ad failed to show: $error');
                ad.dispose();
                if (mounted) {
                  _updateChapter(newChapterNumber, maxChapterNumber);
                  _markChapterAsViewed(newChapterNumber);
                }
              },
            );

            // Thêm delay nhỏ trước khi hiển thị quảng cáo
            Future.delayed(Duration(milliseconds: 500), () {
              if (mounted) {
                ad.show(
                  onUserEarnedReward: (_, reward) {
                    if (mounted) {
                      _markChapterAsViewed(newChapterNumber);
                      _updateChapter(newChapterNumber, maxChapterNumber);
                    }
                    ad.dispose();
                  },
                );
              } else {
                ad.dispose();
              }
            });
          },
          onAdFailedToLoad: (error) {
            print('Ad failed to load: $error');
            if (!mounted) return;

            setState(() {
              _isRewardedLoading = false;
            });

            _updateChapter(newChapterNumber, maxChapterNumber);
            _markChapterAsViewed(newChapterNumber);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Không thể tải quảng cáo, vui lòng thử lại sau!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      );
    } catch (e) {
      print('Error loading ad: $e');
      if (!mounted) return;

      setState(() {
        _isRewardedLoading = false;
      });

      _updateChapter(newChapterNumber, maxChapterNumber);
      _markChapterAsViewed(newChapterNumber);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra, vui lòng thử lại sau!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showNoteMenu(BuildContext context, Offset tapPosition) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(tapPosition, tapPosition),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: 'note',
          child: Row(
            children: [
              Icon(Icons.note_add, color: Color(0xFF6357CC)),
              SizedBox(width: 8),
              Text('Thêm ghi chú'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'note') {
        _showNoteDialog(context, _selectedText ?? '');
      }
    });
  }

  void _showNoteDialog(BuildContext context, String selectedText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thêm ghi chú"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedText,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  hintText: "Nhập ghi chú của bạn...",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                maxLines: 5,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6357CC),
              ),
              child: Text("Lưu", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (_selectedText != null) {
                  final presenter = Provider.of<DetailBookNotifier>(
                    context,
                    listen: false,
                  );
                  bool success = await presenter.saveNoteBook(
                    bookId: widget.bookId ?? 1,
                    chapterId: chapterNumber,
                    startPosition:
                        presenter.bookDetail?.currentChapter?.content?.indexOf(
                          _selectedText!,
                        ) ??
                        0,
                    endPosition:
                        (presenter.bookDetail?.currentChapter?.content?.indexOf(
                              _selectedText!,
                            ) ??
                            0) +
                        _selectedText!.length,
                    selectedText: _selectedText!,
                    noteContent: noteController.text,
                  );

                  if (success) {
                    // Cập nhật lại danh sách ghi chú từ server
                    await presenter.getNoteBook(
                      bookId: widget.bookId ?? 1,
                      chapterId: chapterNumber,
                    );

                    setState(() {
                      _notes[_selectedText!] = noteController.text;
                    });
                    noteController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Đã lưu ghi chú"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Không thể lưu ghi chú"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNoteContent(BuildContext context, String text) {
    final presenter = Provider.of<DetailBookNotifier>(context, listen: false);
    String? noteContent;
    int? noteId;

    // Tìm ghi chú từ server
    final noteList = presenter.noteBook ?? [];
    for (var note in noteList) {
      if (note.selectedText == text) {
        noteContent = note.noteContent;
        noteId = note.noteId;
        break;
      }
    }

    // Nếu không tìm thấy từ server, tìm trong ghi chú local
    if (noteContent == null) {
      noteContent = _notes[text];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ghi chú"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                noteContent ?? 'Chưa có ghi chú',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Đóng"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if (noteId !=
                null) // Chỉ hiện nút xóa nếu có noteId (ghi chú từ server)
              TextButton(
                child: Text("Xóa", style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  // Hiển thị dialog xác nhận xóa
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Xác nhận xóa"),
                        content: Text("Bạn có chắc chắn muốn xóa ghi chú này?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Hủy"),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text(
                              "Xóa",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true && noteId != null) {
                    // Thực hiện xóa ghi chú
                    bool success = await presenter.deleteNoteBook(
                      noteId: noteId,
                    );
                    if (success) {
                      // Cập nhật lại danh sách ghi chú
                      await presenter.getNoteBook(
                        bookId: widget.bookId ?? 1,
                        chapterId: chapterNumber,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Đã xóa ghi chú"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.of(context).pop(); // Đóng dialog ghi chú
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Không thể xóa ghi chú"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<DetailBookNotifier>(context);
    final List<String>? _chapters =
        presenter.bookDetail?.chapters
            .map(
              (chapter) => "Chương ${chapter.chapterOrder}: ${chapter.title}",
            )
            .toList();

    if (presenter.bookDetail?.currentChapter != null) {
      chapterNumber = presenter.bookDetail!.currentChapter!.chapterOrder!;

      if (_selectedChapter.isEmpty ||
          !_selectedChapter.contains("Chương $chapterNumber:")) {
        _selectedChapter =
            "Chương ${presenter.bookDetail?.currentChapter?.chapterOrder}: ${presenter.bookDetail?.currentChapter?.title}";
      }
    }

    Color adjustedBackgroundColor = _backgroundColor.withOpacity(
      _backgroundOpacity,
    );

    return GestureDetector(
      onTap: () {
        if (_isFabExpanded) {
          setState(() {
            _isFabExpanded = false;
          });
        }

        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: adjustedBackgroundColor,
        appBar: BaseAppbar(
          title: presenter.bookDetail?.title ?? "",
          backgroundColor: adjustedBackgroundColor,
          textColor: Colors.black,
          onBack: () {
            presenter.setHistoryBook(
              note: noteController.text,
              chapNumber: chapterNumber,
            );
          },
          onHomeTap: () {
            presenter.setHistoryBook(
              note: noteController.text,
              chapNumber: chapterNumber,
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainApp.routeName,
              (route) => false,
            );
          },
        ),
        body: Stack(
          children: [
            Column(
              children: [
                InkWell(
                  onTap: _scrollToTop,
                  child: Container(
                    padding: EdgeInsets.all(kDefaultPadding),
                    child: Column(
                      children: [
                        Text(
                          "${presenter.bookDetail?.currentChapter?.title}",
                          style: TextStyle(
                            fontSize: fontSize_15sp,
                            color: colorRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(child: AdBannerWidget()),
                SizedBox(height: height_5),

                Expanded(
                  child: RawScrollbar(
                    thumbColor: Colors.grey.withOpacity(0.5),
                    radius: Radius.circular(20),
                    thickness: 15,
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: width_25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText.rich(
                            TextSpan(
                              children: _buildTextWithNotes(
                                presenter.bookDetail?.currentChapter?.content ??
                                    '',
                              ),
                            ),
                            style: TextStyle(fontSize: _fontSize, height: 1.5),
                            toolbarOptions: ToolbarOptions(
                              copy: true,
                              selectAll: true,
                            ),
                            onSelectionChanged: (selection, cause) {
                              if (selection != null && selection.isValid) {
                                final text =
                                    presenter
                                        .bookDetail
                                        ?.currentChapter
                                        ?.content ??
                                    '';
                                if (selection.start >= 0 &&
                                    selection.end <= text.length &&
                                    selection.start <= selection.end) {
                                  _selectedText = text.substring(
                                    selection.start,
                                    selection.end,
                                  );
                                  if (cause ==
                                      SelectionChangedCause.longPress) {
                                    final RenderBox box =
                                        context.findRenderObject() as RenderBox;
                                    final Offset position = box.localToGlobal(
                                      Offset(
                                        selection.baseOffset.toDouble(),
                                        selection.extentOffset.toDouble(),
                                      ),
                                    );
                                    _showNoteMenu(context, position);
                                  }
                                }
                              } else {
                                // Reset selection when invalid
                                _selectedText = null;
                              }
                            },
                          ),

                          NativeAdWidget(),

                          SizedBox(height: kMediumPadding),

                          BottomSheetSelector(
                            title: 'Chọn chương sách',
                            items: _chapters ?? [],
                            selectedValue: _selectedChapter,
                            onValueChanged: (value) {
                              setState(() {
                                _selectedChapter = value;

                                final pattern = RegExp(r'Chương (\d+):');
                                final match = pattern.firstMatch(value);
                                if (match != null && match.groupCount >= 1) {
                                  int newChapterNumber =
                                      int.tryParse(match.group(1) ?? "") ?? 1;

                                  _handleChapterChange(
                                    newChapterNumber,
                                    presenter.bookDetail?.chapters.length ?? 1,
                                  );
                                }
                              });
                            },
                            placeholder: 'Vui lòng chọn chương sách',
                          ),

                          SizedBox(height: height_12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buttonWidget(
                                "Chương trước",
                                () => _handleChapterChange(
                                  chapterNumber - 1,
                                  presenter.bookDetail?.chapters.length ?? 1,
                                ),
                              ),
                              _buttonWidget("Chương sau", null),
                            ],
                          ),

                          SizedBox(height: height_50),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            presenter.isLoading ? const LoadingWidget() : const SizedBox(),
            if (_isRewardedLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF6357CC),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Đang tải quảng cáo...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),

        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isFabExpanded) ...[
              FloatingActionButton(
                heroTag: "note",
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () {
                  _showNoteDialog(context, _selectedText ?? '');
                },
                child: Icon(Icons.note_add, color: Colors.blue),
              ),
              SizedBox(height: 10),

              FloatingActionButton(
                heroTag: "rating",
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () {
                  _showRatingDialog(
                    context: context,
                    title: presenter.bookDetail?.title ?? "",
                    bookId: presenter.bookDetail?.bookId ?? 1,
                  );
                },
                child: Icon(Icons.star_border, color: Colors.amber),
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                heroTag: "background",
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () {
                  _showBackgroundColorDialog(context);
                },
                child: Icon(Icons.color_lens, color: Colors.teal),
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                heroTag: "font",
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () {
                  _showFontSizeDialog(context);
                },
                child: Icon(Icons.format_size, color: Colors.purple),
              ),
              SizedBox(height: 10),
            ],

            FloatingActionButton(
              heroTag: "main",
              backgroundColor: Color(0xFF6357CC),
              onPressed: () {
                setState(() {
                  _isFabExpanded = !_isFabExpanded;
                });
              },
              child: Icon(
                _isFabExpanded ? Icons.close : Icons.menu,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBackgroundColorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double tempOpacity = _backgroundOpacity;
        Color tempColor = _backgroundColor;

        List<Color> colorOptions = [
          ColorPalette.backgroundColor,
          Color(0xFFF5F5DC),
          Color(0xFFFFF8DC),
          Color(0xFFF0F8FF),
          Color(0xFFF5FFFA),
          Color(0xFFFFF0F5),
        ];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Điều chỉnh màu nền"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Chọn màu nền:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        colorOptions.map((color) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                tempColor = color;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      tempColor == color
                                          ? Color(0xFF6357CC)
                                          : Colors.grey,
                                  width: tempColor == color ? 3 : 1,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  SizedBox(height: 20),
                  Text(
                    "Điều chỉnh độ sáng:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Slider(
                    value: tempOpacity,
                    min: 0.3,
                    max: 1.0,
                    divisions: 7,
                    activeColor: Color(0xFF6357CC),
                    label: tempOpacity.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        tempOpacity = value;
                      });
                    },
                  ),

                  SizedBox(height: 15),

                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: tempColor.withOpacity(tempOpacity),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Xem trước nội dung",
                      style: TextStyle(fontSize: _fontSize, height: 1.5),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Hủy"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6357CC),
                  ),
                  child: Text("Áp dụng", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    this.setState(() {
                      _backgroundColor = tempColor;
                      _backgroundOpacity = tempOpacity;
                    });
                    _saveSettings(); // Lưu cài đặt khi áp dụng
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showFontSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double tempFontSize = _fontSize;
        return AlertDialog(
          title: Text("Điều chỉnh cỡ chữ"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Kích thước hiện tại: ${tempFontSize.toStringAsFixed(1)}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Slider(
                    value: tempFontSize,
                    min: 10.0,
                    max: 24.0,
                    divisions: 14,
                    activeColor: Color(0xFF6357CC),
                    label: tempFontSize.toStringAsFixed(1),
                    onChanged: (double value) {
                      setState(() {
                        tempFontSize = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Mẫu văn bản",
                    style: TextStyle(fontSize: tempFontSize, height: 1.5),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6357CC),
              ),
              child: Text("Áp dụng"),
              onPressed: () {
                setState(() {
                  _fontSize = tempFontSize;
                });
                _saveSettings(); // Lưu cài đặt khi áp dụng
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showRatingDialog({
    required BuildContext context,
    required String title,
    required int bookId,
  }) {
    double rating = 0;
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Đánh giá sách"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Bạn thấy cuốn sách này thế nào?",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        _getRatingText(rating),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6357CC),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Nhận xét của bạn:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText:
                            "Chia sẻ cảm nhận của bạn về cuốn sách này...",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      maxLines: 5,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6357CC),
              ),
              child: Text("Đánh giá", style: TextStyle(color: Colors.white)),
              onPressed: () {
                String comment = commentController.text.trim();
                String ratingMessage = "Đã gửi đánh giá ${rating.toInt()} sao";

                ReviewBookService reviewBookService = ReviewBookService();
                reviewBookService.createReview(
                  bookId: bookId,
                  rating: rating.toInt(),
                  comment: comment,
                );

                if (comment.isNotEmpty) {
                  ratingMessage += " với nhận xét";
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ratingMessage),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getRatingText(double rating) {
    if (rating == 0) return "Chưa đánh giá";
    if (rating == 1) return "Rất tệ";
    if (rating == 2) return "Tệ";
    if (rating == 3) return "Bình thường";
    if (rating == 4) return "Tốt";
    if (rating == 5) return "Rất tuyệt vời";
    return "";
  }

  List<TextSpan> _buildTextWithNotes(String text) {
    List<TextSpan> spans = [];
    int currentIndex = 0;

    // Lấy danh sách ghi chú từ notifier
    final presenter = Provider.of<DetailBookNotifier>(context, listen: false);
    final noteList = presenter.noteBook ?? [];

    // Sắp xếp ghi chú theo vị trí bắt đầu
    noteList.sort(
      (a, b) => (a.startPosition ?? 0).compareTo(b.startPosition ?? 0),
    );

    // Xử lý từng ghi chú theo thứ tự
    for (var note in noteList) {
      if (note.selectedText != null &&
          note.startPosition != null &&
          note.endPosition != null) {
        int startIndex = note.startPosition!;
        int endIndex = note.endPosition!;

        // Kiểm tra tính hợp lệ của vị trí
        if (startIndex < 0 ||
            endIndex > text.length ||
            startIndex >= endIndex) {
          continue; // Bỏ qua ghi chú không hợp lệ
        }

        // Thêm text trước ghi chú
        if (startIndex > currentIndex) {
          spans.add(TextSpan(text: text.substring(currentIndex, startIndex)));
        }

        // Thêm ghi chú với icon
        spans.add(
          TextSpan(
            text: note.selectedText,
            style: TextStyle(
              backgroundColor: Color(0xFF6357CC).withOpacity(0.1),
            ),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: () => _showNoteContent(context, note.selectedText!),
                  child: Container(
                    margin: EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.note_alt_outlined,
                      size: 16,
                      color: Color(0xFF6357CC),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

        currentIndex = endIndex;
      }
    }

    // Thêm phần text còn lại
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return spans;
  }
}
