import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

// Class model cho mỗi tab
class TabModel {
  final Widget title;
  final Widget view;

  TabModel({required this.title, required this.view});
}

// Widget tái sử dụng cho tab, với tên là Tabwidget
class Tabwidget extends StatefulWidget {
  final List<TabModel> tabs;
  final int initialIndex;
  final Color activeColor;
  final Color inactiveColor;
  final Color textActiveColor;    // Màu chữ khi tab được chọn
  final Color textInactiveColor;  // Màu chữ khi tab không được chọn
  final Color backgroundColor;

  const Tabwidget({
    Key? key,
    required this.tabs,
    this.initialIndex = 0,
    this.activeColor = ColorPalette.color9087E5,
    this.inactiveColor = ColorPalette.color6A5AE0,
    this.textActiveColor = Colors.white,           // Màu chữ khi tab được chọn
    this.textInactiveColor = ColorPalette.colorB9B4E4,       // Màu chữ khi tab không được chọn
    this.backgroundColor = ColorPalette.color6A5AE0,
  }) : super(key: key);

  @override
  State<Tabwidget> createState() => _TabwidgetState();
}

class _TabwidgetState extends State<Tabwidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TabBar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: widget.backgroundColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: widget.tabs.map((tab) => Tab(child: tab.title)).toList(),
            labelColor: widget.textActiveColor,         // Màu chữ khi tab được chọn
            unselectedLabelColor: widget.textInactiveColor,  // Màu chữ khi tab không được chọn
            indicator: BoxDecoration(
              color: widget.activeColor,
              borderRadius: BorderRadius.circular(30),
            ),
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: EdgeInsets.symmetric(horizontal: 8),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),

        // TabBarView
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabs.map((tab) => tab.view).toList(),
          ),
        ),
      ],
    );
  }
}