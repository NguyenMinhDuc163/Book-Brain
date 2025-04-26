import 'dart:math' as math;
import 'dart:ui';

// Danh sách các màu đẹp cho avatar
final List<Color> avatarColors = [
  Color(0xFF5E35B1), // Deep Purple
  Color(0xFF3949AB), // Indigo
  Color(0xFF1E88E5), // Blue
  Color(0xFF039BE5), // Light Blue
  Color(0xFF00ACC1), // Cyan
  Color(0xFF00897B), // Teal
  Color(0xFF43A047), // Green
  Color(0xFF7CB342), // Light Green
  Color(0xFFC0CA33), // Lime
  Color(0xFFFDD835), // Yellow
  Color(0xFFFFB300), // Amber
  Color(0xFFFB8C00), // Orange
  Color(0xFFF4511E), // Deep Orange
  Color(0xFF6D4C41), // Brown
  Color(0xFF757575), // Grey
  Color(0xFF546E7A), // Blue Grey
  Color(0xFFEC407A), // Pink
  Color(0xFFAB47BC), // Purple
];

// Hàm lấy màu dựa trên tên người dùng
Color getColorFromName(String name) {
  if (name.isEmpty) return avatarColors[0];

  // Sử dụng tên làm seed để chọn màu
  int hashCode = name.hashCode;
  int index = hashCode.abs() % avatarColors.length;

  return avatarColors[index];
}

// Hàm lấy chữ cái đầu từ tên người dùng
String getInitials(String name) {
  if (name.isEmpty) return "?";

  List<String> nameParts = name.split(' ');
  if (nameParts.isEmpty) return name[0].toUpperCase();

  if (nameParts.length == 1) {
    return nameParts[0][0].toUpperCase();
  }

  // Lấy chữ cái đầu của phần đầu và phần cuối
  return nameParts.first[0].toUpperCase() + nameParts.last[0].toUpperCase();
}