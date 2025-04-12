import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/extentions/size_extension.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';

import '../model/ranking_user.dart';

class RankingPodium extends StatelessWidget {
  final List<RankingUser> topUsers;

  const RankingPodium({
    Key? key,
    required this.topUsers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (topUsers.length < 3) {
      return Center(child: Text('Không đủ dữ liệu để hiển thị bảng xếp hạng'));
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Stack(
        children: [
          // Phần podium cố định ở phía sau
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF6A5AE0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Top 3 users
                SizedBox(
                  height: height_420,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Position #2 (left)
                      Positioned(
                        left: 20,
                        bottom: height_100,
                        child: _buildPositionColumn(
                          user: topUsers[1],
                          position: 2,
                        ),
                      ),

                      // Position #1 (center)
                      Positioned(
                        bottom: 60.h,
                        child: _buildPositionColumn(
                          user: topUsers[0],
                          position: 1,
                          isCrowned: true,
                        ),
                      ),

                      // Position #3 (right)
                      Positioned(
                        right: 20,
                        bottom: height_100,
                        child: _buildPositionColumn(
                          user: topUsers[2],
                          position: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // DraggableScrollableSheet có thể kéo lên xuống
          Align(
            alignment: Alignment.bottomCenter,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.5,
                maxChildSize: 1,
                snap: true,
                // snapSizes: [0.5, 0.5, ],
                builder: (BuildContext context, ScrollController scrollController) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // Background container
                      Container(
                        padding: EdgeInsets.only(top: 20), // Thêm padding phía trên để chừa chỗ cho notch
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, -3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10), // Chừa khoảng trống cho notch

                            // List
                            Expanded(
                              child: topUsers != null && topUsers.isNotEmpty
                                  ? ListView.builder(
                                controller: scrollController,
                                padding: EdgeInsets.all(kDefaultPadding),
                                itemCount: topUsers!.length,
                                itemBuilder: (context, index) {
                                  return _buildRankingListItem(topUsers![index]);
                                },
                              )
                                  : Center(child: Text("Không có dữ liệu xếp hạng khác")),
                            ),
                          ],
                        ),
                      ),

                      // Notch at the top
                      Positioned(
                        top: -2.5,
                        child: Container(
                          width: 60,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                      ),

                      // Small bump decoration
                      Positioned(
                        top: -15,
                        child: Container(
                          width: 120,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(100),
                              bottom: Radius.circular(0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: Offset(0, -1),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionColumn({
    required RankingUser user,
    required int position,
    bool isCrowned = false,
  }) {
    // [code phương thức _buildPositionColumn giữ nguyên]
    double avatarSize = position == 1 ? 80 : 70;

    // Xác định chiều cao cho từng vị trí
    double podiumHeight;
    switch (position) {
      case 1:
        podiumHeight = 280; // Cột cao nhất
        break;
      case 2:
        podiumHeight = 200; // Cột thứ hai
        break;
      case 3:
        podiumHeight = 150; // Cột thấp nhất
        break;
      default:
        podiumHeight = 150;
    }

    // Xác định hình ảnh rank dựa trên vị trí
    String rankImage;
    switch (position) {
      case 1:
        rankImage = AssetHelper.rank1;
        break;
      case 2:
        rankImage = AssetHelper.rank2;
        break;
      case 3:
        rankImage = AssetHelper.rank3;
        break;
      default:
        rankImage = AssetHelper.rank1;
    }

    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar and crown
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Avatar circle
            CircleAvatar(
              radius: avatarSize / 2,
              backgroundColor: user.avatarBackgroundColor,
              child: Icon(Icons.person, size: avatarSize * 0.6, color: Colors.white),
            ),

            // Crown for 1st place
            if (isCrowned)
              Positioned(
                top: -20,
                left: 0,
                right: 0,
                child: Center(
                  child: ImageHelper.loadFromAsset(
                    AssetHelper.icoCrown,
                    width: 30,
                    height: 30,
                  ),
                ),
              ),

            // Country flag (fake with a colored box)
            Positioned(
              bottom: 0,
              right: -5,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: user.flagColor ?? Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 8),

        // Username
        Text(
          user.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: position == 1 ? 18 : 16,
          ),
        ),

        SizedBox(height: 4),

        // Score
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFF8F89FB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            user.score,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(height: 16),

        // Rank podium image
        ImageHelper.loadFromAsset(
          rankImage,
          width: position == 1 ? 200 : 100,
          height: podiumHeight,
        ),
      ],
    );
  }

  // Widget hiển thị người dùng từ hạng 4 trở đi
  Widget _buildRankingListItem(RankingUser user) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank number
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Text(
              "${user.rank ?? '?'}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          SizedBox(width: 12),

          // Avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: user.avatarBackgroundColor,
                child: Icon(Icons.person, color: Colors.white),
              ),

              // Country flag
              Positioned(
                bottom: 0,
                right: -5,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: user.flagColor ?? Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 12),

          // Name and score
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  user.score,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

