class DeleteAllNotiRequest {
  DeleteAllNotiRequest({
    required this.action,
  });

  final String? action;

  factory DeleteAllNotiRequest.fromJson(Map<String, dynamic> json){
    return DeleteAllNotiRequest(
      action: json["action"],
    );
  }

  Map<String, dynamic> toJson() => {
    "action": action,
  };

  @override
  String toString(){
    return "$action, ";
  }
}
