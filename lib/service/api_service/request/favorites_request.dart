class FavoritesRequest {
  FavoritesRequest({
    required this.bookId,
    required this.action,
  });

  final int? bookId;
  final String? action;

  factory FavoritesRequest.fromJson(Map<String, dynamic> json){
    return FavoritesRequest(
      bookId: json["book_id"],
      action: json["action"],
    );
  }

  Map<String, dynamic> toJson() => {
    "book_id": bookId,
    "action": action,
  };

  @override
  String toString(){
    return "$bookId, $action, ";
  }
}
