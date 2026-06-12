class DeleteAccountResponse {
  DeleteAccountResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.isVerified,
    required this.updatedAt,
  });

  final int? id;
  final String? username;
  final String? email;
  final bool? isVerified;
  final DateTime? updatedAt;

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponse(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      isVerified: json["is_verified"],
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "is_verified": isVerified,
    "updated_at": updatedAt?.toIso8601String(),
  };

  @override
  String toString() {
    return "$id, $username, $email, $isVerified, $updatedAt, ";
  }
}
