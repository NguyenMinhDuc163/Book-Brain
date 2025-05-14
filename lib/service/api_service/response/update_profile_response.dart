class UpdateProfileResponse {
  UpdateProfileResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.clickSendName,
    required this.clickSendKey,
    required this.updatedAt,
  });

  final int? id;
  final String? username;
  final String? email;
  final String? phoneNumber;
  final String? clickSendName;
  final String? clickSendKey;
  final DateTime? updatedAt;

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json){
    return UpdateProfileResponse(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      phoneNumber: json["phone_number"],
      clickSendName: json["click_send_name"],
      clickSendKey: json["click_send_key"],
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "phone_number": phoneNumber,
    "click_send_name": clickSendName,
    "click_send_key": clickSendKey,
    "updated_at": updatedAt?.toIso8601String(),
  };

  @override
  String toString(){
    return "$id, $username, $email, $phoneNumber, $clickSendName, $clickSendKey, $updatedAt, ";
  }
}
