class Utils {
  static bool isValidEmail(String email) {
    if (email.isEmpty) {
      return true;
    }
    String pattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  static bool isCheckString(String str) {
    if (str == "") {
      return false;
    }
    return true;
  }

  static String? convertRating(String? rating) {
    if (rating == null) return null;

    try {
      // Tách số từ chuỗi dạng "9.7/10"
      final parts = rating.split('/');
      if (parts.length != 2) return null;

      // Lấy giá trị số đầu tiên (9.7)
      final ratingValue = double.tryParse(parts[0]);
      if (ratingValue == null) return null;

      // Chuyển đổi sang hệ /5
      final convertedValue = (ratingValue / 2).toStringAsFixed(1);
      return "$convertedValue/5";
    } catch (e) {
      return null;
    }
  }
}
