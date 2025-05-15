import 'package:book_brain/screen/detail_book/service/detail_book_interface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/request/save_note_request.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/note_response.dart';


class DetailBookService implements IDetailBookInterface {
  final ApiServices apiServices = ApiServices();


  @override
  Future<List<NoteResponse>?> getNoteBook({required int bookId, required int chapterId}) async{
    final BaseResponse<NoteResponse> response = await apiServices.getNoteBook(bookId: bookId, chapterId: chapterId);
    if (response.code != null) {
      List<NoteResponse> data = response.data!;
      return data;
    }
    return null;
  }

  @override
  Future<bool?> saveNoteBook({required int bookId, required int chapterId, required int startPosition, required int endPosition, required String selectedText, required String noteContent}) async{
    final SaveNoteRequest request = SaveNoteRequest(
      bookId: bookId,
      chapterId: chapterId,
      startPosition: startPosition,
      endPosition: endPosition,
      selectedText: selectedText,
      noteContent: noteContent,
    );
    final BaseResponse<NoteResponse> response = await apiServices.sentNoteBook(request);
    if (response.code != null) {
      return true;
    }
    return false;
  }
}
