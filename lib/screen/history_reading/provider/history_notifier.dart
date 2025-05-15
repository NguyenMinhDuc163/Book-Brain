import 'package:book_brain/screen/history_reading/service/history_service.dart';
import 'package:book_brain/service/api_service/response/history_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';

class HistoryNotifier extends BaseNotifier {
  HistoryService historyService = HistoryService();
  late List<HistoryResponse> allHistory = [];
  late List<HistoryResponse> currentHistory = [];
  late List<HistoryResponse> completedHistory = [];
  Future<void> getData() async {
    await getAllHistory();
    await getCurrentHistory();
    await getCompletedHistory();
  }

  Future<bool> getAllHistory() async {
    return await execute(() async {
      allHistory = (await historyService.getHistory(limit: 10, page: 1))!;
      notifyListeners();
      return true;
    });
  }

  Future<bool> getCurrentHistory() async {
    return await execute(() async {
      currentHistory =
          (await historyService.getHistory(
            limit: 10,
            page: 1,
            status: "reading",
          ))!;

      notifyListeners();
      return true;
    });
  }

  Future<bool> getCompletedHistory() async {
    return await execute(() async {
      completedHistory =
          (await historyService.getHistory(
            limit: 10,
            page: 1,
            status: "completed",
          ))!;

      notifyListeners();
      return true;
    });
  }
}
