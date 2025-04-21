import 'package:book_brain/screen/history_reading/service/history_interface.dart';
import 'package:book_brain/screen/preview/service/preview_interface.dart';
import 'package:book_brain/screen/reivew_book/service/review_book_interface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/request/create_reivew_request.dart';
import 'package:book_brain/service/api_service/request/update_history_request.dart';
import 'package:book_brain/service/api_service/response/all_review_response.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/create_review_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/history_response.dart';
import 'package:book_brain/service/api_service/response/review_stats_response.dart';
import 'package:book_brain/service/api_service/response/update_history_response.dart';

class HistoryService implements IHistoryInterface {
  final ApiServices apiServices = ApiServices();

  @override
  Future<List<HistoryResponse>?> getHistory({String? status, required int page, required int limit}) async {
    final BaseResponse<HistoryResponse> response = await apiServices
        .getHistory(status: status, page: page, limit: limit);
    if (response.code != null) {
      List<HistoryResponse> data = response.data!;
      return data;
    }
    return null;
  }

  @override
  Future<bool?> updateHistory({required int bookId, required String readingStatus, required double completionRate, required String notes}) async{
    final UpdateHistoryRequest request = UpdateHistoryRequest(
      bookId: bookId,
      readingStatus: readingStatus,
      completionRate: completionRate,
      notes: notes,
    );

    final BaseResponse<UpdateHistoryResponse> response = await apiServices
        .sendUpdateHistory(request);
    if (response.code != null) {
      return true;
    }
    return false;
  }
}
