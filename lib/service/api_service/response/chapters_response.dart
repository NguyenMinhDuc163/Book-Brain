import 'base_response.dart';

class ChaptersResponse extends BaseResponse{
  ChaptersResponse({
    required this.chapterId,
    required this.bookId,
    required this.title,
    required this.url,
    required this.chapterOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? chapterId;
  final int? bookId;
  final String? title;
  final String? url;
  final int? chapterOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ChaptersResponse.fromJson(Map<String, dynamic> json){
    return ChaptersResponse(
      chapterId: json["chapter_id"],
      bookId: json["book_id"],
      title: json["title"],
      url: json["url"],
      chapterOrder: json["chapter_order"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "chapter_id": chapterId,
    "book_id": bookId,
    "title": title,
    "url": url,
    "chapter_order": chapterOrder,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  @override
  String toString(){
    return "$chapterId, $bookId, $title, $url, $chapterOrder, $createdAt, $updatedAt, ";
  }
}
