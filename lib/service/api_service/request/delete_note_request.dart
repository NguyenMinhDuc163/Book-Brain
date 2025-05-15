class DeleteNoteRequest {
  DeleteNoteRequest({
    required this.noteId,
  });

  final int? noteId;

  factory DeleteNoteRequest.fromJson(Map<String, dynamic> json){
    return DeleteNoteRequest(
      noteId: json["noteId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "noteId": noteId,
  };

  @override
  String toString(){
    return "$noteId, ";
  }
}
