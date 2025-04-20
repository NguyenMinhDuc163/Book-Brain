import 'package:book_brain/screen/following_book/provider/subscription_notifier.dart';
import 'package:book_brain/screen/preview/view/preview_screen.dart';
import 'package:book_brain/service/api_service/response/subscriptions_response.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/utils/utils.dart';
import 'package:book_brain/utils/widget/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';

class FollowingBookScreen extends StatefulWidget {
  const FollowingBookScreen({super.key});
  static const String routeName = '/following_book_sceen';
  @override
  State<FollowingBookScreen> createState() => _FollowingBookScreenState();
}

class _FollowingBookScreenState extends State<FollowingBookScreen> {
  bool _isGridView = true;
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<SubscriptionNotifier>(context, listen: false).getData();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SubscriptionNotifier>(context);

    return KeyboardDismisser(
      gestures: const [GestureType.onTap],
      child: Scaffold(
        body: AppBarContainerWidget(
          titleString: "Sách theo dõi",
          bottomWidget: _buildSearchBar(),
          child: Column(
            children: [
              SizedBox(height: height_20),
              _buildHeader(),
              SizedBox(height: 16),
      
              Expanded(
                child: presenter.isLoading
                    ? Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF6357CC),
                  ),
                )
                    : _buildBookContent(presenter),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: "Tìm kiếm sách theo dõi...",
          prefixIcon: Icon(Icons.search, color: Color(0xff6357CC)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: Color(0xff6357CC)),
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
            },
          )
              : null,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Sách bạn đang theo dõi",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff6357CC),
            ),
          ),
        ),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
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
                borderRadius: BorderRadius.horizontal(left: Radius.circular(18)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isGridView = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: _isGridView
                            ? LinearGradient(
                          colors: [Color(0xFF8F67E8), Color(0xFF6357CC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null,
                        color: _isGridView ? null : Colors.white,
                      ),
                      child: Icon(
                        Icons.grid_view_rounded,
                        size: 18,
                        color: _isGridView ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.horizontal(right: Radius.circular(18)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isGridView = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: !_isGridView
                            ? LinearGradient(
                          colors: [Color(0xFF8F67E8), Color(0xFF6357CC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null,
                        color: !_isGridView ? null : Colors.white,
                      ),
                      child: Icon(
                        Icons.view_list_rounded,
                        size: 18,
                        color: !_isGridView ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookContent(SubscriptionNotifier presenter) {
    // Lọc danh sách theo từ khóa tìm kiếm
    List<SubscriptionsResponse> filteredBooks = _searchQuery.isEmpty
        ? presenter.subscriptions
        : presenter.subscriptions.where((book) =>
    (book.title?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
        (book.authorName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
    ).toList();

    if (filteredBooks.isEmpty) {
      return _buildEmptyState();
    }

    return _isGridView
        ? _buildGridView(filteredBooks)
        : _buildListView(filteredBooks);
  }

  Widget _buildGridView(List<SubscriptionsResponse> books) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return _buildGridItem(books[index]);
      },

    );
  }

  Widget _buildListView(List<SubscriptionsResponse> books) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return _buildListItem(books[index]);
      },
    );
  }

  Widget _buildGridItem(SubscriptionsResponse book) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PreviewScreen(bookId: book.bookId,)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh bìa sách
              (book.imageUrl ?? '') != ''
                  ? Image.network(
                book.imageUrl ?? "",
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    ImageHelper.loadFromAsset(
                      AssetHelper.harryPotterCover,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
              )
                  : ImageHelper.loadFromAsset(
                AssetHelper.harryPotterCover,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),

              // Thông tin sách
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        book.authorName ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          SizedBox(width: 2),
                          Text(
                            book.rating?.toString() ?? "0.0",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(SubscriptionsResponse book) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PreviewScreen(bookId: book.bookId,)));

      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: (book.imageUrl ?? '') != ''
                  ? Image.network(
                book.imageUrl ?? "",
                width: 100,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    ImageHelper.loadFromAsset(
                      AssetHelper.harryPotterCover,
                      width: 100,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
              )
                  : ImageHelper.loadFromAsset(
                AssetHelper.harryPotterCover,
                width: 100,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      book.authorName ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          book.rating?.toString() ?? "0.0",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " (${book.views ?? '0'} lượt xem)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Theo dõi từ: ${_formatDate(Utils.formatDate(book.subscribedAt))}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "N/A";

    try {
      DateTime date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return "N/A";
    }
  }

  Widget _buildEmptyState() {
    return _searchQuery.isNotEmpty
        ? Center(
      child: EmptyDataWidget(
        title: "Không tìm thấy sách phù hợp",
        styleTitle: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
        height: height_200,
        width: width_200,
      ),
    )
        : Center(
      child: EmptyDataWidget(
        title: "Bạn chưa theo dõi sách nào",
        styleTitle: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
        height: height_200,
        width: width_200,
      ),
    );
  }
}