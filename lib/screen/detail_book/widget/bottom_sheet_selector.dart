import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

/// Widget hiển thị lựa chọn với Bottom Sheet
class BottomSheetSelector extends StatefulWidget {
  /// Tiêu đề của bottom sheet
  final String title;

  /// Danh sách các mục để chọn
  final List<String> items;

  /// Giá trị đã chọn
  final String selectedValue;

  /// Placeholder hiển thị khi chưa chọn giá trị
  final String placeholder;

  /// Callback khi giá trị được chọn
  final Function(String) onValueChanged;

  /// Text hiển thị trên nút mở bottom sheet
  final String? buttonText;

  /// Text hiển thị trên nút đóng bottom sheet
  final String closeButtonText;

  /// Text hiển thị trong ô tìm kiếm
  final String searchHintText;

  /// Icon hiển thị trong trường chọn
  final IconData? dropdownIcon;

  /// Cho phép tìm kiếm hay không
  final bool enableSearch;

  /// Chiều cao tối đa của bottom sheet (tỷ lệ so với màn hình)
  final double maxSheetHeight;
  final Color backgroundColor;

  const BottomSheetSelector({
    Key? key,
    required this.items,
    required this.selectedValue,
    required this.onValueChanged,
    this.title = 'Chọn giá trị',
    this.placeholder = 'Chưa chọn giá trị',
    this.buttonText,
    this.closeButtonText = 'Đóng',
    this.searchHintText = 'Tìm kiếm...',
    this.dropdownIcon = Icons.arrow_drop_down,
    this.enableSearch = true,
    this.maxSheetHeight = 0.7,
    this.backgroundColor = ColorPalette.backgroundScaffoldColor,
  }) : super(key: key);

  @override
  _BottomSheetSelectorState createState() => _BottomSheetSelectorState();
}

class _BottomSheetSelectorState extends State<BottomSheetSelector> {
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: widget.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return _SelectionBottomSheet(
          title: widget.title,
          items: widget.items,
          selectedItem: widget.selectedValue,
          onItemSelected: widget.onValueChanged,
          closeButtonText: widget.closeButtonText,
          searchHintText: widget.searchHintText,
          enableSearch: widget.enableSearch,
          maxSheetHeight: widget.maxSheetHeight,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiển thị giá trị đã chọn
        GestureDetector(
          onTap: _showBottomSheet,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.selectedValue.isNotEmpty ? widget.selectedValue : widget.placeholder,
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.selectedValue.isNotEmpty ? Colors.black : Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(widget.dropdownIcon, color: Colors.grey),
              ],
            ),
          ),
        ),

        // Nút mở bottom sheet (nếu cần)
        if (widget.buttonText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showBottomSheet,
                child: Text(widget.buttonText!),
              ),
            ),
          ),
      ],
    );
  }
}

/// Bottom sheet hiển thị danh sách lựa chọn
class _SelectionBottomSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final String selectedItem;
  final Function(String) onItemSelected;
  final String closeButtonText;
  final String searchHintText;
  final bool enableSearch;
  final double maxSheetHeight;

  const _SelectionBottomSheet({
    Key? key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
    required this.closeButtonText,
    required this.searchHintText,
    required this.enableSearch,
    required this.maxSheetHeight,
  }) : super(key: key);

  @override
  _SelectionBottomSheetState createState() => _SelectionBottomSheetState();
}

class _SelectionBottomSheetState extends State<_SelectionBottomSheet> {
  late TextEditingController _searchController;
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = List.from(widget.items);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.items);
      } else {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * widget.maxSheetHeight,
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: [
          // Thanh kéo ở trên cùng
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          SizedBox(height: 16),

          // Tiêu đề
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),

          // Thanh tìm kiếm (nếu được bật)
          if (widget.enableSearch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.searchHintText,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: _filterItems,
              ),
            ),
          if (widget.enableSearch) SizedBox(height: 16),

          // Danh sách các mục
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final bool isSelected = widget.selectedItem == item;

                // Xác định mức độ thụt lề dựa trên số lượng dấu "-" ở đầu
                int indentLevel = 0;
                if (item.startsWith("--")) indentLevel = 2;
                else if (item.startsWith("-")) indentLevel = 1;

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(
                      left: 16.0 + (indentLevel * 16.0),
                      right: 16.0,
                    ),
                    title: Text(
                      item,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    onTap: () {
                      widget.onItemSelected(item);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),

          // Nút đóng
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(widget.closeButtonText),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}