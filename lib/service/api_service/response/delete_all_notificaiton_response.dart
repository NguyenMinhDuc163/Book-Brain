class DeleteAllNotificaitonResponse {
  DeleteAllNotificaitonResponse({
    required this.count,
  });

  final int? count;

  factory DeleteAllNotificaitonResponse.fromJson(Map<String, dynamic> json){
    return DeleteAllNotificaitonResponse(
      count: json["count"],
    );
  }

  Map<String, dynamic> toJson() => {
    "count": count,
  };

  @override
  String toString(){
    return "$count, ";
  }
}
