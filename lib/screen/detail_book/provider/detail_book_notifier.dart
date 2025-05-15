import 'package:book_brain/screen/history_reading/service/history_service.dart';
import 'package:book_brain/screen/preview/service/preview_service.dart';
import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/note_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';

import '../service/detail_book_service.dart';

class DetailBookNotifier extends BaseNotifier{
  PreviewService previewService = PreviewService();
  DetailBookService detailBookService = DetailBookService();
  DetailBookResponse? bookDetail;
  List<ChaptersResponse>? chapters;
  List<NoteResponse>? noteBook;

  Future<void> getData({required int bookId, required int chapterId}) async {
    print("=====> chapId $chapterId");

    await getBookDetail(bookId: bookId, chapterId: chapterId );
  }


  Future<bool> getBookDetail({required int bookId, required int chapterId}) async {
    return await execute(() async{
      bookDetail = await previewService.getDetailBook(bookId: bookId, chapterId: chapterId);
      notifyListeners();
      print("bookDetail $bookDetail");
      return true;
    });
  }


  Future<bool> setHistoryBook({String? note, int? chapNumber}) async {
    return await execute(() async{
      HistoryService historyService = HistoryService();
      double rate = chapNumber! / (bookDetail?.totalChapters ?? 1) * 10;
      historyService.updateHistory(
        bookId: bookDetail!.bookId ?? 1,
        readingStatus: chapNumber == bookDetail?.totalChapters ? "completed" :"reading",
        completionRate: rate,
        notes: note ?? "",
        currentChapterId: chapNumber?? 1,
      );
      notifyListeners();
      return true;
    });
  }


  Future<bool> getNoteBook({required int bookId, required int chapterId}) async {
    return await execute(() async{
      noteBook = await detailBookService.getNoteBook(bookId: bookId, chapterId: chapterId);
      notifyListeners();
      print("noteBook $noteBook");
      return true;
    });
  }


  Future<bool> saveNoteBook({required int bookId, required int chapterId, required int startPosition, required int endPosition, required String selectedText, required String noteContent}) async {
    return await execute(() async{
      bool? isSUCC =await detailBookService.saveNoteBook(bookId: bookId, chapterId: chapterId, startPosition: startPosition, endPosition: endPosition, selectedText: selectedText, noteContent: noteContent);
      notifyListeners();
      return isSUCC ?? false;
    });
  }

  Future<bool> deleteNoteBook({required int noteId}) async {
    return await execute(() async{
      bool? isSUCC =await detailBookService.deleteNoteBook(noteId: noteId);
      notifyListeners();
      return isSUCC ?? false;
    });
  }
}