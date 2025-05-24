class UserModel {
  final int? id;
  final String? username;
  final String? email;
  final String? createdAt;
  final String? isAds;

  UserModel({
     this.id,
     this.username,
     this.email,
     this.createdAt,
     this.isAds = 'on',
  });

  // Ánh xạ JSON sang User
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      createdAt: json['created_at'] as String?,
      isAds: json['isAds'] as String?,
    );
  }

  // Chuyển đối tượng User sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'isAds': isAds,
    };
  }

  @override
  String toString() {
    return 'UserModel{id: $id, username: $username, email: $email, createdAt: $createdAt, isAds: $isAds}';
  }


}
