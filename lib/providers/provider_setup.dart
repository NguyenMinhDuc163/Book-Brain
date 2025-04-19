import 'package:book_brain/screen/detail_book/provider/detail_book_notifier.dart';
import 'package:book_brain/screen/login/provider/login_notifier.dart';
import 'package:book_brain/screen/login/provider/register_notifier.dart';
import 'package:book_brain/screen/preview/provider/preview_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../screen/home/provider/home_notiffier.dart';
import '../screen/reivew_book/provider/review_book_notifier.dart';
import '../screen/search_result_screen/provider/search_notifier.dart';

class ProviderSetup {
  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider(create: (_) => LoginNotifier()),
      ChangeNotifierProvider(create: (_) => RegisterNotifier()),
      ChangeNotifierProvider(create: (_) => HomeNotiffier()),
      ChangeNotifierProvider(create: (_) => PreviewNotifier()),
      ChangeNotifierProvider(create: (_) => SearchNotifier()),
      ChangeNotifierProvider(create: (_) => DetailBookNotifier()),
      ChangeNotifierProvider(create: (_) => ReviewBookNotifier()),
      // Thêm các Provider khác ở đây
    ];
  }
}
