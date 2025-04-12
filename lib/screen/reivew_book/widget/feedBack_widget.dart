import 'package:expandable/expandable.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/utils/widget/dash_line_widget.dart';
import 'package:flutter/material.dart';

class FeedBackWidget extends StatefulWidget {
  const FeedBackWidget({
    Key? key,
    required this.avatar,
    required this.name,
    required this.rate,
    required this.comment,
    required this.image,
    required this.time,
  }) : super(key: key);

  final String avatar;
  final String name;
  final int rate;
  final String comment;
  final List<String> image;
  final int time;

  @override
  _FeedBackWidgetState createState() => _FeedBackWidgetState();
}

class _FeedBackWidgetState extends State<FeedBackWidget> {
  bool _isLiked = false;
  bool _isDisLike = false;

  List<Widget> _buildStarIcons() {
    List<Widget> starWidgets = [];

    for (int i = 0; i < widget.rate; i++) {
      starWidgets.add(Padding(
        padding: EdgeInsets.only(right: 2),
        child: ImageHelper.loadFromAsset(AssetHelper.icoStar),
      ));
    }

    return starWidgets;
  }

  Widget _buildCollapsed() {
    return Text(
      widget.comment.substring(0, 100),
      softWrap: true,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildExpanded() {
    return Text(
      widget.comment,
      softWrap: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(kItemPadding)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(widget.avatar),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.time} minutes ago',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
              Spacer(), 
              Row(
                children: _buildStarIcons(),
              )
            ],
          ),

          SizedBox(height: 12), 

          
          if (widget.image.isNotEmpty)
            Wrap(
              spacing: 8, 
              children: widget.image
                  .map((e) => ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: ImageHelper.loadFromAsset(e),
                ),
              ))
                  .toList(),
            ),

          SizedBox(height: 12), 

          
          ExpandableNotifier(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Expandable(
                  collapsed: _buildCollapsed(),
                  expanded: _buildExpanded(),
                ),
                Builder(
                  builder: (context) {
                    var controller = ExpandableController.of(context);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            controller.toggle();
                          },
                          child: Text(
                            controller!.expanded ? "Thu gọn" : "Xem thêm",
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          DashLineWidget(),

          
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                  color: _isLiked ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  _isDisLike ? Icons.thumb_down : Icons.thumb_down_off_alt_outlined,
                  color: _isDisLike ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isDisLike = !_isDisLike;
                  });
                },
              ),
              Spacer(), 
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {
                  
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
