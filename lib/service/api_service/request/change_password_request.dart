class ChangePasswordRequest {
  ChangePasswordRequest({
    required this.id,
    required this.oldPassword,
    required this.newPassword,
  });

  final int? id;
  final String? oldPassword;
  final String? newPassword;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json){
    return ChangePasswordRequest(
      id: json["id"],
      oldPassword: json["oldPassword"],
      newPassword: json["newPassword"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "oldPassword": oldPassword,
    "newPassword": newPassword,
  };

  @override
  String toString(){
    return "$id, $oldPassword, $newPassword, ";
  }
}
