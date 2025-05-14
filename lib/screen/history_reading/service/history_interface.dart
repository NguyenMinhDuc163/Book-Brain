import 'package:book_brain/service/api_service/response/all_review_response.dart';
import 'package:book_brain/service/api_service/response/create_review_response.dart';
import 'package:book_brain/service/api_service/response/history_response.dart';
import 'package:book_brain/service/api_service/response/review_stats_response.dart';

abstract class IHistoryInterface {
  Future<List<HistoryResponse>?> getHistory({
     String? status,
    required int page,
    required int limit,
  });

  Future<bool?> updateHistory({
    required int bookId,
    required String readingStatus,
    required double completionRate,
    required String notes,
    required int currentChapterId,
  });
}
