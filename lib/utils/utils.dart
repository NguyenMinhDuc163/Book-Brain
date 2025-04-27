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
      
      final parts = rating.split('/');
      if (parts.length != 2) return null;

      
      final ratingValue = double.tryParse(parts[0]);
      if (ratingValue == null) return null;

      
      final convertedValue = (ratingValue / 2).toStringAsFixed(1);
      return "$convertedValue/5";
    } catch (e) {
      return null;
    }
  }


  static String formatDate(DateTime? date) {
    if (date == null) return "N/A";

    try {
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return "N/A";
    }
  }


  static int convertCompletionRate(String rateStr) {
    try {
      double rate = double.parse(rateStr);

      if (rate < 1 || rate > 10) {
        return 0;
      }

      return (rate * 10).toInt();
    } catch (e) {
      // Xử lý lỗi nếu không thể parse
      print('Lỗi chuyển đổi tỉ lệ: $e');
      return 0;
    }
  }


 static String convertToFormattedDate(String isoDateString) {
    try {
      DateTime dateTime = DateTime.parse(isoDateString);

      return '${twoDigitFormat(dateTime.day)}/${twoDigitFormat(dateTime.month)}/${dateTime.year}';
    } catch (e) {
      print('Lỗi chuyển đổi ngày: $e');
      return '';
    }
  }

 static String twoDigitFormat(int number) {
    return number.toString().padLeft(2, '0');
  }
}
