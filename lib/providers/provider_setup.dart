import 'package:book_brain/screen/login/provider/login_notifier.dart';
import 'package:book_brain/screen/login/provider/register_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderSetup {
  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider(create: (_) => LoginNotifier()),
      ChangeNotifierProvider(create: (_) => RegisterNotifier()),
      // Thêm các Provider khác ở đây
    ];
  }
}
