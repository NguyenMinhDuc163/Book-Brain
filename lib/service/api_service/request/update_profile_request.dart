class UpdateProfileRequest {
  UpdateProfileRequest({
    this.id,
    this.email,
    this.phoneNumber,
    this.clickSendName,
    this.clickSendKey,
    this.username,
  });

  final int? id;
  final String? email;
  final String? phoneNumber;
  final String? clickSendName;
  final String? clickSendKey;
  final String? username;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProfileRequest(
      id: json["id"],
      email: json["email"],
      phoneNumber: json["phone_number"],
      clickSendName: json["click_send_name"],
      clickSendKey: json["click_send_key"],
      username: json["username"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "phone_number": phoneNumber,
    "click_send_name": clickSendName,
    "click_send_key": clickSendKey,
    "username": username,
  };

  @override
  String toString() {
    return "$id, $email, $phoneNumber, $clickSendName, $clickSendKey, ";
  }
}
