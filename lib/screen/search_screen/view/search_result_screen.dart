import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/preview/view/preview_screen.dart';
import 'package:book_brain/screen/search_screen/provider/search_notifier.dart';
import 'package:book_brain/screen/search_screen/widget/book_widgets.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/widget/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../../utils/widget/loading_widget.dart';

class SearchResultScreen extends StatefulWidget {
  final String keyword;

  const SearchResultScreen({super.key, required this.keyword});

  static const String routeName = "/searchResultScreen";

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  String _sortOption = 'A-Z';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isGridView = true;
  Timer? _debounce;
  final List<String> _sortOptions = [
    'A-Z',
    'Z-A',
    'Đánh giá cao',
    'Lượt xem nhiều',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.keyword;
    _scrollController.addListener(_onScroll);
    Future.microtask(
      () => Provider.of<SearchNotifier>(
        context,
        listen: false,
      ).getData(widget.keyword),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final presenter = Provider.of<SearchNotifier>(context, listen: false);
      if (presenter.hasMore && !presenter.isLoading) {
        presenter.loadMore();
      }
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().isNotEmpty) {
        Provider.of<SearchNotifier>(
          context,
          listen: false,
        ).getSearchData(value);
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
    Provider.of<SearchNotifier>(context, listen: false).getSearchData('');
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SearchNotifier>(context);

    return Scaffold(
      body: Stack(
        children: [
          AppBarContainerWidget(
            titleString: "Kết quả tìm kiếm",
            bottomWidget: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Tìm kiếm theo tên sách, tác giả...",
                  prefixIcon: Icon(Icons.search, color: Color(0xff6357CC)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(Icons.clear, color: Color(0xff6357CC)),
                            onPressed: _clearSearch,
                          )
                          : null,
                ),
                onChanged: (value) {
                  setState(() {});
                  _onSearchChanged(value);
                },
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    presenter.getSearchData(value);
                  }
                },
              ),
            ),
            paddingContent: EdgeInsets.symmetric(
              horizontal: kMediumPadding,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                presenter.isLoading
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFF6A5AE0),
                        ),
                      ),
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kết quả cho "${_searchController.text}"',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6A5AE0),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tìm thấy ${presenter.searchBookResponse.length} sách',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                SizedBox(height: 16),

                _buildToolbar(),
                SizedBox(height: 16),

                presenter.isLoading
                    ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6A5AE0),
                        ),
                      ),
                    )
                    : presenter.searchBookResponse.isEmpty
                    ? Expanded(
                      child: EmptyDataWidget(
                        title: "Không tìm thấy sách phù hợp",
                        styleTitle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        height: height_100,
                        width: width_100,
                      ),
                    )
                    : Expanded(
                      child:
                          _isGridView
                              ? BooksGridView(
                                books: presenter.searchBookResponse,
                                onTap: (book) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) => PreviewScreen(
                                            bookId: book.bookId,
                                          ),
                                    ),
                                  );
                                },
                                scrollController: _scrollController,
                              )
                              : BooksListView(
                                books: presenter.searchBookResponse,
                                onTap: (book) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) => PreviewScreen(
                                            bookId: book.bookId,
                                          ),
                                    ),
                                  );
                                },
                                scrollController: _scrollController,
                              ),
                    ),
                if (presenter.isLoading &&
                    presenter.searchBookResponse.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6A5AE0),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          presenter.isLoading ? const LoadingWidget() : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  offset: Offset(0, 40),
                  onSelected: (String value) {
                    setState(() {
                      _sortOption = value;
                    });
                    Provider.of<SearchNotifier>(
                      context,
                      listen: false,
                    ).sortBooks(value);
                  },
                  itemBuilder: (context) {
                    return _sortOptions.map((String option) {
                      return PopupMenuItem<String>(
                        value: option,
                        child: Row(
                          children: [
                            Icon(
                              option == _sortOption
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: Color(0xFF6A5AE0),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              option,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    option == _sortOption
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Color(0xFFf8f8f8), Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.sort, size: 18, color: Color(0xFF6A5AE0)),
                        SizedBox(width: 6),
                        Text(
                          'Sắp xếp: $_sortOption',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF6A5AE0),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isGridView = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  _isGridView
                                      ? Color(0xFF6A5AE0)
                                      : Colors.white,
                              gradient:
                                  _isGridView
                                      ? LinearGradient(
                                        colors: [
                                          Color(0xFF8F67E8),
                                          Color(0xFF6357CC),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                      : null,
                            ),
                            child: Icon(
                              Icons.grid_view_rounded,
                              size: 20,
                              color:
                                  _isGridView ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),

                    ClipRRect(
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(20),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isGridView = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  !_isGridView
                                      ? Color(0xFF6A5AE0)
                                      : Colors.white,
                              gradient:
                                  !_isGridView
                                      ? LinearGradient(
                                        colors: [
                                          Color(0xFF8F67E8),
                                          Color(0xFF6357CC),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                      : null,
                            ),
                            child: Icon(
                              Icons.view_list_rounded,
                              size: 20,
                              color:
                                  !_isGridView
                                      ? Colors.white
                                      : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
