import 'dart:convert';

import 'package:book_brain/service/api_service/response/base_response.dart';

SampleResponse sampleResponseFromJson(String str) =>
    SampleResponse.fromJson(json.decode(str));

String sampleResponseToJson(SampleResponse data) =>
    json.encode(data.toJson());

class SampleResponse extends BaseResponse{
  final int? id;
  final String? username;
  final String? email;

  SampleResponse({
    this.id,
    this.username,
    this.email,
  });

  factory SampleResponse.fromJson(Map<String, dynamic> json) {
    return SampleResponse(
      id: json["id"],
      username: json["username"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
  };

  @override
  String toString() {
    return 'SampleResponse{id: $id, username: $username, email: $email}';
  }
}
