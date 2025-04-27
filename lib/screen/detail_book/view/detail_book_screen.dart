import 'package:book_brain/screen/detail_book/provider/detail_book_notifier.dart';
import 'package:book_brain/screen/detail_book/widget/bottom_sheet_selector.dart';
import 'package:book_brain/screen/reivew_book/service/review_book_service.dart';
import 'package:book_brain/utils/core/common/toast.dart';
import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/widget/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/widget/loading_widget.dart';

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

  Color _backgroundColor = ColorPalette.backgroundColor;
  double _backgroundOpacity = 1.0;


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

    Future.microtask(
      () => Provider.of<DetailBookNotifier>(
        context,
        listen: false,
      ).getData(bookId: widget.bookId ?? 1, chapterId: widget.chapterId ?? 1),
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
          onBack: (){
            presenter.setHistoryBook(note: noteController.text, chapNumber: chapterNumber);
            Navigator.of(context).pop();
          },
        ),

        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Text(
                    "${presenter.bookDetail?.currentChapter?.title}",
                    style: TextStyle(fontSize: fontSize_15sp, color: colorRed),
                  ),
                ),

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
                          Text(
                            presenter.bookDetail?.currentChapter?.content ?? '',
                            style: TextStyle(fontSize: _fontSize, height: 1.5),
                          ),

                          SizedBox(height: height_20),

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

                                  _updateChapter(newChapterNumber,
                                      presenter.bookDetail?.chapters.length ?? 1);
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
                                () => _updateChapter(chapterNumber - 1,
                                    presenter.bookDetail?.chapters.length ?? 1),
                              ),
                              _buttonWidget(
                                "Chương sau",
                                () => _updateChapter(chapterNumber + 1,
                                    presenter.bookDetail?.chapters.length ?? 1),),

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
          ],
        ),

        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isFabExpanded) ...[
              FloatingActionButton(
                heroTag: "bookmark",
                mini: true,
                backgroundColor: _isBookmarked ? Colors.amber : Colors.white,
                onPressed: () {
                  setState(() {
                    _isBookmarked = !_isBookmarked;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isBookmarked ? "Đã thêm bookmark" : "Đã xóa bookmark",
                      ),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: _isBookmarked ? Colors.white : Colors.amber,
                ),
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
                heroTag: "note",
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () {
                  _showNoteDialog(context);
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNoteDialog(BuildContext context) {
    // final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thêm ghi chú"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              child: Text("Lưu"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Đã lưu ghi chú"),
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
}
