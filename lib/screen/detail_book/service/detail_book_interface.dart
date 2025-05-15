import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/favorites_response.dart';
import 'package:book_brain/service/api_service/response/note_response.dart';
import 'package:book_brain/service/api_service/response/subscriptions_response.dart';

abstract class IDetailBookInterface {
  Future<bool?> saveNoteBook({
    required int bookId,
    required int chapterId,
    required int startPosition,
    required int endPosition,
    required String selectedText,
    required String noteContent,
  });

  Future<List<NoteResponse>?> getNoteBook({
    required int bookId,
    required int chapterId,
  });
}
