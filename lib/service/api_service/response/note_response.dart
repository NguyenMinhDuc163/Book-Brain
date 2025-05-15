class NoteResponse {
  NoteResponse({
    required this.bookId,
    required this.chapterId,
    required this.selectedText,
    required this.noteContent,
    required this.startPosition,
    required this.endPosition,
  });

  final int? bookId;
  final int? chapterId;
  final String? selectedText;
  final String? noteContent;
  final int? startPosition;
  final int? endPosition;

  factory NoteResponse.fromJson(Map<String, dynamic> json){
    return NoteResponse(
      bookId: json["bookId"],
      chapterId: json["chapterId"],
      selectedText: json["selectedText"],
      noteContent: json["noteContent"],
      startPosition: json["startPosition"],
      endPosition: json["endPosition"],
    );
  }

  Map<String, dynamic> toJson() => {
    "bookId": bookId,
    "chapterId": chapterId,
    "selectedText": selectedText,
    "noteContent": noteContent,
    "startPosition": startPosition,
    "endPosition": endPosition,
  };

  @override
  String toString(){
    return "$bookId, $chapterId, $selectedText, $noteContent, $startPosition, $endPosition, ";
  }
}
