import 'package:book_brain/screen/favorites/provider/favorites_notifier.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/preview/view/preview_screen.dart';
import 'package:book_brain/service/api_service/response/favorites_response.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../utils/core/constants/dimension_constants.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  static String routeName = '/favorites_screen';
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isGridView = true;
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<FavoritesNotifier>(context, listen: false).getData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<FavoritesNotifier>(context);
    return Scaffold(
      body: AppBarContainerWidget(
        titleString: "Yêu thích",
        isShowBackButton: false,
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
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Tìm kiếm sách yêu thích...",
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
        ),

        paddingContent: EdgeInsets.only(
          left: kMediumPadding,
          right: kMediumPadding,
          top: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 16),

            Expanded(
              child: presenter.isLoading
                  ? _buildLoadingIndicator()
                  : presenter.favorites.isEmpty
                  ? _buildEmptyState()
                  : _isGridView
                  ? _buildGridView(presenter)
                  : _buildListView(presenter),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await presenter.getData();
        },
        backgroundColor: Color(0xff6357CC),
        child: Icon(FontAwesomeIcons.spinner, color: Colors.white),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: Color(0xff6357CC),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 60,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            "Bạn chưa có sách yêu thích nào",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Hãy thêm sách vào danh sách yêu thích để xem tại đây",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Sách yêu thích của bạn",
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

  
  List<FavoritesResponse> _getFilteredFavorites(FavoritesNotifier presenter) {
    if (_searchQuery.isEmpty) {
      return presenter.favorites;
    }

    return presenter.favorites.where((favorite) =>
    favorite.title!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        favorite.authorName!.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  Widget _buildGridView(FavoritesNotifier presenter) {
    final filteredFavorites = _getFilteredFavorites(presenter);

    return filteredFavorites.isEmpty
        ? _buildSearchEmptyState()
        : GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      padding: EdgeInsets.only(top: 8, bottom: 16),
      itemCount: filteredFavorites.length,
      itemBuilder: (context, index) {
        return _buildGridItem(filteredFavorites[index], index);
      },
    );
  }

  Widget _buildListView(FavoritesNotifier presenter) {
    final filteredFavorites = _getFilteredFavorites(presenter);

    return filteredFavorites.isEmpty
        ? _buildSearchEmptyState()
        : ListView.builder(
      padding: EdgeInsets.only(top: 8, bottom: 16),
      itemCount: filteredFavorites.length,
      itemBuilder: (context, index) {
        return _buildListItem(filteredFavorites[index], index);
      },
    );
  }

  Widget _buildSearchEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            "Không tìm thấy sách phù hợp",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Thử tìm kiếm với từ khóa khác",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(FavoritesResponse favorite, int index) {
    final bool isReading = favorite.status == "reading"; 

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PreviewScreen(bookId: favorite.bookId,)));

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
              Stack(
                children: [
                  
                  (favorite.imageUrl ?? '') != ''
                      ? Image.network(
                    favorite.imageUrl ?? "",
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        ImageHelper.loadFromAsset(
                          AssetHelper.defaultImage,
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                  )
                      : ImageHelper.loadFromAsset(
                    AssetHelper.defaultImage,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),

                  
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ),

                  
                  if (isReading)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        color: Colors.black.withOpacity(0.7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bookmark,
                              color: Colors.amber,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Đang đọc",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        favorite.title ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        favorite.authorName ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 14),
                              SizedBox(width: 2),
                              Text(
                                favorite.rating.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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

  Widget _buildListItem(FavoritesResponse favorite, int index) {
    final bool isReading = favorite.status == "reading"; 

    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PreviewScreen(bookId: favorite.bookId,)));

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
              child: Stack(
                children: [
                  
                  (favorite.imageUrl ?? "") != ''
                      ? Image.network(
                    favorite.imageUrl ?? "",
                    width: 100,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        ImageHelper.loadFromAsset(
                          AssetHelper.defaultImage,
                          width: 100,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                  )
                      : ImageHelper.loadFromAsset(
                    AssetHelper.defaultImage,
                    width: 100,
                    height: 140,
                    fit: BoxFit.cover,
                  ),

                  
                  if (isReading)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Đang đọc",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            favorite.title ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      favorite.authorName ?? "",
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
                          favorite.rating.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " (${favorite.views} lượt xem)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        _buildActionButton(
                          Icons.play_arrow_rounded,
                          "Đọc tiếp",
                          Color(0xFF6357CC),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PreviewScreen(bookId: favorite.bookId,)));
                          },
                        ),
                        SizedBox(width: 8),
                        _buildActionButton(
                          Icons.favorite,
                          "Yêu thích",
                          Colors.red,
                          filled: true,
                          onTap: () {
                            _confirmRemoveFavorite(context, favorite);
                          },
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
    );
  }

  
  void _confirmRemoveFavorite(BuildContext context, FavoritesResponse favorite) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xóa khỏi Yêu thích"),
          content: Text("Bạn có chắc muốn xóa \"${favorite.title}\" khỏi danh sách yêu thích không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                Provider.of<FavoritesNotifier>(context, listen: false).deleteFavorites(bookId: favorite.bookId);
                Navigator.of(context).pop();
              },
              child: Text("Xóa", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


  Widget _buildActionButton(IconData icon, String label, Color color, {bool filled = false, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: filled ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: color,
            ),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}