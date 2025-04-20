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
}
