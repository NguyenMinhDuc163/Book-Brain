import 'package:book_brain/screen/detail_book/provider/detail_book_notifier.dart';
import 'package:book_brain/screen/detail_book/widget/bottom_sheet_selector.dart';
import 'package:book_brain/utils/core/common/toast.dart';
import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/constants/mock_data.dart';
import 'package:book_brain/utils/widget/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  final List<String> _chapters = MockData.mockChapters;

  Widget _buttonWidget(String text, Function ()? onTap) {
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
            ]
        ),
        child: Text(text, style: TextStyle(fontSize: fontSize_13sp),),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    
    if (widget.chapterId != null) {
      chapterNumber = widget.chapterId!;
    }

    Future.microtask(() =>
        Provider.of<DetailBookNotifier>(context, listen: false).getData(
            bookId: widget.bookId ?? 1,
            chapterId: widget.chapterId ?? 1
        )
    );
  }

  
  void _updateChapter(int newChapterNumber) {
    if (newChapterNumber < 1) {
      showToastTop(message: "Bạn đang ở chương đầu tiên");
      return;
    }

    if (newChapterNumber > 5) { 
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
        bookId: Provider.of<DetailBookNotifier>(context, listen: false).bookDetail?.bookId ?? 1,
        chapterId: newChapterNumber
    );
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<DetailBookNotifier>(context);
    final List<String>? _chapters = presenter.bookDetail?.chapters.map((chapter) =>
    "Chương ${chapter.chapterOrder}: ${chapter.title}"
    ).toList();

    
    if (presenter.bookDetail?.currentChapter != null) {
      
      chapterNumber = presenter.bookDetail!.currentChapter!.chapterOrder!;

      
      if (_selectedChapter.isEmpty || !_selectedChapter.contains("Chương $chapterNumber:")) {
        _selectedChapter = "Chương ${presenter.bookDetail?.currentChapter?.chapterOrder}: ${presenter.bookDetail?.currentChapter?.title}";
      }
    }

    return Scaffold(
      backgroundColor: ColorPalette.backgroundColor,
      appBar: BaseAppbar(
          title: presenter.bookDetail?.title ?? "",
          backgroundColor: ColorPalette.backgroundColor,
          textColor: Colors.black
      ),

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Text(
                "${presenter.bookDetail?.currentChapter?.title}",
                style: TextStyle(fontSize: fontSize_15sp, color: colorRed)
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
                      style: TextStyle(
                        fontSize: _fontSize,
                        height: 1.5,
                      ),
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
                            int newChapterNumber = int.tryParse(match.group(1) ?? "") ?? 1;
                            
                            _updateChapter(newChapterNumber);
                          }
                        });
                      },
                      placeholder: 'Vui lòng chọn chương sách',
                    ),

                    SizedBox(height: height_12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buttonWidget("Chương trước", () => _updateChapter(chapterNumber - 1)),
                        _buttonWidget("Chương sau", () => _updateChapter(chapterNumber + 1)),
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
                    content: Text(_isBookmarked ? "Đã thêm bookmark" : "Đã xóa bookmark"),
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
              heroTag: "note",
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                _showNoteDialog(context);
              },
              child: Icon(
                Icons.note_add,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),

            FloatingActionButton(
              heroTag: "rating",
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                _showRatingDialog(context);
              },
              child: Icon(
                Icons.star_border,
                color: Colors.amber,
              ),
            ),
            SizedBox(height: 10),

            FloatingActionButton(
              heroTag: "font",
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                _showFontSizeDialog(context);
              },
              child: Icon(
                Icons.format_size,
                color: Colors.purple,
              ),
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
                    style: TextStyle(
                      fontSize: tempFontSize,
                      height: 1.5,
                    ),
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
    final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thêm ghi chú"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Đoạn văn bản được chọn:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                MockData.contentBook.substring(0, 150) + "...",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
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

  void _showRatingDialog(BuildContext context) {
    double rating = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Đánh giá sách"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Harry Potter và Hòn đá phù thủy",
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
                  Text(
                    _getRatingText(rating),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6357CC),
                    ),
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
              child: Text("Đánh giá"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Đã gửi đánh giá ${rating.toInt()} sao"),
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