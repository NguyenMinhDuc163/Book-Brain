import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/core/constants/dimension_constants.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  static String routeName = '/favorites_screen';
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isGridView = true;
  String _selectedFilter = "Tất cả";
  final List<String> _filters = ["Tất cả", "Đọc gần đây", "Đã đọc", "Chưa đọc"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBarContainerWidget(
        titleString: "Yêu thích",
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
            decoration: InputDecoration(
              hintText: "Tìm kiếm sách yêu thích...",
              prefixIcon: Icon(Icons.search, color: Color(0xff6357CC)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              suffixIcon: Icon(Icons.mic, color: Color(0xff6357CC)),
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

            
            _buildFilterChips(),
            SizedBox(height: 12),

            
            Expanded(
              child: _isGridView
                  ? _buildGridView()
                  : _buildListView(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        backgroundColor: Color(0xff6357CC),
        child: Icon(Icons.add, color: Colors.white),
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

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          bool isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              selected: isSelected,
              label: Text(filter),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
              backgroundColor: Colors.white,
              selectedColor: Color(0xFF6357CC),
              checkmarkColor: Colors.white,
              showCheckmark: false,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? Color(0xFF6357CC) : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              onSelected: (bool selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              padding: EdgeInsets.symmetric(horizontal: 8),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      padding: EdgeInsets.only(top: 8, bottom: 16),
      itemCount: 8, 
      itemBuilder: (context, index) {
        return _buildGridItem(index);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 8, bottom: 16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _buildListItem(index);
      },
    );
  }

  Widget _buildGridItem(int index) {
    
    final List<String> titles = [
      "Harry Potter và Hòn Đá Phù Thủy",
      "Harry Potter và Phòng Chứa Bí Mật",
      "Harry Potter và Tù Nhân Azkaban",
      "Harry Potter và Chiếc Cốc Lửa",
      "Harry Potter và Hội Phượng Hoàng",
      "Harry Potter và Hoàng Tử Lai",
      "Harry Potter và Bảo Bối Tử Thần",
      "Fantastic Beasts"
    ];

    return GestureDetector(
      onTap: () {
        
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
                  ImageHelper.loadFromAsset(
                    AssetHelper.harryPotterCover,
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
                  
                  if (index % 3 == 0)
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
                        titles[index % titles.length],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        "J. K. Rowling",
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
                                (4.5 + (index % 10) / 10).toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          
                          Icon(
                            Icons.more_vert,
                            size: 16,
                            color: Colors.grey[600],
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

  Widget _buildListItem(int index) {
    
    final List<String> titles = [
      "Harry Potter và Hòn Đá Phù Thủy",
      "Harry Potter và Phòng Chứa Bí Mật",
      "Harry Potter và Tù Nhân Azkaban",
      "Harry Potter và Chiếc Cốc Lửa",
      "Harry Potter và Hội Phượng Hoàng",
      "Harry Potter và Hoàng Tử Lai",
      "Harry Potter và Bảo Bối Tử Thần",
      "Fantastic Beasts"
    ];

    return Container(
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
                ImageHelper.loadFromAsset(
                  AssetHelper.harryPotterCover,
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                ),
                
                if (index % 3 == 0)
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
                          titles[index % titles.length],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          
                        },
                        child: Icon(
                          Icons.more_vert,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    "J. K. Rowling",
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
                        (4.5 + (index % 10) / 10).toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " (${100 + index * 10} đánh giá)",
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
                      ),
                      SizedBox(width: 8),
                      _buildActionButton(
                        Icons.favorite,
                        "Yêu thích",
                        Colors.red,
                        filled: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildActionButton(IconData icon, String label, Color color, {bool filled = false}) {
    return Container(
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
    );
  }
}